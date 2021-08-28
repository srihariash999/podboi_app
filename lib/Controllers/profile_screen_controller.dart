import 'package:flutter_riverpod/flutter_riverpod.dart';

//* Provider for accessing profilestate.
final profileController =
    StateNotifierProvider<ProfileStateNotifier, ProfileState>((ref) {
  return ProfileStateNotifier();
});

//* state notifier for changes and actions.
class ProfileStateNotifier extends StateNotifier<ProfileState> {
  ProfileStateNotifier() : super(ProfileState.initial());
}

//*  Profile state.
class ProfileState {
  ProfileState();
  factory ProfileState.initial() {
    return ProfileState();
  }
}
