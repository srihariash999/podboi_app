import 'package:hive/hive.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/subscription_data.dart';

part 'downloaded_episode.g.dart';

@HiveType(typeId: 6)
class DownloadedEpisode {
  @HiveField(0)
  final EpisodeData episode;

  @HiveField(1)
  final String downloadedOn;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final SubscriptionData subscriptionData;

  DownloadedEpisode({
    required this.episode,
    required this.downloadedOn,
    required this.filePath,
    required this.subscriptionData,
  });
}
