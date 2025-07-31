import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Database/box_service.dart';

final backupRestoreController =
    StateNotifierProvider<BackupRestoreController, bool>((ref) {
  return BackupRestoreController();
});

class BackupRestoreController extends StateNotifier<bool> {
  BackupRestoreController() : super(false);

  final BoxService _boxService = BoxService();

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
    final settingsBox = await _boxService.getBox<dynamic>(K.boxes.settingsBox);
    Map<String, dynamic> settingsMap = {};
    for (var k in settingsBox.keys) {
      final val = settingsBox.get(k);
      if (val.runtimeType is CachedPlaybackState) {
        settingsMap[k] = (val as CachedPlaybackState).toJson();
      } else {
        settingsMap[k] = val;
      }
    }
    data['settings'] = settingsMap;

    // Subscriptions
    final subscriptionBox =
        await _boxService.getBox<SubscriptionData>(K.boxes.subscriptionBox);
    data['subscriptions'] =
        subscriptionBox.values.map((e) => e.toJson()).toList();

    // Listening History
    final listeningHistoryBox = await _boxService
        .getBox<ListeningHistoryData>(K.boxes.listeningHistoryBox);
    data['listening_history'] =
        listeningHistoryBox.values.map((e) => e.toJson()).toList();

    // Podcast Episodes

    final podcastEpisodeData = <String, dynamic>{};
    for (var sub in subscriptionBox.values) {
      final id = '${sub.podcastId.toString()}';

      final episodeBox = await _boxService.getBox<EpisodeData>(id);
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
    final settingsBox = await _boxService.getBox<dynamic>(K.boxes.settingsBox);
    final subscriptionBox =
        await _boxService.getBox<SubscriptionData>(K.boxes.subscriptionBox);
    final listeningHistoryBox = await _boxService
        .getBox<ListeningHistoryData>(K.boxes.listeningHistoryBox);

    // Clear existing data
    await settingsBox.clear();
    await subscriptionBox.clear();
    await listeningHistoryBox.clear();

    // Restore settings
    final settingsData = data['settings'] as Map<String, dynamic>;

    settingsData.forEach((key, value) {
      settingsBox.put(key, value);
    });

    // Restore subscriptions
    final subscriptionsData = data['subscriptions'] as List<dynamic>;

    for (var subData in subscriptionsData) {
      final sub = SubscriptionData.fromJson(subData);
      subscriptionBox.put(sub.podcastId, sub);
    }

    // Restore listening history
    final listeningHistoryData = data['listening_history'] as List<dynamic>;

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
      final episodeBox = await _boxService.getBox<EpisodeData>(podcastId);
      await episodeBox.clear();
      for (var episodeData in episodesData) {
        final episode = EpisodeData.fromJson(episodeData);
        episodeBox.put(episode.guid, episode);
      }
    }
  }
}
