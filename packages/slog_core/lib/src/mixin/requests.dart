import 'package:slog_core/src/errors.dart';
import 'package:slog_core/src/levels.dart';
import 'package:slog_core/src/model.dart';
import 'package:slog_core/src/slogger.dart';

mixin EventRequests on SLogger {
  void log(
    String message, {
    Object? data,
    Level level = Level.INFO,
    String? channel,
  }) {
    SLogChannel? useChannel = null;
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

    requestLog(
      LogRequest(
        LogEvent(
          Log(
            message: message,
            data: data,
          ),
          level: level,
        ),
        channel: useChannel,
      ),
    );
  }
}
