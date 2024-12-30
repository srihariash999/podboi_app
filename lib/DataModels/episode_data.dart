import 'package:hive/hive.dart';

part 'episode_data.g.dart';

@HiveType(typeId: 3)
class EpisodeData {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String guid;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String? link;
  @HiveField(5)
  final DateTime? publicationDate;
  @HiveField(6)
  final String? contentUrl;
  @HiveField(7)
  final String? imageUrl;
  @HiveField(8)
  final String? author;
  @HiveField(9)
  final int? season;
  @HiveField(10)
  final int? episodeNumber;
  @HiveField(11)
  final int? duration;
  @HiveField(12)
  final int? podcastId;
  @HiveField(13)
  final String? podcastName;
  const EpisodeData(
      {required this.id,
      required this.guid,
      required this.title,
      required this.description,
      this.link,
      this.publicationDate,
      this.contentUrl,
      this.imageUrl,
      this.author,
      this.season,
      this.episodeNumber,
      this.duration,
      this.podcastId,
      this.podcastName});
}
