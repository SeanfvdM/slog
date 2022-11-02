library slog_core.logger;

import 'package:slog_core/slog_core.dart';

export 'src/levels.dart';
export 'src/model.dart';

///The main logger for SLog and its dependencies
class Logger extends SLogger with EventRequests {
  ///Creates a new instance of the base logger
  Logger({required super.options});

  ///Init the global instance of the SLog with options
  factory Logger.init({
    SLogOptions options = const SLogOptions.none(),
  }) {
    return _instance = Logger(options: options);
  }

  Logger._default() : super(options: const SLogOptions.none());

  static Logger _instance = Logger._default();

  ///Get the global instance of the SLog
  static Logger get instance => _instance;

  ///Get the global instance of the SLog
  static Logger get I => _instance;
}
