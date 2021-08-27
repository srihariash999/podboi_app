import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/general_box_controller.dart';
import 'package:podcast_search/podcast_search.dart';

var _search = Search();

final homeScreenController =
    StateNotifierProvider<HomeScreenStateNotifier, HomeScreenState>((ref) {
  return HomeScreenStateNotifier();
});

class HomeScreenStateNotifier extends StateNotifier<HomeScreenState> {
  HomeScreenStateNotifier() : super(HomeScreenState.initial()) {
    getTopPodcasts();
    _getUserName();
  }

  _getUserName() async {
    state = state.copyWith(userName: getSavedUserName());
  }

  getTopPodcasts() async {
    SearchResult charts =
        await _search.charts(limit: 25, country: Country.INDIA);
    List<Item> _topPodcasts = [];
    for (var i in charts.items) {
      _topPodcasts.add(i);
    }
    state = state.copyWith(topPodcasts: _topPodcasts);
  }
}

class HomeScreenState {
  final List<Item> topPodcasts;
  final String userName;
  HomeScreenState({required this.topPodcasts, required this.userName});
  factory HomeScreenState.initial() {
    return HomeScreenState(topPodcasts: [], userName: '');
  }
  HomeScreenState copyWith({List<Item>? topPodcasts, String? userName}) {
    return HomeScreenState(
        topPodcasts: topPodcasts ?? this.topPodcasts,
        userName: userName ?? this.userName);
  }
}
