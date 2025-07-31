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

  final SettingsBoxController _settingsBoxController = SettingsBoxController();

  _getUserDetails() async {
    // Fetch user name and avatar from settings box
    String? userName = await _settingsBoxController.getSavedUserName();
    String? userAvatar = await _settingsBoxController.getSavedUserAvatar();
    state = state.copyWith(
      userAvatar: userAvatar,
      userName: userName,
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
