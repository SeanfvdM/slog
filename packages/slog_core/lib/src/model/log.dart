import 'dart:convert';

import 'package:slog_core/slog_core.dart';
import 'package:stack_trace/stack_trace.dart';

///The most basic Log.
///
///Used to contain the main data of the Log
class Log extends ToJsonFunctions {
  ///The most basic Log.
  ///
  ///Used to contain the main data of the Log
  Log({
    required this.message,
    this.data,
  });

  ///The log's message
  final String message;

  ///The data linked to the log
  final Object? data;

  @override
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      if (data != null) 'data': data,
    };
  }

  ///Creates a copy of the current log with new data.
  Log copyWith({
    String? message,
    Object? data,
  }) =>
      Log(
        message: message ?? this.message,
        data: data ?? this.data,
      );
}

///A basic log event
///
///Used to hold filtering and some meta data
class LogEvent extends ToJsonFunctions {
  ///A basic log event
  ///
  ///Used to hold filtering and some meta data
  LogEvent(this.log, {this.level = Level.INFO, this.trace});

  ///The logs level
  final Level level;

  ///The log linked to the event
  final Log log;

  ///The stack trace that is associated with the log
  ///
  ///Is stored in the event as stack traces can be large, and the [log] should
  ///only contain data.
  final StackTrace? trace;

  @override
  Map<String, dynamic> toMap() {
    return {
      'log': log.toMap(),
      'level': level,
      if (trace != null) 'trace': Trace.from(trace!).frames.toString()
    };
  }

  ///Creates a copy of the current event with new data.
  LogEvent copyWith({Level? level, Log? log, StackTrace? trace}) => LogEvent(
        log ?? this.log,
        level: level ?? this.level,
        trace: trace ?? this.trace,
      );
}

///A basic Log Request
///
///Used to hold quick access meta data for filtering and request information.
class LogRequest extends ToJsonFunctions {
  ///A basic Log Request
  ///
  ///Used to hold quick access meta data for filtering and request information.
  LogRequest(
    this.event, {
    this.channel,
  });

  ///The log event
  final LogEvent event;

  ///The log channel that was retrieved from the logger
  ///
  ///Is `null` if not specified or if the channel didn't exists
  final SLogChannel? channel;

  @override
  Map<String, dynamic> toMap() {
    return {
      'event': event.toMap(),
      if (channel != null) 'channel': channel?.name
    };
  }

  ///Creates a copy of the current request with new data.
  LogRequest copyWith({
    LogEvent? event,
    SLogChannel? channel,
  }) =>
      LogRequest(
        event ?? this.event,
        channel: channel ?? this.channel,
      );
}

///Adds JSON functions
abstract class ToJsonFunctions {
  ///Converts the current class to JSON
  String toJson() => jsonEncode(
        toMap(),
        toEncodable: (nonEncodable) => nonEncodable.runtimeType.toString(),
      );

  ///Converts the current class to a Map
  Map<String, dynamic> toMap();
}
