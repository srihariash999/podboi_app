import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/DataModels/listening_history.dart';

//* Provider for accessing historystate.
final historyController =
    StateNotifierProvider.autoDispose<HistoryStateNotifier, HistoryState>(
        (ref) {
  return HistoryStateNotifier(ref);
});

//* state notifier for changes and actions.
class HistoryStateNotifier extends StateNotifier<HistoryState> {
  HistoryStateNotifier(this.ref) : super(HistoryState.initial()) {
    getHistory();
    _scrollController.addListener(
      () {
        // nextPageTrigger will have a value equivalent to 80% of the list size.
        var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

        // _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
        if (_scrollController.position.pixels > nextPageTrigger) {
          print(" getting next page");
          _page++;
          getHistory();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController();

  final StateNotifierProviderRef<HistoryStateNotifier, HistoryState> ref;

  // ignore: unused_field
  int _page = 0;

  getHistory({bool fullRefresh = false}) async {
    // if (fullRefresh) {
    //   _page = 0;
    //   state.historyList.clear();
    // }
    // state = state.copyWith(
    //   isLoading: true,
    // );
    // List<ListeningHistoryData> _list = await ref
    //     .watch(databaseServiceProvider)
    //     .getLhiListPaginated(_limit, _page);
    // state = state.copyWith(
    //   historyList: _list,
    //   isLoading: false,
    //   isLoadMoreLoading: false,
    //   scrollController: _scrollController,
    // );
  }

  getNextPage() async {
    // if (state.noNextPage) return;
    // _page++;
    // state = state.copyWith(
    //   isLoadMoreLoading: true,
    // );
    // List<ListeningHistoryData> _list = await ref
    //     .watch(databaseServiceProvider)
    //     .getLhiListPaginated(_limit, _page);
    // state = state.copyWith(
    //   historyList: [...state.historyList, ..._list],
    //   isLoadMoreLoading: false,
    //   scrollController: _scrollController,
    //   noNextPage: _list.isEmpty,
    // );
  }

  saveToHistoryAction({
    required String url,
    required String name,
    required String artist,
    required String icon,
    required String album,
    required String duration,
    required String listenedOn,
    required String podcastArtWork,
    required String podcastName,
  }) async {
    // List<ListeningHistoryData> _list =
    //     await ref.watch(databaseServiceProvider).getLhiList();
    // bool _flagged = false;
    // ListeningHistoryData? _lhi;
    // for (var i in _list) {
    //   if (i.name == name && i.podcastName == podcastName) {
    //     _flagged = true;
    //     _lhi = i;
    //     break;
    //   }
    // }
    // if (_flagged == false) {
    //   bool s = await ref.watch(databaseServiceProvider).saveLhi(
    //         ListeningHistoryData(
    //           id: 0,
    //           url: url,
    //           name: name,
    //           artist: artist,
    //           icon: icon,
    //           album: album,
    //           duration: duration,
    //           listenedOn: listenedOn,
    //           podcastArtwork: podcastArtWork,
    //           podcastName: podcastName,
    //         ),
    //       );
    //   if (s) {
    //     getHistory();
    //   }
    // } else {
    //   await ref.watch(databaseServiceProvider).removeLhiItem(_lhi!.id);
    //   bool s = await ref.watch(databaseServiceProvider).saveLhi(
    //         ListeningHistoryData(
    //           id: 0,
    //           url: url,
    //           name: name,
    //           artist: artist,
    //           icon: icon,
    //           album: album,
    //           duration: duration,
    //           listenedOn: listenedOn,
    //           podcastArtwork: podcastArtWork,
    //           podcastName: podcastName,
    //         ),
    //       );
    //   if (s) {
    //     getHistory();
    //   }
    // }
  }
}

//*  history state.
class HistoryState {
  final List<ListeningHistoryData> historyList;
  final bool isLoading;
  final bool isLoadMoreLoading;
  final bool noNextPage;
  HistoryState({
    required this.historyList,
    required this.isLoading,
    required this.isLoadMoreLoading,
    required this.noNextPage,
    this.scrollController,
  });
  ScrollController? scrollController;
  factory HistoryState.initial() {
    return HistoryState(
      historyList: [],
      isLoading: false,
      isLoadMoreLoading: false,
      noNextPage: false,
    );
  }

  HistoryState copyWith({
    List<ListeningHistoryData>? historyList,
    bool? isLoading,
    ScrollController? scrollController,
    bool? isLoadMoreLoading,
    bool? noNextPage,
  }) {
    return HistoryState(
      historyList: historyList ?? this.historyList,
      isLoading: isLoading ?? this.isLoading,
      scrollController: scrollController ?? this.scrollController,
      isLoadMoreLoading: isLoadMoreLoading ?? this.isLoadMoreLoading,
      noNextPage: noNextPage ?? this.noNextPage,
    );
  }
}
