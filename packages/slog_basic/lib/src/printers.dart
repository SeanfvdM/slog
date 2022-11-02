import 'dart:async';
import 'dart:convert';

import 'package:slog_core/slog_core.dart';
import 'package:stack_trace/stack_trace.dart';

///Prints the log in a JSON format
class JsonPrinter extends SLogPrinter {
  ///Prints the log in a JSON format
  JsonPrinter({
    this.shouldPrint = true,
    this.printStackTrace = true,
  });

  ///Will only print if `true`
  final bool shouldPrint;

  ///Will add the current stack trace if `true`
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

    //ignore:join_return_with_assignment
    out += '\n└${''.padRight(50, '─')}\n';

    return out;
  }

  String _getPrettyJSONString(Map<String, dynamic> jsonObject) {
    final safeObject = jsonDecode(
      jsonEncode(
        jsonObject,
        toEncodable: (nonEncodable) => nonEncodable.runtimeType.toString(),
      ),
    );
    const encoder = JsonEncoder.withIndent('\t');
    return encoder.convert(safeObject);
  }

  @override
  FutureOr<void> printLog(LogRequest request) {
    if (shouldPrint) {
      print(_getPrettyLogRequest(request));
    }
  }
}
