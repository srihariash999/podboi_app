import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Database/settings_box_controller.dart';

//* Provider for accessing profilestate.
final profileController =
    StateNotifierProvider.autoDispose<ProfileStateNotifier, ProfileState>(
        (ref) {
  return ProfileStateNotifier();
});

//* state notifier for changes and actions.
class ProfileStateNotifier extends StateNotifier<ProfileState> {
  ProfileStateNotifier() : super(ProfileState.initial()) {
    _getUserDetails();
  }

  final SettingsBoxController _settingsBoxController =
      SettingsBoxController.initialize();

  _getUserDetails() {
    state = state.copyWith(
      userAvatar: _settingsBoxController.getSavedUserAvatar(),
      userName: _settingsBoxController.getSavedUserName(),
    );
  }

  editProfile({required String name, required String avatar}) async {
    state = state.copyWith(loading: true);
    await _settingsBoxController.saveNameRequest(
        nameToSave: name, avatarToSave: avatar);
    state = state.copyWith(userAvatar: avatar, userName: name, loading: false);
  }
}

//*  Profile state.
class ProfileState {
  final String userName;
  final String userAvatar;
  final bool loading;
  ProfileState(
      {required this.userName,
      required this.userAvatar,
      required this.loading});
  factory ProfileState.initial() {
    return ProfileState(
      userName: '',
      userAvatar: '',
      loading: false,
    );
  }

  ProfileState copyWith({String? userName, String? userAvatar, bool? loading}) {
    return ProfileState(
      userAvatar: userAvatar ?? this.userAvatar,
      userName: userName ?? this.userName,
      loading: loading ?? this.loading,
    );
  }
}
