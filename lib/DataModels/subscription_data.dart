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
}
