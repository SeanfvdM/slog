class LogChannelExists extends Error {
  LogChannelExists(this.channel);

  final String channel;

  @override
  String toString() => 'Channel exists: ${Error.safeToString(channel)}';
}

class LogChannelDoesNotExist extends Error {
  LogChannelDoesNotExist(this.channel);

  final String channel;

  @override
  String toString() =>
      'Channel does not exists: ${Error.safeToString(channel)}';
}
