class Song {
  final String url;
  final String name;
  final String artist;
  final String icon;
  final String album;
  final Duration? duration;
  Song(
      {required this.url,
      required this.name,
      required this.artist,
      required this.icon,
      required this.album,
      required this.duration});
}
