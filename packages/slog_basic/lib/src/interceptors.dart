import 'dart:async';
import 'dart:convert';

import 'package:slog_core/slog_core.dart';
import 'package:stack_trace/stack_trace.dart';

///Prints the current Log request in a JSON format
class PrintInterceptor extends SLogInterceptor {
  ///Prints the current Log request in a JSON format
  PrintInterceptor({this.shouldPrint = true});

  ///Will only print if `true`
  final bool shouldPrint;

  @override
  FutureOr<LogRequest> onRequestEvent(LogRequest request) {
    if (shouldPrint) {
      print(_getPrettyLogRequest(request));
    }
    return request;
  }

  String _getPrettyLogRequest(LogRequest request) {
    final prettyJson = _getPrettyJSONString(request.toMap());

    final out = '''
Log Print Interceptor:
├─ Request:
${prettyJson.split('\n').map((e) => '│\t$e').join('\n')}
│
├─ Stack Trace:
${Trace.current().toString().trim().split('\n').map((e) => '│\t$e').join('\n')}
└${''.padRight(50, '─')}''';

    return out;
  }

  String _getPrettyJSONString(Map<String, dynamic> jsonObject) {
    const encoder = JsonEncoder.withIndent('\t');
    return encoder.convert(jsonObject);
  }
}
