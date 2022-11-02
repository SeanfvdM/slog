import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:slog_core/src/errors.dart';
import 'package:slog_core/src/levels.dart';
import 'package:slog_core/src/model.dart';

///The base logger class
abstract class SLogger {
  ///The base logger class
  SLogger({required SLogOptions options}) {
    _options = options;
  }

  ///Initialize the logger to run in an isolate so that the logger does not
  /// hinder the main thread performance.
  ///
  ///throws [IsolateSpawnException]
  @mustCallSuper
  Future<void> initIsolate() async {
    if (_isolate != null) {
      throw IsolateSpawnException('Logger isolate is already active.'
          ' Call closeIsolate to recreate the isolate.');
    }
    log('Initializing logger', name: 'SLOG', level: Level.DEBUG());
    final port = ReceivePort();
    _isolate = await Isolate.spawn(
      _handleIsolateLogRequest,
      port.sendPort,
      debugName: 'slogger',
      errorsAreFatal: false,
    );
    _events = StreamQueue<dynamic>(port);
    //The first event will always be a SendPort
    _sendPort = await _events!.next as SendPort;
  }

  ///Close the logger isolate
  ///@mustCallSuper
  Future<void> closeIsolate() async {
    if (_isolate == null) {
      log('Logger isolate never opened', name: 'SLOG', level: Level.WARNING());
    } else {
      _sendPort!.send(null);
      await _events!.cancel();
      log('Logger isolate terminated', name: 'SLOG', level: Level.WARNING());
      _isolate?.kill();
      _isolate = null;
      _sendPort = null;
      _events = null;
    }
  }

  late final SLogOptions _options;
  Isolate? _isolate;
  StreamQueue<dynamic>? _events;
  SendPort? _sendPort;

  ///Get the current options that the logger is using.
  ///
  ///Useful for mixins or when extended.
  @nonVirtual
  SLogOptions get options => _options;

  final Map<String, SLogChannel> _channels = {};

  ///Get the current options that the logger is using.
  ///
  ///Useful for mixins or when extended.
  List<SLogChannel> get channels => _channels.values.toList();

  ///Register a new channel to the logger
  ///
  ///Throws [LogChannelExists]
  @nonVirtual
  void registerChannel(String channel) {
    if (_channels.containsKey(channel)) {
      throw LogChannelExists(channel);
    }

    _channels.addAll({channel: SLogChannel(name: channel)});
  }

  ///Unregister a channel from the logger
  ///
  ///Throws [LogChannelDoesNotExist] if [SLogOptions.handleMissingChannels] is `false`
  @nonVirtual
  void unregisterChannel(String channel) {
    if (_channels.containsKey(channel)) {
      _channels.remove(channel);
    } else {
      if (!options.handleMissingChannels) {
        throw LogChannelDoesNotExist(channel);
      }
    }
  }

  void _handleIsolateLogRequest(SendPort port) {
    //Communication port for main isolate
    final commandPort = ReceivePort();
    port.send(commandPort.sendPort);

    commandPort.listen((message) async {
      if (message != null && message is LogRequest) {
        await _handleLogRequest(message);
      } else {
        port.send(message);
      }
    });
  }

  @protected
  Future<LogRequest?> _handleLogRequest(LogRequest request) async {
    var processedRequest = request;

    for (final interceptor in _options.interceptors) {
      try {
        final newRequest = await interceptor.onRequestEvent(processedRequest);
        if (newRequest == null) {
          log(
            'Interceptor Exited',
            error: json.encode({
              'interceptor': interceptor.runtimeType.toString(),
            }),
            level: 2,
            name: 'slogger.request',
          );
          return null;
        }
        processedRequest = newRequest;
      } catch (e, stack) {
        log(
          'Interceptor Error',
          error: json.encode({
            'error': e.toString(),
            'interceptor': interceptor.runtimeType.toString(),
          }),
          level: 2,
          name: 'slogger.request',
          stackTrace: stack,
        );
      }
    }
    for (final printer in _options.printers) {
      try {
        await printer.printLog(processedRequest);
      } catch (e, stack) {
        log(
          'Printer Error',
          error: json.encode({
            'error': e.toString(),
            'printer': printer.runtimeType.toString(),
          }),
          name: 'slogger.request',
          stackTrace: stack,
        );
      }
    }
    return processedRequest;
  }

  ///Used to run the interceptors and printers
  @protected
  Future<void> requestLog(LogRequest request) async {
    if (_isolate != null) {
      _sendPort!.send(request);
    } else {
      await _handleLogRequest(request);
    }
  }
}
