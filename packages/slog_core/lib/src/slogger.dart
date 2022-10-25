import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:slog_core/src/errors.dart';
import 'package:slog_core/src/model.dart';

abstract class SLogger {
  SLogger({required SLogOptions options}) {
    _options = options;
  }

  late final SLogOptions _options;

  @nonVirtual
  SLogOptions get options => _options;

  final Map<String, SLogChannel> _channels = {};

  @nonVirtual
  void registerChannel(String channel) {
    if (_channels.containsKey(channel)) {
      throw LogChannelExists(channel);
    }

    _channels.addAll({channel: SLogChannel(name: channel)});
  }

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

  List<SLogChannel> get channels => _channels.values.toList();

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
