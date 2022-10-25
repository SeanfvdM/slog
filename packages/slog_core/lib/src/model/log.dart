import 'dart:convert';

import 'package:slog_core/slog_core.dart';
import 'package:slog_core/src/levels.dart';

class Log extends ToJsonFunctions {
  Log({
    required this.message,
    this.data,
  });

  final String message;
  final Object? data;

  @override
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      if (data != null) 'data': data,
    };
  }
}

class LogEvent extends ToJsonFunctions {
  LogEvent(this.log, {this.level = Level.INFO});

  final Level level;
  final Log log;

  @override
  Map<String, dynamic> toMap() {
    return {
      'log': log.toMap(),
      'level': level,
    };
  }
}

class LogRequest extends ToJsonFunctions {
  LogRequest(
    this.event, {
    this.channel,
  });

  final LogEvent event;
  final SLogChannel? channel;

  @override
  Map<String, dynamic> toMap() {
    return {
      'event': event.toMap(),
      if (channel != null) 'channel': channel?.name
    };
  }
}

abstract class ToJsonFunctions {
  String toJson() => jsonEncode(
        toMap(),
        toEncodable: (nonEncodable) => nonEncodable.runtimeType.toString(),
      );

  Map<String, dynamic> toMap();
}
