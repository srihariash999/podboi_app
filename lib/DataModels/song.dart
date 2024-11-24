import 'package:podboi/Services/database/database.dart';

class Song {
  final String url;
  final String name;
  final String artist;
  final String icon;
  final String album;
  final Duration? duration;
  final EpisodeData episodeData;
  Song({
    required this.url,
    required this.name,
    required this.artist,
    required this.icon,
    required this.album,
    required this.duration,
    required this.episodeData,
  });

  factory Song.dummy() {
    return Song(
      url: "",
      name: "",
      artist: "",
      icon: "",
      album: "",
      duration: Duration.zero,
      episodeData: EpisodeData(
        id: 0,
        guid: "",
        title: "",
        description: "",
      ),
    );
  }
}
