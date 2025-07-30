import 'package:hive/hive.dart';
import 'package:podboi/DataModels/song.dart';

part 'cached_playback_state.g.dart';

@HiveType(typeId: 1)
class CachedPlaybackState {
  @HiveField(0)
  final int duration;
  @HiveField(1)
  final Song song;

  CachedPlaybackState({required this.duration, required this.song});

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'song': song.toJson(),
    };
  }
}
