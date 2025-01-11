import 'package:hive/hive.dart';
import 'package:podboi/DataModels/episode_data.dart';

part 'listening_history.g.dart';

@HiveType(typeId: 5)
class ListeningHistoryData {
  @HiveField(0)
  final String listenedOn;

  @HiveField(1)
  final EpisodeData episodeData;

  const ListeningHistoryData({
    required this.listenedOn,
    required this.episodeData,
  });
}
