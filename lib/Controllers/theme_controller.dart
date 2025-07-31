import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Constants/theme_data.dart';
import 'package:podboi/Database/settings_box_controller.dart';

//* Provider for accessing themestate.
final themeController =
    StateNotifierProvider<ThemeStateNotifier, ThemeState>((ref) {
  return ThemeStateNotifier(sbController: SettingsBoxController())
    ..retrieveAndInitialiseTheme();
});

//* state notifier for changes and actions.
class ThemeStateNotifier extends StateNotifier<ThemeState> {
  final SettingsBoxController sbController;

  ThemeStateNotifier({required this.sbController})
      : super(ThemeState.initial());

  /// Method to get a themedata from a theme key.
  ThemeData getThemeData(String themeKey) =>
      themeKey == kLightThemeKey ? kLightThemeData : kDarkThemeData;

  /// Method to retrieve saved theme data from storage and initialise the theme.
  void retrieveAndInitialiseTheme() async {
    String? _theme = await sbController.getSavedTheme();

    state = state.copyWith(
      themeData: getThemeData(_theme ?? kLightThemeKey),
      currentTheme: _theme ?? kLightThemeKey,
    );
  }

  /// Method to change the app's theme from anywhere.
  Future<void> changeTheme(String newTheme) async {
    debugPrint(" user wants to change theme to : $newTheme");
    await sbController.saveThemeRequest(newTheme);

    state = state.copyWith(
      themeData: getThemeData(newTheme),
      currentTheme: newTheme,
    );
  }
}

//*  theme state.
class ThemeState {
  final ThemeData themeData;
  final String currentTheme;
  ThemeState({required this.themeData, required this.currentTheme});
  factory ThemeState.initial() {
    return ThemeState(
      themeData: kLightThemeData,
      currentTheme: kLightThemeKey,
    );
  }
  ThemeState copyWith({ThemeData? themeData, String? currentTheme}) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}
