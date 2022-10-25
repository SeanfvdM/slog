class Level {
  const Level(this.name, this.value);

  final String name;
  final int value;

  int call() => value;

  @override
  String toString() => name;

  /// Special key to turn on logging for all levels ([value] = 0).
  static const Level ALL = Level('ALL', 0);

  /// Special key to turn off all logging ([value] = 2000).
  static const Level OFF = Level('OFF', 2000);

  /// Key for tracing information ([value] = 500).
  static const Level DEBUG = Level('DEBUG', 500);

  /// Key for informational messages ([value] = 800).
  static const Level INFO = Level('INFO', 800);

  /// Key for potential problems ([value] = 900).
  static const Level WARNING = Level('WARNING', 900);

  /// Key for serious failures ([value] = 1000).
  static const Level ERROR = Level('ERROR', 1000);
}
