import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mockito/mockito.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Database/settings_box_controller.dart';

import 'listening_history_box_controller_test.mocks.dart';

void main() {
  late MockBox mockBox;
  late SettingsBoxController controller;

  setUp(() async {
    mockBox = MockBox();
    controller = SettingsBoxController(mockBox);
    await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('initialize', () {
    test('should initialize with the correct box', () async {
      await Hive.openBox(K.boxes.settingsBox);
      final initializedController = SettingsBoxController.initialize();
      expect(initializedController.box, isNotNull);
      expect(initializedController.box, isA<Box>());
    });

    test('If a box is passed in, the getter should return the same box', () {
      final initializedController = SettingsBoxController(mockBox);
      expect(initializedController.box, mockBox);
    });
  });

  group('Saving and retrieving subs first setting', () {
    test('should save `true` to settings box', () async {
      when(mockBox.put(K.settingsKeys.subsFirstKey, true))
          .thenAnswer((_) => Future.value());
      final result = await controller.saveSubsFirstSetting(true);
      verify(mockBox.put(K.settingsKeys.subsFirstKey, true)).called(1);
      expect(result, true);
    });

    test('should save `false` to settings box', () async {
      when(mockBox.put(K.settingsKeys.subsFirstKey, false))
          .thenAnswer((_) => Future.value());
      final result = await controller.saveSubsFirstSetting(false);
      verify(mockBox.put(K.settingsKeys.subsFirstKey, false)).called(1);
      expect(result, true);
    });

    test('return false if saving to settings box fails', () async {
      when(mockBox.put(K.settingsKeys.subsFirstKey, true))
          .thenThrow(Exception('Error'));
      when(mockBox.put(K.settingsKeys.subsFirstKey, false))
          .thenThrow(Exception('Error'));

      var result = await controller.saveSubsFirstSetting(false);
      verify(mockBox.put(K.settingsKeys.subsFirstKey, false)).called(1);
      expect(result, false);

      result = await controller.saveSubsFirstSetting(true);
      verify(mockBox.put(K.settingsKeys.subsFirstKey, true)).called(1);
      expect(result, false);
    });

    test('Retrieve saved setting value.', () async {
      // test for true;
      when(mockBox.get(K.settingsKeys.subsFirstKey)).thenReturn(true);

      // get the value back
      var savedValue = await controller.getSubsFirst();
      expect(savedValue, true);

      // test for false
      when(mockBox.get(K.settingsKeys.subsFirstKey)).thenReturn(false);
      savedValue = await controller.getSubsFirst();

      // test for null
      when(mockBox.get(K.settingsKeys.subsFirstKey)).thenReturn(null);
      savedValue = await controller.getSubsFirst();
      expect(savedValue, false);
    });
  });

  group('Saving and retrieving name & avatar', () {
    test('should save name and avatar to settings box', () async {
      when(mockBox.put(K.settingsKeys.userNameKey, 'name'))
          .thenAnswer((_) => Future.value());

      when(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar'))
          .thenAnswer((_) => Future.value());

      final result = await controller.saveNameRequest(
        nameToSave: 'name',
        avatarToSave: 'avatar',
      );

      verify(mockBox.put(K.settingsKeys.userNameKey, 'name')).called(1);
      verify(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar')).called(1);
      expect(result, true);
    });

    test('should not save name or avatar when they throw errors.', () async {
      // When both puts throw an error. (also encompasses only name throwing error case)
      when(mockBox.put(K.settingsKeys.userNameKey, 'name'))
          .thenThrow(Exception('Error'));

      when(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar'))
          .thenThrow(Exception('Error'));

      var result = await controller.saveNameRequest(
        nameToSave: 'name',
        avatarToSave: 'avatar',
      );

      verify(mockBox.put(K.settingsKeys.userNameKey, 'name')).called(1);
      verifyNever(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar'));
      expect(result, false);

      // When only avatar throws an error.
      when(mockBox.put(K.settingsKeys.userNameKey, 'name'))
          .thenAnswer((_) => Future.value());

      when(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar'))
          .thenThrow(Exception('Error'));

      result = await controller.saveNameRequest(
        nameToSave: 'name',
        avatarToSave: 'avatar',
      );

      verify(mockBox.put(K.settingsKeys.userNameKey, 'name')).called(1);
      verify(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar')).called(1);
      expect(result, false);

      // When only avatar throws an error.
      when(mockBox.put(K.settingsKeys.userNameKey, 'name'))
          .thenAnswer((_) => Future.value());

      when(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar'))
          .thenThrow(Exception('Error'));

      result = await controller.saveNameRequest(
        nameToSave: 'name',
        avatarToSave: 'avatar',
      );

      verify(mockBox.put(K.settingsKeys.userNameKey, 'name')).called(1);
      verify(mockBox.put(K.settingsKeys.userAvatarKey, 'avatar')).called(1);
      expect(result, false);
    });

    test('retrieve saved name and avatar', () async {
      when(mockBox.get(K.settingsKeys.userNameKey)).thenReturn('name');
      when(mockBox.get(K.settingsKeys.userAvatarKey)).thenReturn('avatar');

      var savedName = await controller.getSavedUserName();
      var savedAvatar = await controller.getSavedUserAvatar();

      expect(savedName, 'name');
      expect(savedAvatar, 'avatar');

      when(mockBox.get(K.settingsKeys.userNameKey)).thenReturn(null);
      when(mockBox.get(K.settingsKeys.userAvatarKey)).thenReturn(null);

      savedName = await controller.getSavedUserName();
      savedAvatar = await controller.getSavedUserAvatar();

      expect(savedName, null);
      expect(savedAvatar, null);
    });
  });

  group('Saving and retrieving token', () {
    test('should save token to settings box', () async {
      when(mockBox.put(K.settingsKeys.tokenKey, 'token'))
          .thenAnswer((_) => Future.value());
      final result = await controller.saveTokenRequest(token: 'token');
      verify(mockBox.put(K.settingsKeys.tokenKey, 'token')).called(1);
      expect(result, true);
    });

    test('should not save token when it throws an error', () async {
      when(mockBox.put(K.settingsKeys.tokenKey, 'token'))
          .thenThrow(Exception('Error'));
      final result = await controller.saveTokenRequest(token: 'token');
      verify(mockBox.put(K.settingsKeys.tokenKey, 'token')).called(1);
      expect(result, false);
    });

    test('retrieve saved token', () async {
      when(mockBox.get(K.settingsKeys.tokenKey)).thenReturn('token');
      var savedToken = await controller.getSavedToken();
      expect(savedToken, 'token');

      // If token is null, it should return ""
      when(mockBox.get(K.settingsKeys.tokenKey)).thenReturn(null);
      savedToken = await controller.getSavedToken();
      expect(savedToken, "");
    });
  });

  group('Saving and retrieving theme', () {
    test('should save theme to settings box', () async {
      when(mockBox.put(K.settingsKeys.themeKey, 'light'))
          .thenAnswer((_) => Future.value());
      final result = await controller.saveThemeRequest('light');
      verify(mockBox.put(K.settingsKeys.themeKey, 'light')).called(1);
      expect(result, true);
    });

    test('should not save theme when it throws an error', () async {
      when(mockBox.put(K.settingsKeys.themeKey, 'light'))
          .thenThrow(Exception('Error'));
      final result = await controller.saveThemeRequest('light');
      verify(mockBox.put(K.settingsKeys.themeKey, 'light')).called(1);
      expect(result, false);
    });

    test('retrieve saved theme', () async {
      when(mockBox.get(K.settingsKeys.themeKey)).thenReturn('light');
      var savedTheme = await controller.getSavedTheme();
      expect(savedTheme, 'light');

      // If theme is null, it should return null
      when(mockBox.get(K.settingsKeys.themeKey)).thenReturn(null);
      savedTheme = await controller.getSavedTheme();
      expect(savedTheme, null);
    });
  });

  group('Saving and retrieving rewind duration setting', () {
    test('should save rewind duration setting to settings box', () async {
      when(mockBox.put(K.settingsKeys.rewindDurationKey, 15))
          .thenAnswer((_) => Future.value());
      final result = await controller.saveRewindDurationSetting(15);
      verify(mockBox.put(K.settingsKeys.rewindDurationKey, 15)).called(1);
      expect(result, true);
    });

    test('return false if saving rewind duration setting fails', () async {
      when(mockBox.put(K.settingsKeys.rewindDurationKey, 15))
          .thenThrow(Exception('Error'));
      final result = await controller.saveRewindDurationSetting(15);
      verify(mockBox.put(K.settingsKeys.rewindDurationKey, 15)).called(1);
      expect(result, false);
    });

    test('Retrieve saved rewind duration setting value.', () async {
      when(mockBox.get(K.settingsKeys.rewindDurationKey)).thenReturn(15);
      var savedValue = controller.getRewindDurationSetting();
      expect(savedValue, 15);

      // test for null (should return default: 30)
      when(mockBox.get(K.settingsKeys.rewindDurationKey)).thenReturn(null);
      savedValue = controller.getRewindDurationSetting();
      expect(savedValue, 30);
    });
  });

  group('Saving and retrieving forward duration setting', () {
    test('should save forward duration setting to settings box', () async {
      when(mockBox.put(K.settingsKeys.forwardDurationKey, 45))
          .thenAnswer((_) => Future.value());
      final result = await controller.saveForwardDurationSetting(45);
      verify(mockBox.put(K.settingsKeys.forwardDurationKey, 45)).called(1);
      expect(result, true);
    });

    test('return false if saving forward duration setting fails', () async {
      when(mockBox.put(K.settingsKeys.forwardDurationKey, 45))
          .thenThrow(Exception('Error'));
      final result = await controller.saveForwardDurationSetting(45);
      verify(mockBox.put(K.settingsKeys.forwardDurationKey, 45)).called(1);
      expect(result, false);
    });

    test('Retrieve saved forward duration setting value.', () async {
      when(mockBox.get(K.settingsKeys.forwardDurationKey)).thenReturn(45);
      var savedValue = controller.getForwardDurationSetting();
      expect(savedValue, 45);

      // test for null (should return default: 30)
      when(mockBox.get(K.settingsKeys.forwardDurationKey)).thenReturn(null);
      savedValue = controller.getForwardDurationSetting();
      expect(savedValue, 30);
    });
  });
}
