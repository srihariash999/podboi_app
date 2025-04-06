import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Services/database/settings_box_controller.dart';

final welcomePageController =
    StateNotifierProvider<WelcomePageStateNotifier, WelcomePageState>((ref) {
  return WelcomePageStateNotifier();
});

class WelcomePageState {
  String avatar;
  WelcomePageState({
    required this.avatar,
  });

  factory WelcomePageState.initial() {
    return WelcomePageState(
      avatar: K.avatarNames.user,
    );
  }
}

class WelcomePageStateNotifier extends StateNotifier<WelcomePageState> {
  WelcomePageStateNotifier() : super(WelcomePageState.initial());

  final SettingsBoxController _settingsBoxController =
      SettingsBoxController.initialize();

  void setAvatar(String newAvatar) {
    state = WelcomePageState(avatar: newAvatar);
  }

  final String defaultAvatar = K.avatarNames.user;
  final String defaultUserName = "User";

  Future<bool> saveNameRequest(
      {required String nameToSave, required String avatarToSave}) async {
    try {
      if (nameToSave.isEmpty) {
        return false;
      }

      state = WelcomePageState(avatar: avatarToSave);
      await _settingsBoxController.saveNameRequest(
        nameToSave: nameToSave,
        avatarToSave: avatarToSave,
      );
      return true;
    } catch (e) {
      print(" error in saving name : $e");
      return false;
    }
  }
}
