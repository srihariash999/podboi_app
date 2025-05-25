import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Services/database/settings_box_controller.dart';

final settingsController =
    StateNotifierProvider<SettingsStateNotifier, SettingsState>((ref) {
  return SettingsStateNotifier();
});

class SettingsStateNotifier extends StateNotifier<SettingsState> {
  late final SettingsBoxController _settingsBoxController;

  // Public constructor that uses the default SettingsBoxController
  SettingsStateNotifier() : this.internal(SettingsBoxController.initialize());

  // Internal constructor for testing or specific initialization
  SettingsStateNotifier.internal(this._settingsBoxController)
      : super(SettingsState.defaultState()) {
    loadSettings();
  }

  void loadSettings() async {
    try {
      state = SettingsState(
        subsFirst: false,
        loading: true,
        rewindDuration: 30,
        forwardDuration: 30,
      );
      var _subsFirst = await _settingsBoxController.getSubsFirst();
      var _rewindDuration = await _settingsBoxController.getRewindDurationSetting();
      var _forwardDuration = await _settingsBoxController.getForwardDurationSetting();
      state = SettingsState(
        subsFirst: _subsFirst,
        loading: false,
        rewindDuration: _rewindDuration,
        forwardDuration: _forwardDuration,
      );
    } catch (e) {
      print(" error in loading settings : $e");
    }
  }

  Future<void> saveSettings({
    bool? newSubsFirst,
    int? newRewindDuration,
    int? newForwardDuration,
  }) async {
    try {
      // Store current state values to preserve them if not being updated
      final currentSubsFirst = state.subsFirst;
      final currentRewindDuration = state.rewindDuration;
      final currentForwardDuration = state.forwardDuration;

      // Set loading state, using new values if provided, otherwise current
      state = SettingsState(
        subsFirst: newSubsFirst ?? currentSubsFirst,
        loading: true,
        rewindDuration: newRewindDuration ?? currentRewindDuration,
        forwardDuration: newForwardDuration ?? currentForwardDuration,
      );

      // Perform save operations for provided values
      if (newSubsFirst != null) {
        await _settingsBoxController.saveSubsFirstSetting(newSubsFirst);
      }
      if (newRewindDuration != null) {
        await _settingsBoxController.saveRewindDurationSetting(newRewindDuration);
      }
      if (newForwardDuration != null) {
        await _settingsBoxController.saveForwardDurationSetting(newForwardDuration);
      }

      // Set final state with new values and loading false
      state = SettingsState(
        subsFirst: newSubsFirst ?? currentSubsFirst,
        loading: false,
        rewindDuration: newRewindDuration ?? currentRewindDuration,
        forwardDuration: newForwardDuration ?? currentForwardDuration,
      );
    } catch (e) {
      print(" error in saving settings : $e");
      // Optionally, revert to a non-loading state with previous values if error occurs
      state = SettingsState(
        subsFirst: currentSubsFirst,
        loading: false,
        rewindDuration: currentRewindDuration,
        forwardDuration: currentForwardDuration,
      );
    }
  }
}

class SettingsState {
  final bool subsFirst;
  final bool loading;
  final int rewindDuration;
  final int forwardDuration;

  SettingsState({
    required this.subsFirst,
    required this.loading,
    required this.rewindDuration,
    required this.forwardDuration,
  });

  factory SettingsState.defaultState() {
    return SettingsState(
      subsFirst: false,
      loading: false,
      rewindDuration: 30,
      forwardDuration: 30,
    );
  }
}
