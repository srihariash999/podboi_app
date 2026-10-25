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

  /// Feed URLs are the portable identity supplied by OPML. Provider IDs are
  /// still used as storage keys, but differ between apps and search providers.
  Future<SubscriptionData?> findSubscriptionByFeedUrl(String feedUrl) async {
    final normalizedFeedUrl = _normalizeFeedUrl(feedUrl);
    if (normalizedFeedUrl.isEmpty) return null;
    final box = await getBox();
    for (final subscription in box.values) {
      if (_normalizeFeedUrl(subscription.feedUrl) == normalizedFeedUrl) {
        return subscription;
      }
    }
    return null;
  }

  Future<SubscriptionData?> findSubscription(
      SubscriptionData subscription) async {
    final box = await getBox();
    if (subscription.podcastId != null) {
      final byId = box.get(subscription.podcastId);
      if (byId != null) return byId;
    }
    final byFeedUrl = await findSubscriptionByFeedUrl(subscription.feedUrl);
    if (byFeedUrl != null) return byFeedUrl;

    // Podcast directories sometimes expose an alias/redirect URL instead of
    // the OPML URL. Only after ID and canonical feed URL checks fail, use the
    // normalized title as a conservative fallback to avoid a second entry.
    final normalizedTitle = _normalizeTitle(subscription.podcastName);
    if (normalizedTitle.isEmpty) return null;
    for (final savedSubscription in box.values) {
      if (_normalizeTitle(savedSubscription.podcastName) == normalizedTitle) {
        return savedSubscription;
      }
    }
    return null;
  }

  Future<bool> isPodcastSubbed(SubscriptionData subscription) async {
    try {
      return await findSubscription(subscription) != null;
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

    final existing = await findSubscription(subscription);
    if (existing != null) return true;

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

    final existing = await findSubscription(subscription);
    if (existing == null) return true;

    final _box = await getBox();
    await _box.delete(existing.podcastId ?? existing.id);
    if (ref != null) {
      try {
        ref.read(subscriptionsPageViewController.notifier).loadSubscriptions();
      } catch (e) {
        print(" cannot update subs list after podcast removal");
      }
    }

    return true;
  }

  Future<void> updateSubscriptionMetadata(
    SubscriptionData subscription, {
    String? podcastName,
    String? artworkUrl,
    int? trackCount,
    DateTime? lastEpisodeDate,
  }) async {
    final normalizedName = podcastName?.trim();
    final normalizedArtwork = artworkUrl?.trim();
    final updated = subscription.copyWith(
      podcastName: normalizedName == null || normalizedName.isEmpty
          ? subscription.podcastName
          : normalizedName,
      artworkUrl: normalizedArtwork == null || normalizedArtwork.isEmpty
          ? subscription.artworkUrl
          : normalizedArtwork,
      trackCount: trackCount,
      lastEpisodeDate: lastEpisodeDate,
    );
    if (updated.podcastName == subscription.podcastName &&
        updated.artworkUrl == subscription.artworkUrl &&
        updated.trackCount == subscription.trackCount &&
        updated.lastEpisodeDate == subscription.lastEpisodeDate) {
      return;
    }
    final box = await getBox();
    await box.put(updated.podcastId ?? updated.id, updated);
  }

  String _normalizeFeedUrl(String feedUrl) {
    final uri = Uri.tryParse(feedUrl.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return feedUrl.trim().toLowerCase();
    }
    final query = Map<String, String>.from(uri.queryParameters)
      ..removeWhere((key, _) =>
          key.toLowerCase().startsWith('utm_') ||
          key.toLowerCase() == 'fbclid');
    final path = uri.path.length > 1 && uri.path.endsWith('/')
        ? uri.path.substring(0, uri.path.length - 1)
        : uri.path;
    return Uri(
      scheme: uri.scheme.toLowerCase(),
      host: uri.host.toLowerCase(),
      port: uri.hasPort ? uri.port : null,
      path: path,
      queryParameters: query.isEmpty ? null : query,
    ).toString();
  }

  String _normalizeTitle(String title) =>
      title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
}
