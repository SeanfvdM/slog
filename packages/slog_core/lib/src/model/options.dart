import 'package:slog_core/src/model/interceptor.dart';
import 'package:slog_core/src/model/printer.dart';

class SLogOptions {
  const SLogOptions.none()
      : interceptors = const [],
        printers = const [],
        handleMissingChannels = false;

  const SLogOptions(
      {this.interceptors = const [],
      this.printers = const [],
      this.handleMissingChannels = false});

  final List<SLogInterceptor> interceptors;
  final List<SLogPrinter> printers;
  final bool handleMissingChannels;
}
