import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Services/database/database.dart';
// import 'package:podcast_search/podcast_search.dart';

final _db = MyDb();

final databaseServiceProvider = Provider((ref) {
  return DatabaseService();
});

class DatabaseService {
  /// Method that saves a given podcast item to user's subscriptions.
  Future<bool> savePodcastToSubs(SubscriptionData podcast) async {
    try {
      // Try and create subscription.
      await _db.insertSubscription(
        podcast.podcastName,
        podcast.podcastId,
        podcast.feedUrl,
        podcast.artworkUrl,
        DateTime.now(),
        null,
        podcast.trackCount,
      );

      // If the saving was a success, return true.
      return true;
    } catch (e) {
      print(" error saving podcast: $e");

      //if saving failed, return false.
      return false;
    }
  }

  Future<bool> isPodcastSubbed(SubscriptionData podcast) async {
    // If the collection id being queried is null, return false.
    if (podcast.podcastId == null) return false;

    // Get stored subs with given id.
    var res = await _db.selectSubscriptionUsingId(podcast.podcastId).get();

    // If the result is empty, podcast is not subbed.
    if (res.isEmpty) return false;

    // If not empty, podcast is subbed.
    return true;
  }

  Future<List<SubscriptionData>> getAllSubscriptions() async {
    try {
      var res = await _db.selectAllSubscriptions().get();
      return res;
    } catch (e) {
      return [];
    }
  }

  Future<bool> removePodcastFromSubs(SubscriptionData podcast) async {
    try {
      await _db.deleteSubscriptionUsingId(podcast.podcastId);
      return true;
    } catch (e) {
      print(" error deleting podcast: $e");
      return false;
    }
  }
}



// Future<bool> removePodcastFromSubs(Item podcast) async {
//   Box _subBox = Hive.box('subscriptionsBox');
//   try {
//     var _key;
//     for (var i in _subBox.keys) {
//       var value = _subBox.get(i);
//       Item savedItem = itemFromMap((value as Subscription).podcast);
//       if (savedItem.collectionId == podcast.collectionId) {
//         _key = i;
//         break;
//       }
//     }
//     if (_key != null) {
//       await _subBox.delete(_key);
//       return true;
//     } else {
//       print("Somehow cannot find the saved item");
//       return false;
//     }
//   } catch (e) {
//     print(" error deleting podcast: $e");
//     return false;
//   }
// }

// Future<List<ListeningHistoryItem>> getLhiList() async {
//   List<ListeningHistoryItem> _lhis = [];
//   List _l = _historyBox.values.toList();
//   for (int i = 0; i < _l.length; i++) {
//     int key = _historyBox.keyAt(i);
//     ListeningHistoryItem _lhi = lhiFromMap(_l[i]);
//     _lhi.id = key;
//     _lhis.add(_lhi);
//   }
//   _lhis = _lhis.reversed.toList();
//   return _lhis;
// }

// Future<bool> saveLhi(ListeningHistoryItem lhi) async {
//   print(" here to save to history yo ${lhi.name} ");
//   _historyBox.add(lhiToMap(lhi));
//   return true;
// }

// Future<bool> removeLhiItem(int key) async {
//   try {
//     _historyBox.delete(key);
//     return true;
//   } catch (e) {
//     print("error removing item: $e");
//     return false;
//   }
// }