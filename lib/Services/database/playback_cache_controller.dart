import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/song.dart';

Box _box = Hive.box(K.boxes.settingsBox);

final String _playbackPositionKey = 'playbackPosition';

class PlaybackCacheController {
  // Method to call from anywhere in app to store the current state of playback.
  static Future<bool> storePlaybackPosition(int duration, Song song) async {
    var pbState = CachedPlaybackState(duration: duration, song: song);
    await _box.put(_playbackPositionKey, pbState);
    print(
        " Saved song with name: ${song.name} at duration: $duration in playback cache.");
    return true;
  }

  // Method to retrieve last saved playback state. (Might be stored at anytime, if needed add expiry.)
  static Future<CachedPlaybackState?> getLastSavedPlaybackPosition() async {
    return _box.get(_playbackPositionKey);
  }

  static Future<bool> clearSavedPlaybackPosition() async {
    try {
      await _box.delete(_playbackPositionKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
