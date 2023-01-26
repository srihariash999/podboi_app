import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

//* Provider for accessing themestate.
final themeController =
    StateNotifierProvider<ThemeStateNotifier, ThemeState>((ref) {
  return ThemeStateNotifier();
});

Box _genBox = Hive.box('generalBox');

//* state notifier for changes and actions.
class ThemeStateNotifier extends StateNotifier<ThemeState> {
  ThemeStateNotifier() : super(ThemeState.initial()) {
    getTheme();
  }

  getTheme() {
    String? _theme = _genBox.get('theme');

    if (_theme == null) {
      print(" theme is null");
      state = state.copyWith(
        themeData: _lightTheme,
        currentTheme: 'light',
      );
    } else {
      if (_theme == 'light') {
        print(" theme is light");
        state = state.copyWith(
          themeData: _lightTheme,
          currentTheme: 'light',
        );
      } else {
        print(" theme is dark");
        state = state.copyWith(
          themeData: _darkTheme,
          currentTheme: 'dark',
        );
      }
    }
  }

  changeTheme(String newTheme) async {
    print(" user wants to change theme to : $newTheme");
    await _genBox.put('theme', newTheme);
    if (newTheme == 'light') {
      state = state.copyWith(
        themeData: _lightTheme,
        currentTheme: 'light',
      );
    } else {
      state = state.copyWith(
        themeData: _darkTheme,
        currentTheme: 'dark',
      );
    }
  }
}

//*  theme state.
class ThemeState {
  final ThemeData themeData;
  final String currentTheme;
  ThemeState({required this.themeData, required this.currentTheme});
  factory ThemeState.initial() {
    return ThemeState(
      themeData: _lightTheme,
      currentTheme: 'light',
    );
  }
  ThemeState copyWith({ThemeData? themeData, String? currentTheme}) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}

ThemeData _lightTheme = ThemeData(
  primaryColor: Color(0xFF302F4D),
  primaryColorLight: Color(0xFF302F4D),
  // backgroundColor: Colors.white,
  highlightColor: Color(0xFF98c1d9),
  // ignore: deprecated_member_use
  buttonColor: Color(0xFF3d5a80),
  colorScheme: ColorScheme.light(
    secondary: Colors.black,
    background: Colors.white,
  ),
);

ThemeData _darkTheme = ThemeData(
  primaryColor: Color(0xFF302F4D),
  primaryColorLight: Colors.white,
  colorScheme: ColorScheme.dark(
    secondary: Colors.white,
    background: Color(0xFF120D31),
  ),
  highlightColor: Color(0xFF98c1d9),
  // ignore: deprecated_member_use
  buttonColor: Color(0xFF3d5a80),
);
