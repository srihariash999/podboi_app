import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Database/playback_cache_controller.dart';

import 'playback_cache_controller_test.mocks.dart';

@GenerateMocks([Box, Song])
void main() {
  late final MockBox box;
  late final PlaybackCacheController controller;

  setUpAll(() async {
    // Setup Hive for testing
    await setUpTestHive();
    box = MockBox();
    controller = PlaybackCacheController(box);
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  group("initialisation", () {
    test('should initialize with the correct box', () async {
      await Hive.openBox(K.boxes.settingsBox);
      final initializedController = PlaybackCacheController.initialize();
      expect(initializedController.box, isNotNull);
      expect(initializedController.box, isA<Box>());
    });
  });

  group('storePlaybackPosition', () {
    test('should store the playback position', () async {
      final song = MockSong();
      final result = await controller.storePlaybackPosition(100, song);
      expect(result, isTrue);
      verify(box.put(controller.playbackPositionKey, any)).called(1);
    });

    test(
        'should return false if there is an error storing the playback position',
        () async {
      final song = MockSong();
      when(box.put(controller.playbackPositionKey, any)).thenThrow(Exception());
      final result = await controller.storePlaybackPosition(100, song);
      expect(result, isFalse);
    });
  });

  group('storePlaybackQueue', () {
    test('should store the playback queue', () async {
      final songs = [MockSong(), MockSong()];
      final result = await controller.storePlaybackQueue(songs);
      expect(result, isTrue);

      final verification =
          verify(box.put(controller.playbckQueueKey, captureAny));

      // check if box.put is called.
      verification.called(1);

      final captured = verification.captured.single;

      // verify args used to put the data into bpx.
      expect(captured, isA<List<MockSong>>());
      expect(captured, equals(songs));
    });

    test('should return false if there is an error storing the playback queue',
        () async {
      final song = MockSong();
      when(box.put(controller.playbckQueueKey, any)).thenThrow(Exception());
      final result = await controller.storePlaybackQueue([song]);
      expect(result, isFalse);
    });
  });

  group('getLastSavedPlaybackPosition', () {
    test('should return the last saved playback position', () async {
      final song = MockSong();
      final cachedPlaybackState =
          CachedPlaybackState(duration: 100, song: song);
      when(box.get(controller.playbackPositionKey))
          .thenReturn(cachedPlaybackState);
      final result = await controller.getLastSavedPlaybackPosition();
      expect(result, isNotNull);
      expect(result, equals(cachedPlaybackState));
    });

    test(
        'should return null if there is an error getting the last saved playback position',
        () async {
      when(box.get(controller.playbackPositionKey)).thenThrow(Exception());
      final result = await controller.getLastSavedPlaybackPosition();
      expect(result, isNull);
    });
  });

  group('getLastSavedPlaybackQueue', () {
    test('should return the last saved playback queue', () async {
      final song = MockSong();
      final mockSavedQueue = [song, song];
      when(box.get(controller.playbckQueueKey)).thenReturn(mockSavedQueue);
      final result = await controller.getLastSavedPlaybackQueue();
      expect(result, isNotNull);
      expect(result, equals(mockSavedQueue));
    });

    test(
        'should return null if there is an error getting the last saved playback queue',
        () async {
      when(box.get(controller.playbckQueueKey)).thenThrow(Exception());
      final result = await controller.getLastSavedPlaybackQueue();
      expect(result, isNull);
    });
  });

  group('clearSavedPlaybackPosition', () {
    test('should clear the last saved playback position', () async {
      final result = await controller.clearSavedPlaybackPosition();
      expect(result, isTrue);
      verify(box.delete(controller.playbackPositionKey)).called(1);
    });

    test(
        'should return false if there is an error clearing the last saved playback position',
        () async {
      when(box.delete(controller.playbackPositionKey)).thenThrow(Exception());
      final result = await controller.clearSavedPlaybackPosition();
      expect(result, isFalse);
    });
  });

  group('clearSavedPlaybackQueue', () {
    test('should clear the last saved playback queue', () async {
      final result = await controller.clearSavedPlaybackQueue();
      expect(result, isTrue);
      verify(box.delete(controller.playbckQueueKey)).called(1);
    });

    test(
        'should return false if there is an error clearing the last saved playback queue',
        () async {
      when(box.delete(controller.playbckQueueKey)).thenThrow(Exception());
      final result = await controller.clearSavedPlaybackQueue();
      expect(result, isFalse);
    });
  });
}
