import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Services/database/podcast_episode_box_controller.dart';
import 'package:podboi/Services/database/subscription_box_controller.dart';
import 'package:podcast_search/podcast_search.dart' as ps;

final podcastPageViewController = StateNotifierProvider.autoDispose
    .family<PodcastPageViewNotifier, PodcastPageState, SubscriptionData>(
        (podcastRef, ref) {
  return PodcastPageViewNotifier(ref);
});

class PodcastPageViewNotifier extends StateNotifier<PodcastPageState> {
  final SubscriptionData podcast;

  List<EpisodeData> _filteredEpisodes = [];
  List<EpisodeData> _episodes = [];

  int realSubId = -1;

  PodcastPageViewNotifier(this.podcast) : super(PodcastPageState.initial()) {
    loadPodcastEpisodes(podcast.feedUrl, podcast.podcastId!, initial: true);

    SubscriptionBoxController.isPodcastSubbed(podcast).then((value) {
      state = state.copyWith(
        isSubscribed: value,
      );
    });
  }

  Future<void> loadPodcastEpisodes(String feedUrl, int id,
      {bool initial = false}) async {
    if (initial) state = state.copyWith(isLoading: true);

    _episodes.clear();
    try {
      // try and load stuff from local storage.
      var storedEps =
          await PodcastEpisodeBoxController.maybeGetEpisodesForPodcast(id);

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

      // load from network.
      ps.Podcast _podcast = await ps.Podcast.loadFeed(url: feedUrl);

      if (_podcast.episodes.length != _episodes.length) {
        print(
            " more episodes found in network than local  network len: ${_podcast.episodes.length} local len: ${_episodes.length} ");
        // clear the episodes;
        _episodes.clear();
        _filteredEpisodes.clear();

        Map<String, int> storedPlaybackValDict = {};
        for (var i in storedEps ?? []) {
          storedPlaybackValDict[i.guid] = i.playedDuration ?? 0;
        }

        for (var i in _podcast.episodes) {
          _episodes.add(
            EpisodeData(
              id: 0,
              guid: i.guid,
              title: i.title,
              description: i.description,
              link: i.link,
              publicationDate: i.publicationDate,
              contentUrl: i.contentUrl,
              imageUrl: i.imageUrl,
              author: i.author,
              season: i.season,
              episodeNumber: i.episode,
              duration: i.duration?.inSeconds,
              podcastId: id,
              podcastName: _podcast.title,
              playedDuration: storedPlaybackValDict[i.guid] ?? 0,
            ),
          );
        }

        _filteredEpisodes = [..._episodes];

        // store new episodes to local storage.
        var toSave = [..._episodes];
        toSave.sort((a, b) => (b.publicationDate ?? DateTime.now())
            .compareTo((a.publicationDate ?? DateTime.now())));
        await PodcastEpisodeBoxController.saveEpisodesForPodcast(toSave, id);

        state = state.copyWith(
          podcastEpisodes: _filteredEpisodes,
          description: _podcast.description,
          isLoading: false,
        );
      }
    } on ps.PodcastFailedException catch (e) {
      print(" error in getting pod eps: ${e.toString()}");
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

  saveToSubscriptionsAction(SubscriptionData podcast, WidgetRef ref) async {
    try {
      state = state.copyWith(isSubscribeButtonLoading: true);
      await SubscriptionBoxController.saveSubscription(podcast, ref: ref);
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
      state = state.copyWith(isSubscribeButtonLoading: false);
    }
  }

  removeFromSubscriptionsAction(SubscriptionData podcast, WidgetRef ref) async {
    try {
      state = state.copyWith(isSubscribeButtonLoading: true);
      await SubscriptionBoxController.removeSubscription(podcast, ref: ref);
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
