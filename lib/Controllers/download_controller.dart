import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/DataModels/downloaded_episode.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Database/download_box_controller.dart';
import 'package:podboi/Database/podcast_episode_box_controller.dart';

final downloadController =
    StateNotifierProvider<DownloadController, DownloadPageState>((ref) {
  return DownloadController(ref);
});

class DownloadController extends StateNotifier<DownloadPageState> {
  DownloadController(this.ref) : super(DownloadPageState.initial());

  final Ref ref;
  final Dio _dio = Dio();
  final DownloadBoxController _downloadBoxController = DownloadBoxController();
  final PodcastEpisodeBoxController _podcastEpisodeBoxController =
      PodcastEpisodeBoxController();

  Future<void> loadDownloads() async {
    state = state.copyWith(isLoading: true);
    final downloadBoxController = DownloadBoxController();
    final _downloads = await downloadBoxController.getDownloads();
    state = state.copyWith(
      downloads: _downloads,
      isLoading: false,
    );
  }

  Future<String?> downloadEpisode(
    EpisodeData episode,
    SubscriptionData subscriptionData,
  ) async {
    final downloads = await _downloadBoxController.getDownloads();
    if (downloads.any((e) => e.episode.guid == episode.guid)) {
      print('Episode already downloaded: ${episode.guid}');
      // Already downloaded
      throw EpisodeAlreadyDownloadedException(
        'Episode already downloaded',
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${episode.guid}.mp3';

    state = state.copyWith(
      downloadProgress: {...state.downloadProgress, episode.guid: 0.0},
    );

    try {
      await _dio.download(
        episode.contentUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            state = state.copyWith(
              downloadProgress: {
                ...state.downloadProgress,
                episode.guid: progress,
              },
            );
          }
        },
      );
      episode = episode.updateDownloadPath(
        downloadPath: filePath,
      );
      final downloadedEpisode = DownloadedEpisode(
        episode: episode,
        downloadedOn: DateTime.now().toIso8601String(),
        filePath: filePath,
        subscriptionData: subscriptionData,
      );

      await _downloadBoxController.addDownload(downloadedEpisode);
      await _podcastEpisodeBoxController.storeDownloadPath(
        episode.guid,
        filePath,
        episode.podcastId,
      );
      // state = {...state}..remove(episode.guid);
      state = state.copyWith(
        downloadProgress: {...state.downloadProgress}..remove(episode.guid),
      );

      return filePath;
    } catch (e) {
      // state = {...state}..remove(episode.guid);
      state = state.copyWith(
        downloadProgress: {...state.downloadProgress}..remove(episode.guid),
      );
      print(
        "Error downloading episode ${episode.guid}: $e",
      );
      // Handle error
      return null;
    }
  }

  Future<void> deleteEpisode(String guid) async {
    final download = await _downloadBoxController.getDownload(guid);
    if (download != null) {
      final file = File(download.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await _downloadBoxController.deleteDownload(guid);
      await _podcastEpisodeBoxController.removeDownloadPath(
        guid,
        download.episode.podcastId,
      );

      loadDownloads();
    }
  }
}

class DownloadPageState {
  final Map<String, double> downloadProgress;
  final List<DownloadedEpisode> downloads;
  final bool isLoading;

  DownloadPageState({
    required this.downloadProgress,
    required this.isLoading,
    required this.downloads,
  });

  factory DownloadPageState.initial() {
    return DownloadPageState(
      downloadProgress: {},
      isLoading: false,
      downloads: [],
    );
  }

  DownloadPageState copyWith({
    Map<String, double>? downloadProgress,
    bool? isLoading,
    List<DownloadedEpisode>? downloads,
  }) {
    return DownloadPageState(
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isLoading: isLoading ?? this.isLoading,
      downloads: downloads ?? this.downloads,
    );
  }
}

class EpisodeAlreadyDownloadedException implements Exception {
  final String message;

  EpisodeAlreadyDownloadedException(this.message);

  @override
  String toString() {
    return 'EpisodeAlreadyDownloadedException: $message';
  }
}
