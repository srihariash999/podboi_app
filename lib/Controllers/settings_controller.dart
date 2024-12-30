import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Services/database/settings_box_controller.dart';

final settingsController =
    StateNotifierProvider<SettingsStateNotifier, SettingsState>((ref) {
  return SettingsStateNotifier();
});

class SettingsStateNotifier extends StateNotifier<SettingsState> {
  SettingsStateNotifier() : super(SettingsState.defaultState()) {
    loadSettings();
  }

  void loadSettings() async {
    try {
      state = SettingsState(subsFirst: false, loading: true);
      var _subsFirst = await SettingsBoxController.getSubsFirst();
      state = SettingsState(subsFirst: _subsFirst, loading: false);
    } catch (e) {
      print(" error in loading settings : $e");
    }
  }

  Future<void> saveSettings({required bool newSubsFirst}) async {
    try {
      state = SettingsState(subsFirst: newSubsFirst, loading: true);
      await SettingsBoxController.saveSettings(subsFirst: newSubsFirst);
      state = SettingsState(subsFirst: newSubsFirst, loading: false);
    } catch (e) {
      print(" error in saving settings : $e");
    }
  }
}

class SettingsState {
  final bool subsFirst;
  final bool loading;

  SettingsState({required this.subsFirst, required this.loading});

  factory SettingsState.defaultState() {
    return SettingsState(subsFirst: false, loading: false);
  }
}
