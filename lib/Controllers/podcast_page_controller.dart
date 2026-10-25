import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:podboi/Controllers/download_controller.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Database/podcast_episode_box_controller.dart';
import 'package:podboi/Database/subscription_box_controller.dart';
import 'package:podboi/Services/subscription_sync_service.dart';

final podcastPageViewController = StateNotifierProvider.autoDispose
    .family<PodcastPageViewNotifier, PodcastPageState, SubscriptionData>(
        (podcastRef, ref) {
  return PodcastPageViewNotifier(ref);
});

class PodcastPageViewNotifier extends StateNotifier<PodcastPageState> {
  final SubscriptionData podcast;

  final PodcastEpisodeBoxController podcastEpisodeBoxController =
      PodcastEpisodeBoxController();

  final SubscriptionBoxController subscriptionBoxController =
      SubscriptionBoxController();

  List<EpisodeData> _filteredEpisodes = [];
  List<EpisodeData> _episodes = [];
  StreamSubscription<BoxEvent>? _episodeBoxSubscription;

  int realSubId = -1;

  PodcastPageViewNotifier(this.podcast) : super(PodcastPageState.initial()) {
    loadPodcastEpisodes(podcast.feedUrl, podcast.podcastId!, initial: true);
    unawaited(_watchEpisodeUpdates());

    subscriptionBoxController.isPodcastSubbed(podcast).then((value) {
      if (!mounted) return;
      state = state.copyWith(
        isSubscribed: value,
      );
    });
  }

  Future<void> _watchEpisodeUpdates() async {
    final savedSubscription = await subscriptionBoxController
        .findSubscriptionByFeedUrl(podcast.feedUrl);
    final podcastId = savedSubscription?.podcastId ?? podcast.podcastId;
    if (podcastId == null) return;
    final box = await podcastEpisodeBoxController.getBox(podcastId.toString());
    _episodeBoxSubscription = box.watch().listen((event) {
      final updatedEpisode = event.value;
      if (updatedEpisode is! EpisodeData) return;
      final index = _episodes.indexWhere(
        (episode) => episode.guid == updatedEpisode.guid,
      );
      if (index < 0) return;

      _episodes = [..._episodes]..[index] = updatedEpisode;
      _filteredEpisodes = _filteredEpisodes
          .map((episode) =>
              episode.guid == updatedEpisode.guid ? updatedEpisode : episode)
          .toList();
      if (mounted) {
        state = state.copyWith(podcastEpisodes: _filteredEpisodes);
      }
    });
  }

