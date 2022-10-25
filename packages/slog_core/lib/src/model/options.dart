import 'package:slog_core/src/model/interceptor.dart';
import 'package:slog_core/src/model/printer.dart';

///Logger options
class SLogOptions {
  ///Creates LoggerOptions
  const SLogOptions({
    this.interceptors = const [],
    this.printers = const [],
    this.handleMissingChannels = false,
  });

  ///Creates an empty LoggerOptions
  const SLogOptions.none()
      : interceptors = const [],
        printers = const [],
        handleMissingChannels = false;

  ///The interceptors that will be used by the logger
  ///
  ///Interceptors are used in order of their placement in the List and th
  ///request is passed through each interceptor sequentially.
  ///
  ///For example:
  ///```
  ///[A, B, C]
  ///
  ///A -> B -> C
  ///```
  ///If 'A' modified the request then 'B' will get the modified request.
  ///
  ///```
  ///[A, C, B]
  ///
  ///A -> C -> B
  ///```
  ///
  ///If an interceptor fails the next interceptor in the chain will be used.
  final List<SLogInterceptor> interceptors;

  ///The printers that will be used by th logger
  final List<SLogPrinter> printers;

  ///Should the logger throw errors if the channel is missing when a log is
  ///added to a non existent channel.
  final bool handleMissingChannels;
}
