import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:podboi/Constants/theme_data.dart';
import 'package:podboi/Controllers/theme_controller.dart';
import 'package:podboi/Database/settings_box_controller.dart';

import '../DatabaseServices/playback_cache_controller_test.mocks.dart';

void main() {
  late MockBox mockBox;
  late SettingsBoxController mockSettingsBoxController;

  setUp(() {
    mockBox = MockBox();
    mockSettingsBoxController = SettingsBoxController(mockBox);
  });

  group('ThemeStateNotifier Tests', () {
    test('Initial state should be light theme', () {
      final themeNotifier =
          ThemeStateNotifier(sbController: mockSettingsBoxController);

      expect(themeNotifier.state.themeData, kLightThemeData);
      expect(themeNotifier.state.currentTheme, kLightThemeKey);
    });

    test('retrieveAndInitialiseTheme should set theme from saved theme value',
        () {
      // Saved theme is dark.
      when(mockSettingsBoxController.getSavedTheme()).thenReturn(kDarkThemeKey);

      final themeNotifier =
          ThemeStateNotifier(sbController: mockSettingsBoxController);

      // by default should be light theme.
      expect(themeNotifier.state.themeData, kLightThemeData);
      expect(themeNotifier.state.currentTheme, kLightThemeKey);

      themeNotifier.retrieveAndInitialiseTheme();

      // should be set to dark theme that was saved.
      expect(themeNotifier.state.themeData, kDarkThemeData);
      expect(themeNotifier.state.currentTheme, kDarkThemeKey);

      // Saved theme is light.
      when(mockSettingsBoxController.getSavedTheme())
          .thenReturn(kLightThemeKey);

      themeNotifier.retrieveAndInitialiseTheme();

      // should be set to light theme that was saved.
      expect(themeNotifier.state.themeData, kLightThemeData);
      expect(themeNotifier.state.currentTheme, kLightThemeKey);

      // No saved theme.
      when(mockSettingsBoxController.getSavedTheme()).thenReturn(null);

      themeNotifier.retrieveAndInitialiseTheme();

      // should be set to light theme when no saved theme is retrieved.
      expect(themeNotifier.state.themeData, kLightThemeData);
      expect(themeNotifier.state.currentTheme, kLightThemeKey);
    });

    test('changeTheme should update theme and save it', () async {
      // Switching to dark theme.
      when(mockSettingsBoxController.saveThemeRequest(kDarkThemeKey))
          .thenAnswer((_) async => true);
      final themeNotifier =
          ThemeStateNotifier(sbController: mockSettingsBoxController);

      await themeNotifier.changeTheme(kDarkThemeKey);

      expect(themeNotifier.state.themeData, kDarkThemeData);
      expect(themeNotifier.state.currentTheme, kDarkThemeKey);
      verify(mockSettingsBoxController.saveThemeRequest(kDarkThemeKey))
          .called(1);

      // Switching to light theme.
      when(mockSettingsBoxController.saveThemeRequest(kLightThemeKey))
          .thenAnswer((_) async => true);

      await themeNotifier.changeTheme(kLightThemeKey);

      expect(themeNotifier.state.themeData, kLightThemeData);
      expect(themeNotifier.state.currentTheme, kLightThemeKey);
      verify(mockSettingsBoxController.saveThemeRequest(kLightThemeKey))
          .called(1);
    });
  });

  group('ThemeState Tests', () {
    test('copyWith should update only provided fields', () {
      final initialState =
          ThemeState(themeData: kLightThemeData, currentTheme: kLightThemeKey);
      final updatedState = initialState.copyWith(currentTheme: kDarkThemeKey);

      expect(updatedState.themeData, kLightThemeData);
      expect(updatedState.currentTheme, kDarkThemeKey);
    });

    test('initial factory should return light theme state', () {
      final initialState = ThemeState.initial();

      expect(initialState.themeData, kLightThemeData);
      expect(initialState.currentTheme, kLightThemeKey);
    });
  });
}
