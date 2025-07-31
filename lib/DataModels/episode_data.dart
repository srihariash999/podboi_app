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
  final int podcastId;

  @HiveField(13)
  final String? podcastName;

  @HiveField(14)
  final int? playedDuration;

  const EpisodeData(
      {required this.id,
      required this.guid,
      required this.title,
      required this.description,
      required this.podcastId,
      this.link,
      this.publicationDate,
      this.contentUrl,
      this.imageUrl,
      this.author,
      this.season,
      this.episodeNumber,
      this.duration,
      this.podcastName,
      this.playedDuration});

  EpisodeData copyWith({int? playedDuration}) {
    return EpisodeData(
      id: this.id,
      guid: this.guid,
      title: this.title,
      description: this.description,
      link: this.link,
      publicationDate: this.publicationDate,
      contentUrl: this.contentUrl,
      imageUrl: this.imageUrl,
      author: this.author,
      season: this.season,
      episodeNumber: this.episodeNumber,
      duration: this.duration,
      podcastId: this.podcastId,
      podcastName: this.podcastName,
      playedDuration: playedDuration ?? this.playedDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guid': guid,
      'title': title,
      'description': description,
      'link': link,
      'publicationDate': publicationDate?.toIso8601String(),
      'contentUrl': contentUrl,
      'imageUrl': imageUrl,
      'author': author,
      'season': season,
      'episodeNumber': episodeNumber,
      'duration': duration,
      'podcastId': podcastId,
      'podcastName': podcastName,
      'playedDuration': playedDuration,
    };
  }

  factory EpisodeData.fromJson(Map<String, dynamic> json) {
    return EpisodeData(
      id: json['id'],
      guid: json['guid'],
      title: json['title'],
      description: json['description'],
      link: json['link'],
      publicationDate: json['publicationDate'] != null
          ? DateTime.parse(json['publicationDate'])
          : null,
      contentUrl: json['contentUrl'],
      imageUrl: json['imageUrl'],
      author: json['author'],
      season: json['season'],
      episodeNumber: json['episodeNumber'],
      duration: json['duration'],
      podcastId: json['podcastId'],
      podcastName: json['podcastName'],
      playedDuration: json['playedDuration'],
    );
  }
}
