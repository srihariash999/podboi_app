import 'package:hive/hive.dart';
import 'package:podboi/DataModels/episode_data.dart';
part 'song.g.dart';

@HiveType(typeId: 2)
class Song {
  @HiveField(0)
  final String url;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String artist;
  @HiveField(3)
  final String icon;
  @HiveField(4)
  final String album;
  @HiveField(5)
  final int? duration;
  @HiveField(6)
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
      duration: 0,
      episodeData: EpisodeData(
        id: 0,
        guid: "",
        title: "",
        description: "",
        podcastId: 0,
      ),
    );
  }
}
