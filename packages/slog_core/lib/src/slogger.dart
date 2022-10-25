import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:slog_core/src/errors.dart';
import 'package:slog_core/src/model.dart';

///The base logger class
abstract class SLogger {
  ///The base logger class
  SLogger({required SLogOptions options}) {
    _options = options;
  }

  late final SLogOptions _options;

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

  ///Used to run the interceptors and printers
  @protected
  @mustCallSuper
  Future<void> requestLog(LogRequest request) async {
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
          return;
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
  }
}
