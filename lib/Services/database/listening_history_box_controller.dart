import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/listening_history.dart';

class ListeningHistoryBoxController {
  // Method to call from anywhere in app to store an episode to listening history.
  static Future<bool> saveEpisodeToHistory(ListeningHistoryData data) async {
    Box _box = Hive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox);
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
      return historyList;
    } catch (e) {
      print("error in getting history list: $e");
      return [];
    }
  }
}