  @override
  void dispose() {
    _episodeBoxSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadPodcastEpisodes(String feedUrl, int id,
      {bool initial = false}) async {
    if (!mounted) return;
    if (initial) state = state.copyWith(isLoading: true);

    _episodes.clear();
    try {
      final savedSubscription =
          await subscriptionBoxController.findSubscriptionByFeedUrl(feedUrl);
      final targetPodcastId = savedSubscription?.podcastId ?? id;
      // try and load stuff from local storage.
      var storedEps = await podcastEpisodeBoxController
          .maybeGetEpisodesForPodcast(targetPodcastId);
      if (!mounted) return;

      // If local storage has episodes, show them.
      if (storedEps != null && storedEps.isNotEmpty) {
        print(" loaded ${storedEps.length} from local cache");

        storedEps.sort((a, b) => (b.publicationDate ?? DateTime.now())
            .compareTo(a.publicationDate ?? DateTime.now()));

        _episodes = [...storedEps];
        _filteredEpisodes = [..._episodes];

        state = state.copyWith(
          podcastEpisodes: _filteredEpisodes,
          isLoading: false,
          description: podcast.podcastName,
        );
      } else {
        print(" nothing to load from local cache");
      }

      // Refresh metadata even when the feed's item count is unchanged. The
      // sync service upserts rather than clearing the cache, so progress and
      // download paths are retained.
      final syncedEpisodes =
          await SubscriptionSyncService().syncPodcast(podcast);
      if (!mounted) return;
      syncedEpisodes.sort((a, b) => (b.publicationDate ?? DateTime(0))
          .compareTo(a.publicationDate ?? DateTime(0)));
      _episodes = syncedEpisodes;
      _filteredEpisodes = [..._episodes];
      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
        description: savedSubscription?.podcastName ?? podcast.podcastName,
        icon: savedSubscription?.artworkUrl,
        isLoading: false,
      );
    } catch (e) {
      print(" error in getting podcast episodes: $e");
      if (!mounted) return;
      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
        isLoading: false,
      );
    }
  }

  void filterEpisodesWithQuery(String query) {
    if (query.isEmpty) {
      _filteredEpisodes = _episodes;
    } else {
      _filteredEpisodes = _episodes
          .where((episode) =>
              episode.title.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    }
    state = state.copyWith(
      podcastEpisodes: _filteredEpisodes,
    );
  }

  void saveToSubscriptionsAction(
      SubscriptionData podcast, WidgetRef ref) async {
    try {
      state = state.copyWith(isSubscribeButtonLoading: true);
      await subscriptionBoxController.saveSubscription(podcast, ref: ref);
      if (!mounted) return;
      state =
          state.copyWith(isSubscribeButtonLoading: false, isSubscribed: true);
    } catch (e) {
      print("save subscriptions action failed: $e");

      Fluttertoast.showToast(
          msg: "Unable to save this podcast to subscriptions.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      if (!mounted) return;
      state = state.copyWith(isSubscribeButtonLoading: false);
    }
  }

  void removeFromSubscriptionsAction(
      SubscriptionData podcast, WidgetRef ref) async {
    try {
      state = state.copyWith(isSubscribeButtonLoading: true);
      await subscriptionBoxController.removeSubscription(podcast, ref: ref);
      if (!mounted) return;
      state =
          state.copyWith(isSubscribeButtonLoading: false, isSubscribed: false);
    } catch (e) {
      print("remove subscriptions action failed: $e");
      Fluttertoast.showToast(
          msg: "Unable to remove this podcast from subscriptions.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      if (!mounted) return;
      state = state.copyWith(isSubscribeButtonLoading: false);
    }
  }

  void toggleEpisodesSort() async {
    try {
      state = state.copyWith(
        isLoading: true,
      );
      bool _incr = !state.epSortingIncr;
      _incr
          ? _episodes.sort((a, b) => (b.publicationDate ?? DateTime.now())
              .compareTo(a.publicationDate ?? DateTime.now()))
          : _episodes.sort((a, b) => (a.publicationDate ?? DateTime.now())
              .compareTo(b.publicationDate ?? DateTime.now()));
      _filteredEpisodes = _episodes;
      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
        isLoading: false,
        epSortingIncr: !state.epSortingIncr,
      );
    } catch (e) {
      debugPrint(" cannot sort episodes  : $e");
    } finally {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  Future<void> markEpisodeAsPlayed(EpisodeData episode) async {
    try {
      await podcastEpisodeBoxController.markEpisodeAsPlayed(
        episode.guid,
        episode.podcastId,
      );
      if (!mounted) return;

      var pods = [..._episodes];

      for (var i = 0; i < pods.length; i++) {
        if (pods[i].guid == episode.guid) {
          pods[i] = pods[i].copyWith(
            playedDuration: episode.duration,
          );
          break;
        }
      }
      _episodes = [...pods];
      _filteredEpisodes = [..._episodes];

      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
      );
    } catch (e) {
      debugPrint(" cannot mark episode as played  : $e");
    } finally {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  Future<void> downloadEpisode(EpisodeData episode, WidgetRef ref) async {
    try {
      final path = await ref
          .read(downloadController.notifier)
          .downloadEpisode(episode, podcast);
      if (!mounted) return;
      if (path != null) {
        podcastEpisodeBoxController.storeDownloadPath(
          episode.guid,
          path,
          episode.podcastId,
        );

        var pods = [..._episodes];
        for (var i = 0; i < pods.length; i++) {
          if (pods[i].guid == episode.guid) {
            pods[i] = pods[i].updateDownloadPath(
              downloadPath: path,
            );
            break;
          }
        }
        _episodes = [...pods];
        _filteredEpisodes = [..._episodes];

        state = state.copyWith(
          podcastEpisodes: _filteredEpisodes,
        );
      } else {
        await ref.read(downloadController.notifier).deleteEpisode(episode.guid);
      }
    } on EpisodeAlreadyDownloadedException catch (e) {
      print(" cannot download episode  : $e");
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      debugPrint(" cannot download episode  : $e");
      Fluttertoast.showToast(
        msg: "Failed to download episode.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> deleteDownloadedEpisode(
      EpisodeData episode, WidgetRef ref) async {
    try {
      await ref.read(downloadController.notifier).deleteEpisode(episode.guid);
      if (!mounted) return;

      await podcastEpisodeBoxController.removeDownloadPath(
        episode.guid,
        episode.podcastId,
      );
      if (!mounted) return;

      var pods = [..._episodes];
      for (var i = 0; i < pods.length; i++) {
        if (pods[i].guid == episode.guid) {
          pods[i] = pods[i].updateDownloadPath(
            downloadPath: null,
          );
          break;
        }
      }
      _episodes = [...pods];
      _filteredEpisodes = [..._episodes];

      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
      );
    } catch (e) {
      debugPrint(" cannot delete downloaded episode  : $e");
    } finally {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
      );
    }
  }
}

class PodcastPageState {
  final List<EpisodeData> podcastEpisodes;
  final String description;
  final bool isLoading;
  final bool isSubscribeButtonLoading;
  final bool isSubscribed;
  final String? icon;
  final bool epSortingIncr;

  PodcastPageState({
    required this.isLoading,
    required this.podcastEpisodes,
    required this.isSubscribed,
    required this.icon,
    required this.description,
    required this.epSortingIncr,
    required this.isSubscribeButtonLoading,
  });
  factory PodcastPageState.initial() {
    return PodcastPageState(
      isLoading: true,
      description: '',
      podcastEpisodes: [],
      isSubscribed: false,
      icon: null,
      epSortingIncr: true,
      isSubscribeButtonLoading: false,
    );
  }
  PodcastPageState copyWith({
    List<EpisodeData>? podcastEpisodes,
    bool? isLoading,
    bool? isSubscribed,
    String? icon,
    String? description,
    bool? epSortingIncr,
    final TextEditingController? episodeSearchController,
    bool? isSubscribeButtonLoading,
  }) {
    return PodcastPageState(
      isLoading: isLoading ?? this.isLoading,
      podcastEpisodes: podcastEpisodes ?? this.podcastEpisodes,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      epSortingIncr: epSortingIncr ?? this.epSortingIncr,
      isSubscribeButtonLoading:
          isSubscribeButtonLoading ?? this.isSubscribeButtonLoading,
    );
  }
}
