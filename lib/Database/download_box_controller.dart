import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/downloaded_episode.dart';
import 'package:podboi/Database/box_service.dart';

class DownloadBoxController {
  final BoxService _boxService = BoxService();

  Future<Box<DownloadedEpisode>> getBox() =>
      _boxService.getBox<DownloadedEpisode>(K.boxes.downloadsBox);

  Future<List<DownloadedEpisode>> getDownloads() async {
    final box = await getBox();
    return box.values.toList();
  }

  Future<void> addDownload(DownloadedEpisode download) async {
    final box = await getBox();
    await box.put(download.episode.guid, download);
  }

  Future<void> deleteDownload(String guid) async {
    final box = await getBox();
    await box.delete(guid);
  }

  Future<DownloadedEpisode?> getDownload(String guid) async {
    final box = await getBox();
    return box.get(guid);
  }
}
