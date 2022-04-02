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
      state = state.copyWith(topPodcasts: [], isLoading: true);
      SearchResult charts = await _search.charts(
        limit: 24,
        country: Country.INDIA,
      );
      print(" top pods called : ${charts.items.length}");
      List<Item> _topPodcasts = [];
      for (var i in charts.items) {
        _topPodcasts.add(i);
      }
      state = state.copyWith(topPodcasts: _topPodcasts, isLoading: false);
    } catch (e) {
      print(" error in getting top pods: $e ");
    }
  }
}

class HomeScreenState {
  final List<Item> topPodcasts;
  final String userName;
  final String userAvatar;
  final bool isLoading;
  HomeScreenState({
    required this.topPodcasts,
    required this.userName,
    required this.userAvatar,
    required this.isLoading,
  });
  factory HomeScreenState.initial() {
    return HomeScreenState(
      topPodcasts: [],
      userName: '',
      userAvatar: '',
      isLoading: false,
    );
  }
  HomeScreenState copyWith({
    List<Item>? topPodcasts,
    String? userName,
    String? userAvatar,
    bool? isLoading,
  }) {
    return HomeScreenState(
      topPodcasts: topPodcasts ?? this.topPodcasts,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
