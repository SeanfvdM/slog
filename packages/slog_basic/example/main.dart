import 'dart:async';

import 'package:slog_basic/slog_basic.dart';
import 'package:slog_basic/src/printers.dart';
import 'package:slog_core/logger.dart';

void main(List<String> args) {
  Logger.init(
    options: SLogOptions(
      interceptors: [
        PrintInterceptor(),
      ],
      printers: [
        JsonPrinter(),
      ],
    ),
  )
    ..registerChannel('event')
    ..registerChannel('api');

  var counter = 3;
  Timer.periodic(const Duration(seconds: 2), (timer) {
    Logger.I.log('Tick', level: Level.INFO, data: timer.tick, channel: 'event');
    counter--;
    if (counter == 0) {
      Logger.I.log('Timer cancel', level: Level.WARNING, channel: 'api');
      timer.cancel();
    }
  });
}
