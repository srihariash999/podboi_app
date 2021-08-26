import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';

var _search = Search();

final homeScreenController =
    StateNotifierProvider<HomeScreenStateNotifier, HomeScreenState>((ref) {
  return HomeScreenStateNotifier();
});

class HomeScreenStateNotifier extends StateNotifier<HomeScreenState> {
  HomeScreenStateNotifier() : super(HomeScreenState.initial()) {
    getTopPodcasts();
  }

  getTopPodcasts() async {
    SearchResult charts =
        await _search.charts(limit: 25, country: Country.UNITED_KINGDOM);
    List<Item> _topPodcasts = [];
    for (var i in charts.items) {
      _topPodcasts.add(i);
    }
    state = state.copyWith(topPodcasts: _topPodcasts);
  }
}

class HomeScreenState {
  final List<Item> topPodcasts;
  HomeScreenState({required this.topPodcasts});
  factory HomeScreenState.initial() {
    return HomeScreenState(
      topPodcasts: [],
    );
  }
  HomeScreenState copyWith({List<Item>? topPodcasts}) {
    return HomeScreenState(
      topPodcasts: topPodcasts ?? this.topPodcasts,
    );
  }
}
