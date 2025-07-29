import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/DataModels/subscription_data.dart';

final backupRestoreController =
    StateNotifierProvider<BackupRestoreController, bool>((ref) {
  return BackupRestoreController();
});

class BackupRestoreController extends StateNotifier<bool> {
  BackupRestoreController() : super(false);

  Future<void> exportData() async {
    state = true;
    try {
      final backupData = await _getAllData();
      final jsonString = jsonEncode(backupData);
      final directory = await getApplicationDocumentsDirectory();
      final path = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select a folder to save the backup file',
        initialDirectory: directory.path,
      );

      if (path != null) {
        final file = File('$path/podboi_backup.json');
        await file.writeAsString(jsonString);
      }
    } catch (e) {
      print("Error exporting data: $e");
    } finally {
      state = false;
    }
  }

  Future<Map<String, dynamic>> _getAllData() async {
    final Map<String, dynamic> data = {};

    // Settings
    final settingsBox = Hive.box(K.boxes.settingsBox);
    data['settings'] = settingsBox.toMap();

    // Subscriptions
    final subscriptionBox =
        Hive.box<SubscriptionData>(K.boxes.subscriptionBox);
    data['subscriptions'] =
        subscriptionBox.values.map((e) => e.toJson()).toList();

    // Listening History
    final listeningHistoryBox =
        Hive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox);
    data['listening_history'] =
        listeningHistoryBox.values.map((e) => e.toJson()).toList();

    // Podcast Episodes
    final subscriptionBoxData =
        Hive.box<SubscriptionData>(K.boxes.subscriptionBox);
    final podcastEpisodeData = <String, dynamic>{};
    for (var sub in subscriptionBoxData.values) {
      final episodeBox =
          await Hive.openBox<dynamic>('${sub.podcastId.toString()}');
      podcastEpisodeData[sub.podcastId.toString()] =
          episodeBox.values.map((e) => e.toJson()).toList();
    }
    data['podcast_episodes'] = podcastEpisodeData;
    return data;
  }

  Future<void> importData() async {
    state = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final backupData = jsonDecode(jsonString);
        await _restoreAllData(backupData);
      }
    } catch (e) {
      print("Error importing data: $e");
    } finally {
      state = false;
    }
  }

  Future<void> _restoreAllData(Map<String, dynamic> data) async {
    // Clear existing data
    await Hive.box(K.boxes.settingsBox).clear();
    await Hive.box<SubscriptionData>(K.boxes.subscriptionBox).clear();
    await Hive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox).clear();

    // Restore settings
    final settingsData = data['settings'] as Map<String, dynamic>;
    final settingsBox = Hive.box(K.boxes.settingsBox);
    settingsData.forEach((key, value) {
      settingsBox.put(key, value);
    });

    // Restore subscriptions
    final subscriptionsData = data['subscriptions'] as List<dynamic>;
    final subscriptionBox =
        Hive.box<SubscriptionData>(K.boxes.subscriptionBox);
    for (var subData in subscriptionsData) {
      final sub = SubscriptionData.fromJson(subData);
      subscriptionBox.put(sub.podcastId, sub);
    }

    // Restore listening history
    final listeningHistoryData = data['listening_history'] as List<dynamic>;
    final listeningHistoryBox =
        Hive.box<ListeningHistoryData>(K.boxes.listeningHistoryBox);
    for (var historyData in listeningHistoryData) {
      final history = ListeningHistoryData.fromJson(historyData);
      listeningHistoryBox.put(history.episodeData.guid, history);
    }

    // Restore podcast episodes
    final podcastEpisodesData =
        data['podcast_episodes'] as Map<String, dynamic>;
    for (var entry in podcastEpisodesData.entries) {
      final podcastId = entry.key;
      final episodesData = entry.value as List<dynamic>;
      final episodeBox = await Hive.openBox<dynamic>(podcastId);
      await episodeBox.clear();
      for (var episodeData in episodesData) {
        final episode = EpisodeData.fromJson(episodeData);
        episodeBox.put(episode.guid, episode);
      }
    }
  }
}
