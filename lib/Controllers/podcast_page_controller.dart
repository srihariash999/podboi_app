import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';

final podcastPageViewController = StateNotifierProvider.family<
    PodcastPageViewNotifier, PodcastPageState, String>((ref, podcastFeedUrl) {
  return PodcastPageViewNotifier(podcastFeedUrl);
});

class PodcastPageViewNotifier extends StateNotifier<PodcastPageState> {
  final String podcastFeedUrl;
  PodcastPageViewNotifier(this.podcastFeedUrl)
      : super(PodcastPageState.initial()) {
    loadPodcastEpisodes(podcastFeedUrl);
  }

  Future<void> loadPodcastEpisodes(String feedUrl) async {
    state = state.copyWith(isLoading: true);
    Podcast _podcast = await Podcast.loadFeed(url: feedUrl);
    List<Episode> _episodes = [];
    if (_podcast.episodes != null) {
      for (var i in _podcast.episodes!) {
        _episodes.add(i);
      }
    }
    state = state.copyWith(podcastEpisodes: _episodes, isLoading: false);
  }
}

class PodcastPageState {
  final List<Episode> podcastEpisodes;
  final bool isLoading;
  PodcastPageState({
    required this.isLoading,
    required this.podcastEpisodes,
  });
  factory PodcastPageState.initial() {
    return PodcastPageState(
      isLoading: true,
      podcastEpisodes: [],
    );
  }
  PodcastPageState copyWith({
    List<Episode>? podcastEpisodes,
    bool? isLoading,
  }) {
    return PodcastPageState(
      isLoading: isLoading ?? this.isLoading,
      podcastEpisodes: podcastEpisodes ?? this.podcastEpisodes,
    );
  }
}
