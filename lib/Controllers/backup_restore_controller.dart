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
import 'package:podboi/Services/opml_subscription_parser.dart';
import 'package:podboi/Services/subscription_sync_service.dart';
import 'package:xml/xml.dart';

final backupRestoreController =
    StateNotifierProvider<BackupRestoreController, bool>((ref) {
  return BackupRestoreController();
});

class BackupRestoreController extends StateNotifier<bool> {
  BackupRestoreController() : super(false);

  final BoxService _boxService = BoxService();
  final OpmlSubscriptionParser _opmlParser = const OpmlSubscriptionParser();

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

  /// Imports subscriptions exported by other podcast apps as an OPML file.
  /// This deliberately merges into the subscription list; unlike a podboi
  /// backup restore, it never clears playback, settings, or current feeds.
  Future<OpmlImportResult> importOpmlSubscriptions() async {
    state = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['opml', 'xml'],
      );
      if (result == null || result.files.single.path == null) {
        return const OpmlImportResult.cancelled();
      }

      final source = await File(result.files.single.path!).readAsString();
      final imported = _opmlParser.parse(source);
      final subscriptionBox =
          await _boxService.getBox<SubscriptionData>(K.boxes.subscriptionBox);
      final existingUrls = subscriptionBox.values
          .map((subscription) => subscription.feedUrl.trim().toLowerCase())
          .toSet();
      final usedIds = subscriptionBox.keys.whereType<int>().toSet();
      var added = 0;
      var skipped = 0;

      for (final item in imported) {
        final urlKey = item.feedUrl.toLowerCase();
        if (!existingUrls.add(urlKey)) {
          skipped++;
          continue;
        }

        final podcastId = _uniquePodcastId(item.feedUrl, usedIds);
        usedIds.add(podcastId);
        await subscriptionBox.put(
          podcastId,
          SubscriptionData(
            id: podcastId,
            podcastId: podcastId,
            podcastName: item.title,
            feedUrl: item.feedUrl,
            artworkUrl: '',
            dateAdded: DateTime.now(),
          ),
        );
        added++;
      }

      // OPML contains feed URLs but generally not podcast artwork. Refreshing
      // the feeds immediately fills the grid/detail metadata and episode cache.
      if (imported.isNotEmpty) {
        await SubscriptionSyncService().refreshNow();
      }

      return OpmlImportResult(imported: added, skipped: skipped);
    } on XmlParserException {
      return const OpmlImportResult.invalidFile();
    } catch (error) {
      print('Error importing OPML subscriptions: $error');
      return const OpmlImportResult.failed();
    } finally {
      state = false;
    }
  }

  int _uniquePodcastId(String feedUrl, Set<int> usedIds) {
    var hash = 0x811c9dc5;
    for (final codeUnit in feedUrl.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    if (hash == 0) hash = 1;
    while (usedIds.contains(hash)) {
      hash = hash == 0x7fffffff ? 1 : hash + 1;
    }
    return hash;
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

class OpmlImportResult {
  const OpmlImportResult({required this.imported, required this.skipped})
      : cancelled = false,
        invalidFile = false,
        failed = false;

  const OpmlImportResult.cancelled()
      : imported = 0,
        skipped = 0,
        cancelled = true,
        invalidFile = false,
        failed = false;

  const OpmlImportResult.invalidFile()
      : imported = 0,
        skipped = 0,
        cancelled = false,
        invalidFile = true,
        failed = false;

  const OpmlImportResult.failed()
      : imported = 0,
        skipped = 0,
        cancelled = false,
        invalidFile = false,
        failed = true;

  final int imported;
  final int skipped;
  final bool cancelled;
  final bool invalidFile;
  final bool failed;
}
