import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/listening_history.dart';

/// Controller for managing listening history data operations
class ListeningHistoryBoxController {
  /// The Hive box containing listening history data
  final Box<ListeningHistoryData> _box;

  /// Constructor to initialize the box
  ListeningHistoryBoxController(this._box);

  /// Gets the box instance
  Box<ListeningHistoryData> get box => _box;

  /// Initializes a new instance of [ListeningHistoryBoxController] with specified box
  factory ListeningHistoryBoxController.initialize() {
    return ListeningHistoryBoxController(
      Hive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox),
    );
  }

  /// Gets the list of listening history from the box
  Future<List<ListeningHistoryData>> getHistoryList() async {
    try {
      final items = await _getHistoryItems();
      if (items.isEmpty) return [];

      return items;
    } on Exception catch (e) {
      _handleError(e, 'Failed to get history list');
      return [];
    }
  }

  /// Saves an episode to listening history
  Future<bool> saveEpisodeToHistory(ListeningHistoryData data) async {
    try {
      final items = await _getHistoryItems();
      if (items.length >= 1000) {
        await _removeOldestItem(items);
      }
      await _saveNewItem(data);
      return true;
    } on Exception catch (e) {
      _handleError(e, 'Failed to save episode to history');
      return false;
    }
  }

  /// Gets the list of history items from box
  Future<List<ListeningHistoryData>> _getHistoryItems() async {
    final items = _box.values.toList();
    return items;
  }

  /// Removes the oldest item from history
  Future<void> _removeOldestItem(List<ListeningHistoryData> items) async {
    if (items.isEmpty) return;

    final oldestItem = items
        .reduce((a, b) => a.listenedOn.compareTo(b.listenedOn) < 0 ? a : b);

    await _box.delete(oldestItem.episodeData.guid.toString());
  }

  /// Saves a new item to history
  Future<void> _saveNewItem(ListeningHistoryData data) async {
    try {
      await _box.put(data.episodeData.guid.toString(), data);
    } on Exception catch (e) {
      _handleError(e, 'Failed to save new item');
    }
  }

  /// Handles errors and prints debugging information
  void _handleError(Exception e, String message) {
    print('$message: ${e.toString()}');
    // You can add additional error handling logic here
  }
}
