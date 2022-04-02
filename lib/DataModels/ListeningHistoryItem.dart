class ListeningHistoryItem {
  int? id;
  final String url;
  final String name;
  final String artist;
  final String icon;
  final String album;
  final String duration;

  final String podcastName;
  final String podcastArtWork;
  final String listenedOn;

  ListeningHistoryItem({
    this.id,
    required this.url,
    required this.name,
    required this.artist,
    required this.icon,
    required this.album,
    required this.duration,
    required this.listenedOn,
    required this.podcastArtWork,
    required this.podcastName,
  });
}
