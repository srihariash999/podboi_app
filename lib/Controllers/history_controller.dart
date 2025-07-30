import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/Database/listening_history_box_controller.dart';

//* Provider for accessing historystate.
final historyController =
    StateNotifierProvider.autoDispose<HistoryStateNotifier, HistoryState>(
        (ref) {
  return HistoryStateNotifier();
});

//* state notifier for changes and actions.
class HistoryStateNotifier extends StateNotifier<HistoryState> {
  final ListeningHistoryBoxController _listeningHistoryBoxController =
      ListeningHistoryBoxController.initialize();

  HistoryStateNotifier() : super(HistoryState.initial()) {
    getHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getHistory({bool fullRefresh = false}) async {
    state = state.copyWith(
      isLoading: true,
    );

    List<ListeningHistoryData> _list =
        await _listeningHistoryBoxController.getHistoryList();

    state = state.copyWith(
      historyList: _list,
      isLoading: false,
    );
  }

  saveToHistoryAction({required ListeningHistoryData data}) async {
    await _listeningHistoryBoxController.saveEpisodeToHistory(data);
    getHistory();
  }
}

//*  history state.
class HistoryState {
  final List<ListeningHistoryData> historyList;
  final bool isLoading;
  HistoryState({
    required this.historyList,
    required this.isLoading,
  });
  factory HistoryState.initial() {
    return HistoryState(
      historyList: [],
      isLoading: false,
    );
  }

  HistoryState copyWith({
    List<ListeningHistoryData>? historyList,
    bool? isLoading,
  }) {
    return HistoryState(
      historyList: historyList ?? this.historyList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
