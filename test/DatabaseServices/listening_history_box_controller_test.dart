// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive_test/hive_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:podboi/Constants/constants.dart';
// import 'package:podboi/DataModels/episode_data.dart';
// import 'package:podboi/DataModels/listening_history.dart';
// import 'package:podboi/Database/listening_history_box_controller.dart';

// import 'listening_history_box_controller_test.mocks.dart';

// @GenerateMocks([Box, EpisodeData])
// void main() {
//   late MockBox<ListeningHistoryData> mockBox;
//   late ListeningHistoryBoxController controller;

//   setUp(() async {
//     mockBox = MockBox<ListeningHistoryData>();
//     controller = ListeningHistoryBoxController(mockBox);
//     await setUpTestHive();
//   });

//   tearDown(() async {
//     await tearDownTestHive();
//   });

//   group('initialize', () {
//     test('should initialize with the correct box', () async {
//       await Hive.openBox<ListeningHistoryData>(K.boxes.listeningHistoryBox);
//       final initializedController = ListeningHistoryBoxController.initialize();
//       expect(initializedController.box, isNotNull);
//       expect(initializedController.box, isA<Box<ListeningHistoryData>>());
//     });
//   });

//   group('getHistoryList', () {
//     test('should return an empty list when the box is empty', () async {
//       when(mockBox.values).thenReturn([]);
//       final result = await controller.getHistoryList();
//       expect(result, isEmpty);
//     });

//     test('should return a list of history items when box is not empty',
//         () async {
//       final mockEpisodeData = MockEpisodeData();
//       when(mockEpisodeData.guid).thenReturn('123');

//       final mockData = ListeningHistoryData(
//         episodeData: mockEpisodeData,
//         listenedOn: DateTime.now().toIso8601String(),
//       );
//       when(mockBox.values).thenReturn([mockData]);
//       final result = await controller.getHistoryList();
//       expect(result, [mockData]);
//     });

//     test('should handle exception and return an empty list', () async {
//       when(mockBox.values).thenThrow(Exception('Hive error'));
//       final result = await controller.getHistoryList();
//       expect(result, isEmpty);
//     });
//   });

//   group('saveEpisodeToHistory', () {
//     test('should save an episode when history has less than 1000 items',
//         () async {
//       final mockEpisodeData = MockEpisodeData();
//       when(mockEpisodeData.guid).thenReturn('123');

//       final mockData = ListeningHistoryData(
//         episodeData: mockEpisodeData,
//         listenedOn: DateTime.now().toIso8601String(),
//       );

//       when(mockBox.values).thenReturn([]);
//       when(mockBox.put(any, any)).thenAnswer((_) async {});

//       final result = await controller.saveEpisodeToHistory(mockData);
//       expect(result, isTrue);
//       verify(mockBox.put('123', mockData)).called(1);
//     });

//     test('should remove the oldest item when history exceeds 1000 items',
//         () async {
//       final oldestMockEpisodeData = MockEpisodeData();
//       when(oldestMockEpisodeData.guid).thenReturn('oldest');

//       final newestMockEpisodeData = MockEpisodeData();
//       when(newestMockEpisodeData.guid).thenReturn('newest');

//       final oldestData = ListeningHistoryData(
//         episodeData: oldestMockEpisodeData,
//         listenedOn: DateTime(2020, 1, 1).toIso8601String(),
//       );
//       final newData = ListeningHistoryData(
//         episodeData: newestMockEpisodeData,
//         listenedOn: DateTime(2025, 1, 1).toIso8601String(),
//       );
//       final items = List.generate(1000, (index) => oldestData);

//       when(mockBox.values).thenReturn(items);
//       when(mockBox.delete('oldest')).thenAnswer((_) async {});
//       when(mockBox.put('newest', newData)).thenAnswer((_) async {});

//       final result = await controller.saveEpisodeToHistory(newData);
//       expect(result, isTrue);
//       verify(mockBox.delete('oldest')).called(1);
//       verify(mockBox.put('newest', newData)).called(1);
//     });

//     test('should return false if an exception occurs', () async {
//       final mockEpisodeData = MockEpisodeData();
//       when(mockEpisodeData.guid).thenReturn('error');
//       final mockData = ListeningHistoryData(
//         episodeData: mockEpisodeData,
//         listenedOn: DateTime.now().toIso8601String(),
//       );
//       when(mockBox.values).thenThrow(Exception('failed to get items'));
//       when(mockBox.put(any, any)).thenThrow(Exception('Save error'));

//       final result = await controller.saveEpisodeToHistory(mockData);
//       expect(result, isFalse);
//     });
//   });
// }
