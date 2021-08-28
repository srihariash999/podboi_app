import 'package:flutter_riverpod/flutter_riverpod.dart';

//* Provider for accessing themestate.
final themeController =
    StateNotifierProvider<ThemeStateNotifier, ThemeState>((ref) {
  return ThemeStateNotifier();
});

//* state notifier for changes and actions.
class ThemeStateNotifier extends StateNotifier<ThemeState> {
  ThemeStateNotifier() : super(ThemeState.initial());
}

//*  theme state.
class ThemeState {
  ThemeState();
  factory ThemeState.initial() {
    return ThemeState();
  }
}
