import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Services/database/db_service.dart';
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
    Podcast _podcast;
    List<Episode> _episodes = [];
    try {
      print(" feed url : $feedUrl");
      _podcast = await Podcast.loadFeed(url: feedUrl);

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
    } on PodcastFailedException catch (e) {
      print(" error in getting pod eps: ${e.toString()}");
      state = state.copyWith(
        podcastEpisodes: _episodes,
        isLoading: false,
        isSubscribed: _isSubbed,
      );
    }
  }

  saveToSubscriptionsAction(Item podcast) async {
    state = state.copyWith(isLoading: true);
    bool _saved = await savePodcastToSubs(podcast);
    if (_saved) {
      print(" podcast ${podcast.collectionName}  is saved to subs");
      state = state.copyWith(
        isLoading: false,
        isSubscribed: true,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isSubscribed: false,
      );
    }
  }

  removeFromSubscriptionsAction(Item podcast) async {
    state = state.copyWith(isLoading: true);
    bool _removed = await removePodcastFromSubs(podcast);
    if (_removed) {
      print(" podcast ${podcast.collectionName}  is removed from subs");
      state = state.copyWith(
        isLoading: false,
        isSubscribed: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isSubscribed: true,
      );
    }
  }
}

class PodcastPageState {
  final List<Episode> podcastEpisodes;
  final bool isLoading;
  final bool isSubscribed;
  final String? icon;
  PodcastPageState({
    required this.isLoading,
    required this.podcastEpisodes,
    required this.isSubscribed,
    required this.icon,
  });
  factory PodcastPageState.initial() {
    return PodcastPageState(
      isLoading: true,
      podcastEpisodes: [],
      isSubscribed: false,
      icon: null,
    );
  }
  PodcastPageState copyWith({
    List<Episode>? podcastEpisodes,
    bool? isLoading,
    bool? isSubscribed,
    String? icon,
  }) {
    return PodcastPageState(
      isLoading: isLoading ?? this.isLoading,
      podcastEpisodes: podcastEpisodes ?? this.podcastEpisodes,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      icon: icon ?? this.icon,
    );
  }
}
