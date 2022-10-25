// ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:slog_core/src/model.dart';

///A log printer
abstract class SLogPrinter {
  ///Use this to print the current request
  ///
  ///Async prints will be awaited before proceeding
  FutureOr<void> printLog(LogRequest request);
}
