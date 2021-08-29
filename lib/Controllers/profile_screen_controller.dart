import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/general_box_controller.dart';

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

  _getUserDetails() {
    print(" this is called");
    state = state.copyWith(
      userAvatar: getSavedUserAvatar(),
      userName: getSavedUserName(),
    );
  }

  editProfile({required String name, required String avatar}) async {
    state = state.copyWith(loading: true);
    print(" edit called");
    await saveNameRequest(nameToSave: name, avatarToSave: avatar);
    state = state.copyWith(userAvatar: avatar, userName: name, loading: false);
    print(" profile edited ");
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
