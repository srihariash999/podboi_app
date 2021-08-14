import 'package:hive/hive.dart';
import 'package:podboi/Services/database/subscriptions.dart';
import 'package:podcast_search/podcast_search.dart';

Future<bool> isPodcastSubbed(Item podcast) async {
  var _isSubbed = false;
  Box _subBox = Hive.box('subscriptionsBox');
  for (var i in _subBox.values) {
    if ((i as Subscription).podcast.collectionId == podcast.collectionId) {
      _isSubbed = true;
    }
  }
  return _isSubbed;
}
