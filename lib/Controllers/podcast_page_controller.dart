import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/subscription_controller.dart';
import 'package:podboi/Services/database/database_service.dart';
// import 'package:podboi/Services/database/db_service.dart';
import 'package:podcast_search/podcast_search.dart';

import '../Services/database/database.dart';

final podcastPageViewController =
    StateNotifierProvider.family<PodcastPageViewNotifier, PodcastPageState, SubscriptionData>(
        (ref, podcast) {
  return PodcastPageViewNotifier(podcast, ref);
});

class PodcastPageViewNotifier extends StateNotifier<PodcastPageState> {
  final SubscriptionData podcast;

  final StateNotifierProviderRef<PodcastPageViewNotifier, PodcastPageState> ref;

  List<Episode> _filteredEpisodes = [];
  List<Episode> _episodes = [];
  PodcastPageViewNotifier(this.podcast, this.ref) : super(PodcastPageState.initial()) {
    loadPodcastEpisodes(podcast.feedUrl);
  }

  Future<void> loadPodcastEpisodes(String feedUrl) async {
    state = state.copyWith(isLoading: true);
    bool _isSubbed = await ref.watch(databaseServiceProvider).isPodcastSubbed(podcast);
    Podcast _podcast;
    try {
      print(" feed url : $feedUrl");
      _podcast = await Podcast.loadFeed(url: feedUrl);

      if (_podcast.episodes != null) {
        for (var i in _podcast.episodes!) {
          _episodes.add(i);
        }
        _filteredEpisodes = _episodes;
      }
      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
        description: _podcast.description,
        isLoading: false,
        isSubscribed: _isSubbed,
      );
    } on PodcastFailedException catch (e) {
      print(" error in getting pod eps: ${e.toString()}");
      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
        isLoading: false,
        isSubscribed: _isSubbed,
      );
    }
  }

  void filterEpisodesWithQuery(String query) {
    if (query.isEmpty) {
      _filteredEpisodes = _episodes;
    } else {
      _filteredEpisodes = _episodes
          .where((episode) => episode.title.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    }
    state = state.copyWith(
      podcastEpisodes: _filteredEpisodes,
    );
  }

  saveToSubscriptionsAction(SubscriptionData podcast) async {
    state = state.copyWith(isLoading: true);
    bool _saved = await ref.watch(databaseServiceProvider).savePodcastToSubs(podcast);
    if (_saved) {
      print(" podcast ${podcast.podcastName}  is saved to subs");
      state = state.copyWith(
        isLoading: false,
        isSubscribed: true,
      );
      ref.watch(subscriptionsPageViewController.notifier).loadSubscriptions();
    } else {
      state = state.copyWith(
        isLoading: false,
        isSubscribed: false,
      );
    }
  }

  removeFromSubscriptionsAction(SubscriptionData podcast) async {
    state = state.copyWith(isLoading: true);
    bool _removed = await ref.watch(databaseServiceProvider).removePodcastFromSubs(podcast);
    if (_removed) {
      print(" podcast ${podcast.podcastName}  is removed from subs");
      state = state.copyWith(
        isLoading: false,
        isSubscribed: false,
      );
      ref.watch(subscriptionsPageViewController.notifier).loadSubscriptions();
    } else {
      state = state.copyWith(
        isLoading: false,
        isSubscribed: true,
      );
    }
  }

  void toggleEpisodesSort() async {
    try {
      state = state.copyWith(
        isLoading: true,
      );
      bool _incr = !state.epSortingIncr;
      _incr
          ? _episodes.sort((a, b) => b.publicationDate!.compareTo(a.publicationDate!))
          : _episodes.sort((a, b) => a.publicationDate!.compareTo(b.publicationDate!));
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
  final List<Episode> podcastEpisodes;
  final String description;
  final bool isLoading;
  final bool isSubscribed;
  final String? icon;
  final bool epSortingIncr;

  PodcastPageState(
      {required this.isLoading,
      required this.podcastEpisodes,
      required this.isSubscribed,
      required this.icon,
      required this.description,
      required this.epSortingIncr});
  factory PodcastPageState.initial() {
    return PodcastPageState(
      isLoading: true,
      description: '',
      podcastEpisodes: [],
      isSubscribed: false,
      icon: null,
      epSortingIncr: true,
    );
  }
  PodcastPageState copyWith({
    List<Episode>? podcastEpisodes,
    bool? isLoading,
    bool? isSubscribed,
    String? icon,
    String? description,
    bool? epSortingIncr,
    final TextEditingController? episodeSearchController,
  }) {
    return PodcastPageState(
      isLoading: isLoading ?? this.isLoading,
      podcastEpisodes: podcastEpisodes ?? this.podcastEpisodes,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      epSortingIncr: epSortingIncr ?? this.epSortingIncr,
    );
  }
}
