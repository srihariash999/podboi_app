import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/song.dart';

Box _box = Hive.box(K.boxes.settingsBox);

final String _playbackPositionKey = 'playbackPosition';
final String _playbckQueueKey = 'playbackQueue';

bool logsEnabled = false;

class PlaybackCacheController {
  // Method to call from anywhere in app to store the current state of playback.
  static Future<bool> storePlaybackPosition(int duration, Song song) async {
    var pbState = CachedPlaybackState(duration: duration, song: song);
    await _box.put(_playbackPositionKey, pbState);
    if (logsEnabled) {
      print(
          " Saved song with name: ${song.name} at duration: $duration in playback cache.");
    }
    return true;
  }

  static Future<bool> storePlaybackQueue(List<Song> queue) async {
    await _box.put(_playbckQueueKey, queue);
    if (logsEnabled) {
      print(" Saved queue with length: ${queue.length} in playback cache.");
    }
    return true;
  }

  // Method to retrieve last saved playback state. (Might be stored at anytime, if needed add expiry.)
  static Future<CachedPlaybackState?> getLastSavedPlaybackPosition() async {
    return _box.get(_playbackPositionKey);
  }

  // Method to retrieve last saved playback queue. (Might be stored at anytime, if needed add expiry.)
  static Future<List<Song>?> getLastSavedPlaybackQueue() async {
    try {
      var list = _box.get(_playbckQueueKey);
      List<Song> queue = [];
      for (var i in list) {
        queue.add(i as Song);
      }
      return queue;
    } catch (e) {
      print("error in getting playback queue: $e");
      return null;
    }
  }

  static Future<bool> clearSavedPlaybackPosition() async {
    try {
      await _box.delete(_playbackPositionKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearSavedPlaybackQueue() async {
    try {
      await _box.delete(_playbckQueueKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
