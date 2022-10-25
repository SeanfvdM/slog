import 'dart:async';

import 'package:slog_core/src/model.dart';

abstract class SLogPrinter {
  FutureOr<void> printLog(LogRequest request);
}
