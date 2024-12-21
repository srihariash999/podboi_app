import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/song.dart';

Box _box = Hive.box(K.boxes.settingsBox);

final String _playbackPositionKey = 'playbackPosition';

class PlaybackCacheController {
  static Future<bool> storePlaybackPosition(int duration, Song song) async {
    await _box.put(_playbackPositionKey, duration);
    return true;
  }
}
