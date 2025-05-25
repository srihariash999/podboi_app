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
        enableBatteryOptimization: false,
        rewindDuration: 30,
        forwardDuration: 30,
      );
      var _subsFirst = await _settingsBoxController.getSubsFirst();
      var _enableBatteryOptimization = await _settingsBoxController.getEnableBatteryOptimizationSetting();
      var _rewindDuration = await _settingsBoxController.getRewindDurationSetting();
      var _forwardDuration = await _settingsBoxController.getForwardDurationSetting();
      state = SettingsState(
        subsFirst: _subsFirst,
        loading: false,
        enableBatteryOptimization: _enableBatteryOptimization,
        rewindDuration: _rewindDuration,
        forwardDuration: _forwardDuration,
      );
    } catch (e) {
      print(" error in loading settings : $e");
    }
  }

  Future<void> saveSettings({
    bool? newSubsFirst,
    bool? newEnableBatteryOptimization,
    int? newRewindDuration,
    int? newForwardDuration,
  }) async {
    try {
      final currentSubsFirst = state.subsFirst;
      final currentEnableBatteryOptimization = state.enableBatteryOptimization;
      final currentRewindDuration = state.rewindDuration;
      final currentForwardDuration = state.forwardDuration;

      state = SettingsState(
        subsFirst: newSubsFirst ?? currentSubsFirst,
        loading: true,
        enableBatteryOptimization: newEnableBatteryOptimization ?? currentEnableBatteryOptimization,
        rewindDuration: newRewindDuration ?? currentRewindDuration,
        forwardDuration: newForwardDuration ?? currentForwardDuration,
      );

      if (newSubsFirst != null) {
        await _settingsBoxController.saveSubsFirstSetting(newSubsFirst);
      }
      if (newEnableBatteryOptimization != null) {
        await _settingsBoxController.saveEnableBatteryOptimizationSetting(newEnableBatteryOptimization);
      }
      if (newRewindDuration != null) {
        await _settingsBoxController.saveRewindDurationSetting(newRewindDuration);
      }
      if (newForwardDuration != null) {
        await _settingsBoxController.saveForwardDurationSetting(newForwardDuration);
      }

      state = SettingsState(
        subsFirst: newSubsFirst ?? currentSubsFirst,
        loading: false,
        enableBatteryOptimization: newEnableBatteryOptimization ?? currentEnableBatteryOptimization,
        rewindDuration: newRewindDuration ?? currentRewindDuration,
        forwardDuration: newForwardDuration ?? currentForwardDuration,
      );
    } catch (e) {
      print(" error in saving settings : $e");
    }
  }
}

class SettingsState {
  final bool subsFirst;
  final bool loading;
  final bool enableBatteryOptimization;
  final int rewindDuration;
  final int forwardDuration;

  SettingsState({
    required this.subsFirst,
    required this.loading,
    required this.enableBatteryOptimization,
    required this.rewindDuration,
    required this.forwardDuration,
  });

  factory SettingsState.defaultState() {
    return SettingsState(
      subsFirst: false,
      loading: false,
      enableBatteryOptimization: false,
      rewindDuration: 30,
      forwardDuration: 30,
    );
  }
}
