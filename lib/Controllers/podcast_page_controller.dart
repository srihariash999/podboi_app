import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:podboi/Services/database/db_service.dart';
import 'package:podboi/Services/database/subscriptions.dart';
import 'package:podcast_search/podcast_search.dart';

final podcastPageViewController = StateNotifierProvider.family<
    PodcastPageViewNotifier, PodcastPageState, Item>((ref, podcast) {
  return PodcastPageViewNotifier(podcast);
});

class PodcastPageViewNotifier extends StateNotifier<PodcastPageState> {
  final Item podcast;
  PodcastPageViewNotifier(this.podcast) : super(PodcastPageState.initial()) {
    loadPodcastEpisodes(podcast.feedUrl ?? '');
  }

  Future<void> loadPodcastEpisodes(String feedUrl) async {
    state = state.copyWith(isLoading: true);
    bool _isSubbed = await isPodcastSubbed(podcast);
    Podcast _podcast = await Podcast.loadFeed(url: feedUrl);
    List<Episode> _episodes = [];
    if (_podcast.episodes != null) {
      for (var i in _podcast.episodes!) {
        _episodes.add(i);
      }
    }
    state = state.copyWith(
      podcastEpisodes: _episodes,
      isLoading: false,
      isSubscribed: _isSubbed,
    );
  }

  saveToSubscriptions(Item podcast) async {
    state = state.copyWith(isLoading: true);
    Box _subBox = Hive.box('subscriptionsBox');
    await _subBox.add(
      Subscription(
        podcast: podcast,
        dateAdded: DateTime.now(),
      ),
    );
    state = state.copyWith(
      isLoading: false,
      isSubscribed: true,
    );
  }
}

class PodcastPageState {
  final List<Episode> podcastEpisodes;
  final bool isLoading;
  final bool isSubscribed;
  PodcastPageState({
    required this.isLoading,
    required this.podcastEpisodes,
    required this.isSubscribed,
  });
  factory PodcastPageState.initial() {
    return PodcastPageState(
      isLoading: true,
      podcastEpisodes: [],
      isSubscribed: false,
    );
  }
  PodcastPageState copyWith({
    List<Episode>? podcastEpisodes,
    bool? isLoading,
    bool? isSubscribed,
  }) {
    return PodcastPageState(
      isLoading: isLoading ?? this.isLoading,
      podcastEpisodes: podcastEpisodes ?? this.podcastEpisodes,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}
