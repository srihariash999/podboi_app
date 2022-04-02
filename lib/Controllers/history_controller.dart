import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/DataModels/ListeningHistoryItem.dart';
import 'package:podboi/Services/database/db_service.dart';

//* Provider for accessing historystate.
final historyController =
    StateNotifierProvider<HistoryStateNotifier, HistoryState>((ref) {
  return HistoryStateNotifier();
});

//* state notifier for changes and actions.
class HistoryStateNotifier extends StateNotifier<HistoryState> {
  HistoryStateNotifier() : super(HistoryState.initial()) {
    getHistory();
  }

  getHistory() async {
    state = state.copyWith(isLoading: true);
    List<ListeningHistoryItem> _list = await getLhiList();
    state = state.copyWith(historyList: _list, isLoading: false);
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
    List<ListeningHistoryItem> _list = await getLhiList();
    bool _flagged = false;
    ListeningHistoryItem? _lhi;
    for (var i in _list) {
      if (i.name == name && i.podcastName == podcastName) {
        _flagged = true;
        _lhi = i;
        break;
      }
    }
    if (_flagged == false) {
      bool s = await saveLhi(
        ListeningHistoryItem(
          url: url,
          name: name,
          artist: artist,
          icon: icon,
          album: album,
          duration: duration,
          listenedOn: listenedOn,
          podcastArtWork: podcastArtWork,
          podcastName: podcastName,
        ),
      );
      if (s) {
        getHistory();
      }
    } else {
      print("podcast already in history");
      await removeLhiItem(_lhi!.id!);
      bool s = await saveLhi(
        ListeningHistoryItem(
          url: url,
          name: name,
          artist: artist,
          icon: icon,
          album: album,
          duration: duration,
          listenedOn: listenedOn,
          podcastArtWork: podcastArtWork,
          podcastName: podcastName,
        ),
      );
      if (s) {
        getHistory();
      }
    }
  }
}

//*  history state.
class HistoryState {
  final List<ListeningHistoryItem> historyList;
  final bool isLoading;
  HistoryState({required this.historyList, required this.isLoading});
  factory HistoryState.initial() {
    return HistoryState(historyList: [], isLoading: false);
  }

  HistoryState copyWith(
      {List<ListeningHistoryItem>? historyList, bool? isLoading}) {
    return HistoryState(
      historyList: historyList ?? this.historyList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
