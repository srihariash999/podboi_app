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
    state = state.copyWith(
      userName: getSavedUserName(),
      userAvatar: getSavedUserAvatar(),
    );
  }

  getTopPodcasts() async {
    try {
      SearchResult charts =
          await _search.charts(limit: 25, country: Country.FRANCE);
      print(" top pods called : ${charts.items.length}");
      List<Item> _topPodcasts = [];
      for (var i in charts.items) {
        _topPodcasts.add(i);
      }
      state = state.copyWith(topPodcasts: _topPodcasts);
    } catch (e) {
      print(" error in top pods: $e ");
    }
  }
}

class HomeScreenState {
  final List<Item> topPodcasts;
  final String userName;
  final String userAvatar;
  HomeScreenState(
      {required this.topPodcasts,
      required this.userName,
      required this.userAvatar});
  factory HomeScreenState.initial() {
    return HomeScreenState(topPodcasts: [], userName: '', userAvatar: '');
  }
  HomeScreenState copyWith({
    List<Item>? topPodcasts,
    String? userName,
    String? userAvatar,
  }) {
    return HomeScreenState(
      topPodcasts: topPodcasts ?? this.topPodcasts,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
    );
  }
}
