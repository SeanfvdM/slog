import 'dart:async';

import 'package:slog_core/src/errors.dart';
import 'package:slog_core/src/levels.dart';
import 'package:slog_core/src/model.dart';
import 'package:slog_core/src/slogger.dart';

///Adds log methods for basic events
mixin EventRequests on SLogger {
  ///Log an event to the logger
  ///
  ///- [message] is the message of the log
  ///- [data] is additional data for the log
  ///- [level] is the log level
  ///- [channel] is the channel this log belongs to. Example `'event'` or `'network'`
  ///- [trace] is a Stack Trace associated with the current log
  ///
  ///Throws [LogChannelDoesNotExist] if [SLogOptions.handleMissingChannels] is `false`
  void log(
    String message, {
    Object? data,
    Level level = Level.INFO,
    String? channel,
    StackTrace? trace,
  }) {
    SLogChannel? useChannel;
    if (channel != null) {
      try {
        useChannel = channels.firstWhere(
          (c) => c.name == channel,
        );
      } catch (_) {
        if (!options.handleMissingChannels) {
          throw LogChannelDoesNotExist(channel);
        }
      }
    }

    unawaited(
      requestLog(
        LogRequest(
          LogEvent(
            Log(
              message: message,
              data: data,
            ),
            trace: trace,
            level: level,
          ),
          channel: useChannel,
        ),
      ),
    );
  }
}
