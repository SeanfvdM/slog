import 'dart:async';

import 'package:slog_core/src/model/log.dart';

///An interface for Logger interceptors
abstract class SLogInterceptor {
  ///The `onRequestEvent` is called before running any printers. The request,
  ///event and log can be manipulated in the request just return the new value.
  ///
  ///If the interceptor is async the logger will wait for it to complete or fail
  ///before proceeding.
  ///
  ///Return null if the log should not be processed further
  FutureOr<LogRequest?> onRequestEvent(LogRequest request) => request;
}
