import 'dart:async';

import 'package:slog_core/src/model/log.dart';

abstract class SLogInterceptor {
  FutureOr<LogRequest?> onRequestEvent(LogRequest request) => request;
}
