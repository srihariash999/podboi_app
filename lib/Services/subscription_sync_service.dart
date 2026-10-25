import 'dart:async';

import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Database/podcast_episode_box_controller.dart';
import 'package:podboi/Database/settings_box_controller.dart';
import 'package:podboi/Database/subscription_box_controller.dart';
import 'package:podboi/Services/podcasting2_0_repository.dart';
import 'package:podcast_search/podcast_search.dart' as podcast_search;

/// Coordinates background feed updates without making cached screens wait for
/// the network. Hive remains the source read by the presentation layer.
class SubscriptionSyncService {
  SubscriptionSyncService({
    SettingsBoxController? settings,
    SubscriptionBoxController? subscriptions,
    PodcastEpisodeBoxController? episodes,
    Podcasting20Repository? podcasting20,
  })  : _settings = settings ?? SettingsBoxController(),
        _subscriptions = subscriptions ?? SubscriptionBoxController(),
        _episodes = episodes ?? PodcastEpisodeBoxController(),
        _podcasting20 = podcasting20 ?? Podcasting20Repository();

  static const _automaticInterval = Duration(hours: 1);
  final SettingsBoxController _settings;
  final SubscriptionBoxController _subscriptions;
  final PodcastEpisodeBoxController _episodes;
  final Podcasting20Repository _podcasting20;
  static Future<SubscriptionSyncReport>? _inFlight;

  Future<SubscriptionSyncReport> syncIfDue() {
    return _start(force: false);
  }

  Future<SubscriptionSyncReport> refreshNow() {
    return _start(force: true);
  }

  Future<SubscriptionSyncReport> _start({required bool force}) {
    return _inFlight ??=
        _run(force: force).whenComplete(() => _inFlight = null);
  }

  Future<SubscriptionSyncReport> _run({required bool force}) async {
    final now = DateTime.now();
    final previousAttempt = await _settings.getSubscriptionSyncAttempt();
    if (!force &&
        previousAttempt != null &&
        now.difference(previousAttempt) < _automaticInterval) {
      return const SubscriptionSyncReport.skipped();
    }

    // This timestamp intentionally records an eligible launch attempt, not a
    // success. It prevents cold start followed by resume from starting a
    // duplicate sync job. Success is persisted independently below.
    await _settings.saveSubscriptionSyncAttempt(now);
    final subscriptions = await _subscriptions.getSubscriptions();
    if (subscriptions.isEmpty) return const SubscriptionSyncReport.empty();

    var updatedFeeds = 0;
    final failures = <SubscriptionSyncFailure>[];
    const concurrency = 3;
    for (var start = 0; start < subscriptions.length; start += concurrency) {
      final batch = subscriptions.skip(start).take(concurrency);
      final results = await Future.wait(batch.map((subscription) async {
        try {
          await syncPodcast(subscription);
          return true;
        } catch (error) {
          failures.add(SubscriptionSyncFailure(subscription, error));
          return false;
        }
      }));
      updatedFeeds += results.where((success) => success).length;
    }

    if (updatedFeeds > 0) {
      await _settings.saveSuccessfulSubscriptionSync(DateTime.now());
    }
    return SubscriptionSyncReport(
        updatedFeeds: updatedFeeds, failures: failures);
  }

  /// Updates just one feed. Existing episode rows not represented by the feed
  /// are deliberately retained, including history and downloaded media.
  Future<List<EpisodeData>> syncPodcast(SubscriptionData subscription) async {
    // An OPML subscription has a local stable ID, whereas a search result has
    // the provider's ID. Resolve the feed first so both paths share one cache.
    final savedSubscription =
        await _subscriptions.findSubscriptionByFeedUrl(subscription.feedUrl);
    final targetSubscription = savedSubscription ?? subscription;
    final podcast =
        await podcast_search.Feed.loadFeed(url: targetSubscription.feedUrl);
    final podcastId = targetSubscription.podcastId;
    if (podcastId == null) {
      throw ArgumentError.value(targetSubscription.podcastId, 'podcastId');
    }
    if (savedSubscription != null) {
      final latestEpisodeDate = podcast.episodes
          .map((episode) => episode.publicationDate)
          .whereType<DateTime>()
          .fold<DateTime?>(null, (latest, date) {
        return latest == null || date.isAfter(latest) ? date : latest;
      });
      await _subscriptions.updateSubscriptionMetadata(
        savedSubscription,
        podcastName: podcast.title,
        artworkUrl: podcast.image,
        trackCount: podcast.episodes.length,
        lastEpisodeDate: latestEpisodeDate,
      );
    }
    final seen = <String>{};
    final episodes = <EpisodeData>[];
    for (final feedEpisode in podcast.episodes) {
      final guid = feedEpisode.guid.trim();
      if (guid.isEmpty || !seen.add(guid)) continue;
      final episode = EpisodeData(
        id: 0,
        guid: guid,
        title: feedEpisode.title,
        description: feedEpisode.description,
        link: feedEpisode.link,
        publicationDate: feedEpisode.publicationDate,
        contentUrl: feedEpisode.contentUrl,
        imageUrl: feedEpisode.imageUrl,
        author: feedEpisode.author,
        season: feedEpisode.season,
        episodeNumber: feedEpisode.episode,
        duration: feedEpisode.duration?.inSeconds,
        podcastId: podcastId,
        podcastName: podcast.title ?? targetSubscription.podcastName,
      );
      episodes.add(episode);
      await _podcasting20.saveEpisode(feedEpisode, episode);
    }
    await _podcasting20.savePodcast(podcast, podcastId);
    await _episodes.saveEpisodesForPodcast(episodes, podcastId);
    return (await _episodes.maybeGetEpisodesForPodcast(podcastId)) ?? const [];
  }
}

class SubscriptionSyncReport {
  const SubscriptionSyncReport({
    required this.updatedFeeds,
    required this.failures,
    this.wasSkipped = false,
  });

  const SubscriptionSyncReport.skipped()
      : updatedFeeds = 0,
        failures = const [],
        wasSkipped = true;

  const SubscriptionSyncReport.empty()
      : updatedFeeds = 0,
        failures = const [],
        wasSkipped = false;

  final int updatedFeeds;
  final List<SubscriptionSyncFailure> failures;
  final bool wasSkipped;
}

class SubscriptionSyncFailure {
  const SubscriptionSyncFailure(this.subscription, this.error);

  final SubscriptionData subscription;
  final Object error;
}
