class ListeningHistoryData {
  final int id;
  final String url;
  final String artist;
  final String icon;
  final String album;
  final String duration;
  final String podcastName;
  final String podcastArtwork;
  final String listenedOn;
  final String name;
  const ListeningHistoryData(
      {required this.id,
      required this.url,
      required this.artist,
      required this.icon,
      required this.album,
      required this.duration,
      required this.podcastName,
      required this.podcastArtwork,
      required this.listenedOn,
      required this.name});
}
