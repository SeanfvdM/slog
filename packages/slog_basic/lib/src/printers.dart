import 'dart:async';
import 'dart:convert';

import 'package:slog_core/slog_core.dart';
import 'package:stack_trace/stack_trace.dart';

class JsonPrinter extends SLogPrinter {
  JsonPrinter({
    this.shouldPrint = true,
    this.printStackTrace = true,
  });

  final bool shouldPrint;
  final bool printStackTrace;

  String _getPrettyLogRequest(LogRequest request) {
    final prettyJson = _getPrettyJSONString(request.event.log.toMap());

    var out = '\n${request.event.log.message}';
    if (request.event.log.data != null) {
      out += '\n├─ Data:\n';
      out += prettyJson.split('\n').map((e) => '│\t$e').join('\n');
    }
    if (printStackTrace && request.event.log.data != null) {
      out += '\n│';
    }
    if (printStackTrace) {
      out += '\n├─ Stack Trace:\n';
      out += Trace.current()
          .toString()
          .trim()
          .split('\n')
          .map((e) => '│\t$e')
          .join('\n')
          .trim();
    }

    out += '\n└${''.padRight(50, '─')}\n';

    return out;
  }

  String _getPrettyJSONString(Map<String, dynamic> jsonObject) {
    const encoder = JsonEncoder.withIndent('\t');
    return encoder.convert(jsonObject);
  }

  @override
  FutureOr<void> printLog(LogRequest request) {
    if (shouldPrint) {
      print(_getPrettyLogRequest(request));
    }
  }
}
