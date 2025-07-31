import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Controllers/subscription_controller.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Database/box_service.dart';

class SubscriptionBoxController {
  final BoxService _boxService = BoxService();

  /// Gets the box instance
  Future<Box<SubscriptionData>> getBox() =>
      _boxService.getBox<SubscriptionData>(K.boxes.subscriptionBox);

  Future<List<SubscriptionData>> getSubscriptions() async {
    try {
      final _box = await getBox();
      List<SubscriptionData> subsList = await _box.values.toList();
      return subsList;
    } catch (e) {
      return [];
    }
  }

  Future<bool> isPodcastSubbed(SubscriptionData subscription) async {
    try {
      final _box = await getBox();
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
      print("Error while checking if podcast is subbed: $e");
      return false;
    }
  }

  Future<bool> saveSubscription(SubscriptionData subscription,
      {WidgetRef? ref}) async {
    if (subscription.podcastId == null)
      throw "Cannot save this podcast with invalid Id.";
    print(" trying to save a podcast with id: ${subscription.podcastId}");

    final _box = await getBox();
    await _box.put(subscription.podcastId, subscription);
    print(
        " saved podcast to subs with name: ${subscription.podcastName} and id: ${subscription.podcastId}");

    if (ref != null) {
      try {
        ref.read(subscriptionsPageViewController.notifier).loadSubscriptions();
      } catch (e) {
        print(" cannot update subs list after subscribing to a podcast $e");
      }
    }

    return true;
  }

  Future<bool> removeSubscription(SubscriptionData subscription,
      {WidgetRef? ref}) async {
    if (subscription.podcastId == null)
      throw "Cannot remove this podcast without podcast Id.";

    print(" trying to delete a podcast with id: ${subscription.podcastId}");

    final _box = await getBox();
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
