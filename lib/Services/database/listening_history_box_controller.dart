import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/listening_history.dart';

class ListeningHistoryBoxController {
  // Method to call from anywhere in app to store an episode to listening history.
  static Future<bool> saveEpisodeToHistory(ListeningHistoryData data) async {
    Box _box = Hive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox);

    List<ListeningHistoryData> items = [];

    for (var i in _box.values.toList()) {
      items.add(i as ListeningHistoryData);
    }

    if (items.length >= 1000) {
      // remove the oldest item
      items.sort((a, b) => a.listenedOn.compareTo(b.listenedOn));
      _box.delete(items[0].episodeData.guid.toString());
    }

    await _box.put(data.episodeData.guid.toString(), data);
    print(" saved episode to history with id: ${data.episodeData.guid}");
    return true;
  }

  // Method to call from UI to get list of episodes from history.
  static Future<List<ListeningHistoryData>> getHistoryList() async {
    try {
      Box _box = Hive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox);
      var list = _box.values.toList();
      List<ListeningHistoryData> historyList = [];
      for (var i in list) {
        historyList.add(i as ListeningHistoryData);
      }
      // sort the list by date
      historyList.sort((a, b) => b.listenedOn.compareTo(a.listenedOn));
      return historyList;
    } catch (e) {
      print("error in getting history list: $e");
      return [];
    }
  }
}
