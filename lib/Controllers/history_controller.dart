import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Services/database/database.dart';
import 'package:podboi/Services/database/database_service.dart';

//* Provider for accessing historystate.
final historyController = StateNotifierProvider<HistoryStateNotifier, HistoryState>((ref) {
  return HistoryStateNotifier(ref);
});

//* state notifier for changes and actions.
class HistoryStateNotifier extends StateNotifier<HistoryState> {
  HistoryStateNotifier(this.ref) : super(HistoryState.initial()) {
    getHistory();
  }

  final StateNotifierProviderRef<HistoryStateNotifier, HistoryState> ref;

  getHistory() async {
    state = state.copyWith(isLoading: true);
    List<ListeningHistoryData> _list = await ref.watch(databaseServiceProvider).getLhiList();
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
    List<ListeningHistoryData> _list = await ref.watch(databaseServiceProvider).getLhiList();
    bool _flagged = false;
    ListeningHistoryData? _lhi;
    for (var i in _list) {
      if (i.name == name && i.podcastName == podcastName) {
        _flagged = true;
        _lhi = i;
        break;
      }
    }
    if (_flagged == false) {
      bool s = await ref.watch(databaseServiceProvider).saveLhi(
            ListeningHistoryData(
              id: 0,
              url: url,
              name: name,
              artist: artist,
              icon: icon,
              album: album,
              duration: duration,
              listenedOn: listenedOn,
              podcastArtwork: podcastArtWork,
              podcastName: podcastName,
            ),
          );
      if (s) {
        getHistory();
      }
    } else {
      print("podcast already in history");
      await ref.watch(databaseServiceProvider).removeLhiItem(_lhi!.id);
      bool s = await ref.watch(databaseServiceProvider).saveLhi(
            ListeningHistoryData(
              id: 0,
              url: url,
              name: name,
              artist: artist,
              icon: icon,
              album: album,
              duration: duration,
              listenedOn: listenedOn,
              podcastArtwork: podcastArtWork,
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
  final List<ListeningHistoryData> historyList;
  final bool isLoading;
  HistoryState({required this.historyList, required this.isLoading});
  factory HistoryState.initial() {
    return HistoryState(historyList: [], isLoading: false);
  }

  HistoryState copyWith({List<ListeningHistoryData>? historyList, bool? isLoading}) {
    return HistoryState(
      historyList: historyList ?? this.historyList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
