import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/subscription_data.dart';

Box<SubscriptionData> _box =
    Hive.box<SubscriptionData>(K.boxes.subscriptionBox);

class SubscriptionBoxController {
  static Future<List<SubscriptionData>> getSubscriptions() async {
    try {
      List<SubscriptionData> subsList = await _box.values.toList();
      return subsList;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> isPodcastSubbed(SubscriptionData subscription) async {
    try {
      var subs = await _box.values.toList();
      var isPodFound = false;

      for (var i in subs) {
        if (i.podcastId == subscription.podcastId) {
          isPodFound = true;
          break;
        }
      }
      return isPodFound;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveSubscription(SubscriptionData subscription) async {
    try {
      await _box.add(subscription);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeSubscription(SubscriptionData subscription) async {
    try {
      var subs = await _box.values.toList();
      var toRemoveId = -1;
      for (var i in subs) {
        if (i.podcastId == subscription.podcastId) {
          toRemoveId = i.id;
          break;
        }
      }
      if (toRemoveId != -1) {
        throw Exception("Podcast not found");
      }

      await _box.delete(toRemoveId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
