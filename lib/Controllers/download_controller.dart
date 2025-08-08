import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/DataModels/downloaded_episode.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/Database/download_box_controller.dart';

final downloadController =
    StateNotifierProvider<DownloadController, Map<String, double>>((ref) {
  return DownloadController(ref);
});

class DownloadController extends StateNotifier<Map<String, double>> {
  DownloadController(this._ref) : super({});

  final Ref _ref;
  final Dio _dio = Dio();
  final DownloadBoxController _downloadBoxController = DownloadBoxController();

  Future<void> downloadEpisode(EpisodeData episode) async {
    final downloads = await _downloadBoxController.getDownloads();
    if (downloads.any((e) => e.episode.guid == episode.guid)) {
      // Already downloaded
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${episode.guid}.mp3';

    state = {...state, episode.guid: 0.0};

    try {
      await _dio.download(
        episode.contentUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            state = {...state, episode.guid: progress};
          }
        },
      );

      final downloadedEpisode = DownloadedEpisode(
        episode: episode,
        downloadedOn: DateTime.now().toIso8601String(),
        filePath: filePath,
      );

      await _downloadBoxController.addDownload(downloadedEpisode);
      state = {...state}..remove(episode.guid);
    } catch (e) {
      state = {...state}..remove(episode.guid);
      // Handle error
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
    }
  }
}
