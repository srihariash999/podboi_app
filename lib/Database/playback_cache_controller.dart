import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Database/box_service.dart';

class PlaybackCacheController {
  // Keys
  final String playbackPositionKey = 'playbackPosition';
  final String playbckQueueKey = 'playbackQueue';

  final BoxService _boxService = BoxService();

  /// Gets the box instance
  Future<Box<dynamic>> getBox() =>
      _boxService.getBox<dynamic>(K.boxes.settingsBox);

  /// Constructor to initialize the box
  PlaybackCacheController();

  // Method to call from anywhere in app to store the current state of playback.
  Future<bool> storePlaybackPosition(int duration, Song song) async {
    try {
      var pbState = CachedPlaybackState(duration: duration, song: song);
      final _box = await getBox();
      await _box.put(playbackPositionKey, pbState);
      // print(
      //     " Saved song with name: ${song.name} at duration: $duration in playback cache.");
      return true;
    } catch (e) {
      print("error in saving playback position: $e");
      return false;
    }
  }

  // Methid to call from anywhere in app to store the current queue of songs.
  Future<bool> storePlaybackQueue(List<Song> queue) async {
    try {
      final _box = await getBox();
      await _box.put(playbckQueueKey, queue);
      // print(" Saved queue with length: ${queue.length} in playback cache.");
      return true;
    } catch (e) {
      print("error in saving queue: $e");
      return false;
    }
  }

  // Method to retrieve last saved playback state. (Might be stored at anytime, if needed add expiry.)
  Future<CachedPlaybackState?> getLastSavedPlaybackPosition() async {
    try {
      final _box = await getBox();
      return _box.get(playbackPositionKey);
    } catch (e) {
      print("error in getting playback position: $e");
      return null;
    }
  }

  // Method to retrieve last saved playback queue. (Might be stored at anytime, if needed add expiry.)
  Future<List<Song>?> getLastSavedPlaybackQueue() async {
    try {
      final _box = await getBox();
      var list = _box.get(playbckQueueKey);
      List<Song> queue = [];
      if (list == null) return null;

      for (var i in list) {
        queue.add(i as Song);
      }
      return queue;
    } catch (e) {
      print("error in getting playback queue: $e");
      return null;
    }
  }

  // Method to clear the saved playback state.
  Future<bool> clearSavedPlaybackPosition() async {
    try {
      final _box = await getBox();
      await _box.delete(playbackPositionKey);
      return true;
    } catch (e) {
      print("error in clearing playback position: $e");
      return false;
    }
  }

  // Method to clear the saved playback queue.
  Future<bool> clearSavedPlaybackQueue() async {
    try {
      final _box = await getBox();
      await _box.delete(playbckQueueKey);
      return true;
    } catch (e) {
      print("error in clearing playback queue: $e");
      return false;
    }
  }
}
