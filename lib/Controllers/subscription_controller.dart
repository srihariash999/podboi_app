import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Database/podcast_episode_box_controller.dart';
import 'package:podboi/Database/subscription_box_controller.dart';

final subscriptionsPageViewController =
    StateNotifierProvider<SubscriptionsPageNotifier, SubscriptionState>((ref) {
  return SubscriptionsPageNotifier();
});

class SubscriptionsPageNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionsPageNotifier() : super(SubscriptionState.initial()) {
    loadSubscriptions(showInitialLoader: true);
    _watchSubscriptions();
  }

  final SubscriptionBoxController _subscriptionBoxController =
      SubscriptionBoxController();
  final PodcastEpisodeBoxController _episodeBoxController =
      PodcastEpisodeBoxController();
  final List<StreamSubscription<BoxEvent>> _boxSubscriptions = [];
  Timer? _reloadDebounce;

  Future<void> _watchSubscriptions() async {
    final subscriptions = await _subscriptionBoxController.getBox();
    _boxSubscriptions.add(subscriptions.watch().listen((_) => _queueReload()));
  }

  void _queueReload() {
    _reloadDebounce?.cancel();
    _reloadDebounce =
        Timer(const Duration(milliseconds: 120), loadSubscriptions);
  }

  /// Rebuild the local projection without replacing an already-visible grid.
  ///
  /// Episode syncs can emit many Hive events. Showing the page-wide loader for
  /// every one disposes the [GridView] and its image widgets, making cached
  /// artwork look as if it is being downloaded again when the user returns.
  Future<void> loadSubscriptions({bool showInitialLoader = false}) async {
    if (showInitialLoader && state.subscriptionsList.isEmpty) {
      state = state.copyWith(isLoading: true);
    }
    final _subs = await _subscriptionBoxController.getSubscriptions();
    final metadata = await Future.wait(_subs.map(_subscriptionMetadata));
    final rows = <_SubscriptionRow>[];
    for (var index = 0; index < _subs.length; index++) {
      rows.add(_SubscriptionRow(_subs[index], metadata[index]));
    }
    rows.sort((a, b) {
      final aUnlistened = a.metadata.count > 0;
      final bUnlistened = b.metadata.count > 0;
      if (aUnlistened != bUnlistened) return aUnlistened ? -1 : 1;
      final aDate = aUnlistened
          ? a.metadata.latestUnlistened
          : a.metadata.latestPublished;
      final bDate = bUnlistened
          ? b.metadata.latestUnlistened
          : b.metadata.latestPublished;
      final byDate = (bDate ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(aDate ?? DateTime.fromMillisecondsSinceEpoch(0));
      if (byDate != 0) return byDate;
      return a.subscription.podcastName
          .toLowerCase()
          .compareTo(b.subscription.podcastName.toLowerCase());
    });

    // Listen to episode-box writes so a completion or manual mark immediately
    // changes ordering; no network sync is necessary.
    await _replaceEpisodeWatchers(rows.map((row) => row.subscription));
    state = state.copyWith(
      subscriptionsList: rows.map((row) => row.subscription).toList(),
      unlistenedCounts: {
        for (final row in rows)
          if (row.subscription.podcastId != null)
            row.subscription.podcastId!: row.metadata.count,
      },
      isLoading: false,
    );
  }

  Future<_SubscriptionMetadata> _subscriptionMetadata(
      SubscriptionData subscription) async {
    final podcastId = subscription.podcastId;
    if (podcastId == null) return const _SubscriptionMetadata.empty();
    final episodes =
        await _episodeBoxController.maybeGetEpisodesForPodcast(podcastId) ?? [];
    DateTime? newest;
    DateTime? newestUnlistened;
    var unlistenedCount = 0;
    for (final episode in episodes) {
      final date = episode.publicationDate;
      if (date != null && (newest == null || date.isAfter(newest)))
        newest = date;
      final duration = episode.duration;
      final played = episode.playedDuration ?? 0;
      // 90% completion is the app-wide automatic completion threshold. An
      // unknown duration is never silently treated as completed.
      final isUnlistened = duration == null || duration <= 0
          ? played == 0
          : played / duration < 0.9;
      if (isUnlistened) {
        unlistenedCount++;
        if (date != null &&
            (newestUnlistened == null || date.isAfter(newestUnlistened))) {
          newestUnlistened = date;
        }
      }
    }
    return _SubscriptionMetadata(unlistenedCount, newestUnlistened, newest);
  }

  Future<void> _replaceEpisodeWatchers(
      Iterable<SubscriptionData> subscriptions) async {
    for (final subscription in _boxSubscriptions.skip(1)) {
      await subscription.cancel();
    }
    if (_boxSubscriptions.length > 1) {
      _boxSubscriptions.removeRange(1, _boxSubscriptions.length);
    }
    for (final subscription in subscriptions) {
      final id = subscription.podcastId;
      if (id == null) continue;
      try {
        final box = await _episodeBoxController.getBox(id.toString());
        _boxSubscriptions.add(box.watch().listen((_) => _queueReload()));
      } on HiveError {
        // A newly subscribed feed may not have a cache box yet.
      }
    }
  }

  @override
  void dispose() {
    _reloadDebounce?.cancel();
    for (final subscription in _boxSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}

class SubscriptionState {
  final List<SubscriptionData> subscriptionsList;
  final bool isLoading;
  final Map<int, int> unlistenedCounts;
  SubscriptionState({
    required this.isLoading,
    required this.subscriptionsList,
    required this.unlistenedCounts,
  });
  factory SubscriptionState.initial() {
    return SubscriptionState(
      isLoading: true,
      subscriptionsList: [],
      unlistenedCounts: const {},
    );
  }
  SubscriptionState copyWith({
    List<SubscriptionData>? subscriptionsList,
    bool? isLoading,
    Map<int, int>? unlistenedCounts,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscriptionsList: subscriptionsList ?? this.subscriptionsList,
      unlistenedCounts: unlistenedCounts ?? this.unlistenedCounts,
    );
  }
}

class _SubscriptionRow {
  const _SubscriptionRow(this.subscription, this.metadata);
  final SubscriptionData subscription;
  final _SubscriptionMetadata metadata;
}

class _SubscriptionMetadata {
  const _SubscriptionMetadata(
      this.count, this.latestUnlistened, this.latestPublished);
  const _SubscriptionMetadata.empty()
      : count = 0,
        latestUnlistened = null,
        latestPublished = null;
  final int count;
  final DateTime? latestUnlistened;
  final DateTime? latestPublished;
}
