///An error used for when the Channel exists
class LogChannelExists extends Error {
  ///An error used for when the Channel exists
  LogChannelExists(this.channel);

  ///The channel name
  final String channel;

  @override
  String toString() => 'Channel exists: ${Error.safeToString(channel)}';
}

///An error used for when the Channel does not exists
class LogChannelDoesNotExist extends Error {
  ///An error used for when the Channel does not exists
  LogChannelDoesNotExist(this.channel);

  ///The channel name
  final String channel;

  @override
  String toString() =>
      'Channel does not exists: ${Error.safeToString(channel)}';
}
