import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Controllers/subscription_controller.dart';
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

  static Future<bool> saveSubscription(SubscriptionData subscription,
      {WidgetRef? ref}) async {
    if (subscription.podcastId == null)
      throw "Cannot save this podcast with invalid Id.";
    print(" trying to save a podcast with id: ${subscription.podcastId}");
    await _box.put(subscription.podcastId, subscription);
    print(
        " saved podcast to subs with name: ${subscription.podcastName} and id: ${subscription.podcastId}");

    if (ref != null) {
      try {
        ref.read(subscriptionsPageViewController.notifier).loadSubscriptions();
      } catch (e) {
        print(" cannot update subs list after subscribing to a podcast");
      }
    }

    return true;
  }

  static Future<bool> removeSubscription(SubscriptionData subscription,
      {WidgetRef? ref}) async {
    if (subscription.podcastId == null)
      throw "Cannot remove this podcast without podcast Id.";

    print(" trying to delete a podcast with id: ${subscription.podcastId}");

    await _box.delete(subscription.podcastId!);
    if (ref != null) {
      try {
        ref.read(subscriptionsPageViewController.notifier).loadSubscriptions();
      } catch (e) {
        print(" cannot update subs list after podcast removal");
      }
    }

    return true;
  }
}
