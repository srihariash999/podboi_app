import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/Database/box_service.dart';

/// Controller for managing listening history data operations
class ListeningHistoryBoxController {
  final BoxService _boxService = BoxService();

  /// Gets the box instance
  Future<Box<ListeningHistoryData>> getBox() =>
      _boxService.getBox<ListeningHistoryData>(K.boxes.listeningHistoryBox);

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
    final _box = await getBox();
    final items = _box.values.toList();
    return items;
  }

  /// Removes the oldest item from history
  Future<void> _removeOldestItem(List<ListeningHistoryData> items) async {
    if (items.isEmpty) return;

    final oldestItem = items
        .reduce((a, b) => a.listenedOn.compareTo(b.listenedOn) < 0 ? a : b);

    final _box = await getBox();
    await _box.delete(oldestItem.episodeData.guid.toString());
  }

  /// Saves a new item to history
  Future<void> _saveNewItem(ListeningHistoryData data) async {
    try {
      final _box = await getBox();
      await _box.put(data.episodeData.guid.toString(), data);
    } on Exception catch (e) {
      _handleError(e, 'Failed to save new item');
    }
  }

  /// Handles errors and prints debugging information
  void _handleError(Exception e, String message) {
    print('$message: ${e.toString()}');
  }
}
