import 'package:hive/hive.dart';
import 'package:podboi/DataModels/ListeningHistoryItem.dart';
import 'package:podboi/Services/conversion_helpers.dart';
// import 'package:podboi/Services/conversion_helpers.dart';
import 'package:podboi/Services/database/subscriptions.dart';
import 'package:podcast_search/podcast_search.dart';

Box _historyBox = Hive.box('historyBox');

Future<bool> isPodcastSubbed(Item podcast) async {
  var _isSubbed = false;
  Box _subBox = Hive.box('subscriptionsBox');
  for (var i in _subBox.values) {
    Item savedItem = itemFromMap((i as Subscription).podcast);
    if (savedItem.collectionId == podcast.collectionId) {
      _isSubbed = true;
      break;
    }
  }
  return _isSubbed;
}

Future<bool> savePodcastToSubs(Item podcast) async {
  Box _subBox = Hive.box('subscriptionsBox');
  try {
    var _isSubbed = false;
    for (var i in _subBox.values) {
      Item savedItem = itemFromMap((i as Subscription).podcast);
      if (savedItem.collectionId == podcast.collectionId) {
        _isSubbed = true;
        break;
      }
    }
    if (!_isSubbed) {
      await _subBox.add(
        Subscription(
          podcast: itemToMap(podcast),
          dateAdded: DateTime.now(),
        ),
      );
      return true;
    } else {
      print("podcast is alreadyy saved.");
      return false;
    }
  } catch (e) {
    print(" error saving podcast: $e");
    return false;
  }
}

Future<bool> removePodcastFromSubs(Item podcast) async {
  Box _subBox = Hive.box('subscriptionsBox');
  try {
    var _key;
    for (var i in _subBox.keys) {
      var value = _subBox.get(i);
      Item savedItem = itemFromMap((value as Subscription).podcast);
      if (savedItem.collectionId == podcast.collectionId) {
        _key = i;
        break;
      }
    }
    if (_key != null) {
      await _subBox.delete(_key);
      return true;
    } else {
      print("Somehow cannot find the saved item");
      return false;
    }
  } catch (e) {
    print(" error deleting podcast: $e");
    return false;
  }
}

Future<List<ListeningHistoryItem>> getLhiList() async {
  List<ListeningHistoryItem> _lhis = [];
  for (var i in _historyBox.values) {
    _lhis.add(lhiFromMap(i));
  }
  return _lhis;
}

Future<bool> saveLhi(ListeningHistoryItem lhi) async {
  print(" here to save to history yo ${lhi.name} ");
  _historyBox.add(lhiToMap(lhi));
  return true;
}
