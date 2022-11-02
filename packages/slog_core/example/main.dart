import 'dart:async';
import 'dart:isolate';

import 'package:slog_core/logger.dart';

Future<void> main(List<String> args) async {
  //Init the global logger instance
  Logger.init(
    options: SLogOptions(
      printers: [
        IsolatePrinter(),
      ],
    ),
  );

  Logger.I.log("I'm not in an isolate");

  //Init and await the isolate
  await Logger.I.initIsolate();

  var count = 0;
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    Logger.I.log('Hello from an isolate');
    if (count < 5) {
      count++;
    } else {
      timer.cancel();

      //Close the isolate when you are done using it
      await Logger.I.closeIsolate();
      Logger.I.log("I'm also not in an isolate");
    }
  });

  //The isolate is a different thread so this will get sent to the isolate
  Logger.I.log("I'm in an isolate");
}

class IsolatePrinter extends SLogPrinter {
  @override
  FutureOr<void> printLog(LogRequest request) {
    // ignore: avoid_print
    print(
      '${request.event.log.timestamp} '
      '[${Isolate.current.debugName}] -> '
      '${request.event.log.message}',
    );
  }
}
