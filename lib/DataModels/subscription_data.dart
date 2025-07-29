import 'package:hive/hive.dart';

part 'subscription_data.g.dart';

@HiveType(typeId: 4)
class SubscriptionData {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String podcastName;

  @HiveField(2)
  final int? podcastId;

  @HiveField(3)
  final String feedUrl;

  @HiveField(4)
  final String artworkUrl;

  @HiveField(5)
  final DateTime dateAdded;

  @HiveField(6)
  final DateTime? lastEpisodeDate;

  @HiveField(7)
  final int? trackCount;

  @HiveField(8)
  final DateTime? releaseDate;

  @HiveField(9)
  final String? country;

  @HiveField(10)
  final String? genre;

  @HiveField(11)
  final String? contentAdvisory;

  const SubscriptionData({
    required this.id,
    required this.podcastName,
    this.podcastId,
    required this.feedUrl,
    required this.artworkUrl,
    required this.dateAdded,
    this.lastEpisodeDate,
    this.trackCount,
    this.releaseDate,
    this.country,
    this.genre,
    this.contentAdvisory,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'podcastName': podcastName,
      'podcastId': podcastId,
      'feedUrl': feedUrl,
      'artworkUrl': artworkUrl,
      'dateAdded': dateAdded.toIso8601String(),
      'lastEpisodeDate': lastEpisodeDate?.toIso8601String(),
      'trackCount': trackCount,
      'releaseDate': releaseDate?.toIso8601String(),
      'country': country,
      'genre': genre,
      'contentAdvisory': contentAdvisory,
    };
  }

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      id: json['id'],
      podcastName: json['podcastName'],
      podcastId: json['podcastId'],
      feedUrl: json['feedUrl'],
      artworkUrl: json['artworkUrl'],
      dateAdded: DateTime.parse(json['dateAdded']),
      lastEpisodeDate: json['lastEpisodeDate'] != null
          ? DateTime.parse(json['lastEpisodeDate'])
          : null,
      trackCount: json['trackCount'],
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
      country: json['country'],
      genre: json['genre'],
      contentAdvisory: json['contentAdvisory'],
    );
  }
}
