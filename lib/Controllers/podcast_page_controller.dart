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

  List<EpisodeData> _filteredEpisodes = [];
  List<EpisodeData> _episodes = [];

  int realSubId = -1;

  PodcastPageViewNotifier(this.podcast, this.ref) : super(PodcastPageState.initial()) {
    loadPodcastEpisodes(podcast.feedUrl, podcast.id);
  }

  loadEpisodesFromCache() async {
    var res = await ref.watch(databaseServiceProvider).getEpisodesFromCacheById(podcast.id);
    if (res.isNotEmpty) {
      print("Loading episodes from cache. Len : ${res.length}");
      state = state.copyWith(podcastEpisodes: res);
    }
  }

  Future<void> loadPodcastEpisodes(String feedUrl, int id) async {
    state = state.copyWith(isLoading: true);
    ref.watch(databaseServiceProvider).isPodcastSubbed(podcast).then((value) {
      state = state.copyWith(
        isSubscribed: value.value,
      );
      if (value.id != null) realSubId = value.id!;
    });

    Podcast _podcast;
    try {
      await loadEpisodesFromCache();
      print(" feed url : $feedUrl");
      _podcast = await Podcast.loadFeed(url: feedUrl);

      if (_podcast.episodes != null) {
        await ref.watch(databaseServiceProvider).saveEpsiodesToCache(_podcast.episodes!
            .map(
              (i) => EpisodeData(
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
              ),
            )
            .toList());
        for (var i in _podcast.episodes!) {
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
            ),
          );
        }
        _filteredEpisodes = _episodes;
      }
      state = state.copyWith(
        podcastEpisodes: _filteredEpisodes,
        description: _podcast.description,
        isLoading: false,
      );
    } on PodcastFailedException catch (e) {
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
          .where((episode) => episode.title.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    }
    state = state.copyWith(
      podcastEpisodes: _filteredEpisodes,
    );
  }

  saveToSubscriptionsAction(SubscriptionData podcast) async {
    print(" trying to save sub");
    state = state.copyWith(isLoading: true);
    var savedId = await ref.watch(databaseServiceProvider).savePodcastToSubs(podcast);
    print(" saved id : $savedId");
    if (savedId != null) {
      print(" podcast ${podcast.podcastName}  is saved to subs");
      state = state.copyWith(
        isLoading: false,
        isSubscribed: true,
      );
      await ref.watch(subscriptionsPageViewController.notifier).loadSubscriptions();

      List<EpisodeData> _newEpisodes = [];
      for (var i in _episodes) {
        _newEpisodes.add(
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
            episodeNumber: i.episodeNumber,
            duration: i.duration,
            podcastId: savedId,
            podcastName: i.podcastName,
          ),
        );
      }
      _episodes = _newEpisodes;

      await ref.watch(databaseServiceProvider).saveEpsiodesToCache(_episodes);
    } else {
      state = state.copyWith(
        isLoading: false,
        isSubscribed: true,
      );
    }
  }

  removeFromSubscriptionsAction(SubscriptionData podcast) async {
    state = state.copyWith(isLoading: true);
    bool _removed = await ref
        .watch(databaseServiceProvider)
        .removePodcastFromSubs(podcast.id < 0 ? realSubId : podcast.id);
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
  final List<EpisodeData> podcastEpisodes;
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
    List<EpisodeData>? podcastEpisodes,
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
