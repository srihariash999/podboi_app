import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Controllers/backup_restore_controller.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/DataModels/subscription_data.dart';

class MockFilePicker extends Mock implements FilePicker {}

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box {}

class MockPlatformFile extends Mock implements PlatformFile {}

void main() {
  group('BackupRestoreController', () {
    late BackupRestoreController controller;
    late MockFilePicker mockFilePicker;
    late MockHive mockHive;
    late MockBox mockSettingsBox;
    late MockBox mockSubscriptionBox;
    late MockBox mockListeningHistoryBox;
    late MockBox mockEpisodeBox;

    setUp(() {
      mockFilePicker = MockFilePicker();
      mockHive = MockHive();
      mockSettingsBox = MockBox();
      mockSubscriptionBox = MockBox();
      mockListeningHistoryBox = MockBox();
      mockEpisodeBox = MockBox();

      when(mockHive.box(K.boxes.settingsBox)).thenReturn(mockSettingsBox);
      when(mockHive.box<SubscriptionData>(K.boxes.subscriptionBox))
          .thenReturn(mockSubscriptionBox as Box<SubscriptionData>);
      when(mockHive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox))
          .thenReturn(mockListeningHistoryBox as Box<ListeningHistoryData>);

      controller = BackupRestoreController();
    });

    test('initial state is false', () {
      expect(controller.state, false);
    });

    test('exportData saves data to a file', () async {
      when(mockSettingsBox.toMap()).thenReturn({'theme': 'dark'});
      when(mockSubscriptionBox.values).thenReturn([]);
      when(mockListeningHistoryBox.values).thenReturn([]);
      when(mockFilePicker.getDirectoryPath(
              dialogTitle: anyNamed('dialogTitle'),
              initialDirectory: anyNamed('initialDirectory')))
          .thenAnswer((_) async => '/fake/path');

      await controller.exportData();

      verify(mockFilePicker.getDirectoryPath(
          dialogTitle: 'Select a folder to save the backup file',
          initialDirectory: anyNamed('initialDirectory')));
    });
  });
}
