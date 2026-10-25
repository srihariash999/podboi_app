import 'package:hive/hive.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/Database/box_service.dart';

class PodcastEpisodeBoxController {
  final BoxService _boxService = BoxService();

  /// Gets the box instance
  Future<Box<EpisodeData>> getBox(String boxId) =>
      _boxService.getBox<EpisodeData>(boxId);

  // Get stored episodes if present for a podcast
  Future<List<EpisodeData>?> maybeGetEpisodesForPodcast(int podcast_id) async {
    try {
      final episodeBox = await getBox(podcast_id.toString());
      // get episodes
      var episodes = episodeBox.values.toList();
      return episodes;
    } catch (e) {
      print(
          " Error while trying to fetch cached episodes for podcast with id: $podcast_id. Error: $e");
      return null;
    }
  }

  /// Upserts feed metadata without ever discarding local listening or download
  /// state. A feed can temporarily omit old episodes, so replacing the box is
  /// data loss rather than reconciliation.
  Future<bool> saveEpisodesForPodcast(
      List<EpisodeData> episodes, int podcast_id) async {
    try {
      final episodeBox = await getBox(podcast_id.toString());
      final updates = <dynamic, EpisodeData>{};
      for (var episode in episodes) {
        final existing = episodeBox.get(episode.guid);
        final merged = existing == null
            ? episode
            : episode.copyWith(
                playedDuration: existing.playedDuration,
                downloadPath: existing.downloadPath,
              );
        // A sync normally finds the same feed data. Avoiding no-op puts also
        // avoids box-watch events that unnecessarily rebuild the subscriptions
        // grid behind the details page.
        if (existing == null || !existing.hasSameContentAs(merged)) {
          updates[episode.guid] = merged;
        }
      }
      if (updates.isNotEmpty) await episodeBox.putAll(updates);
      print(
          " upserted : ${updates.length} episodes for podcast: $podcast_id to local cache");
      return true;
    } catch (e) {
      print(
          " Error while trying to save episodes for podcast with id: $podcast_id. Error: $e");
      return false;
    }
  }

  // Store played duration of an episode of a podcast.
  Future<bool> storePlayedDuration(
      String guid, int playedDuration, int podcast_id) async {
    try {
      final episodeBox = await getBox(podcast_id.toString());

      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        // update played duration
        await episodeBox.put(
            guid, episode.copyWith(playedDuration: playedDuration));
        print(
            " stored played duration for episode with guid: $guid and pod id $podcast_id. Updated duration: $playedDuration");
        return true;
      } else {
        print(
            "Episode with guid: $guid not found for podcast id $podcast_id to store played duration ");
        return false;
      }
    } catch (e) {
      print(
          " Error while trying to store played duration for episode with guid: $guid. Error: $e");
      return false;
    }
  }

  // Get played duration of an episode of a podcast.
  Future<int?> getPlayedDuration(String guid, int podcast_id) async {
    try {
      // Open the box
      final episodeBox = await getBox(podcast_id.toString());

      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        print(
            " stored played duration for episode with guid: $guid. Duration: ${episode.playedDuration}");
        return episode.playedDuration;
      } else {
        print("Episode with guid: $guid not foud to get played duration ");
        return null;
      }
    } catch (e) {
      print(
          " Error while trying to get played duration for episode with guid: $guid. Error: $e");
      return null;
    }
  }

  // Save an episode as played.
  Future<bool> markEpisodeAsPlayed(String guid, int podcast_id) async {
    try {
      // Open the box
      final episodeBox = await getBox(podcast_id.toString());

      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        // update played duration
        await episodeBox.put(
            guid, episode.copyWith(playedDuration: episode.duration));
        print(
            " stored played duration for episode with guid: $guid and pod id $podcast_id. Updated duration: ${episode.duration}");
        return true;
      } else {
        print(
            "Episode with guid: $guid and podcast id $podcast_id not found to store played duration ");
        return false;
      }
    } catch (e) {
      print(
          " Error while trying to mark an episode as played with guid: $guid. Error: $e");
      return false;
    }
  }

  // Store download path for an episode of a podcast.
  Future<bool> storeDownloadPath(
      String guid, String path, int podcast_id) async {
    try {
      final episodeBox = await getBox(podcast_id.toString());

      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        // update download path
        await episodeBox.put(
            guid, episode.updateDownloadPath(downloadPath: path));
        print(
            " stored download path for episode with guid: $guid and pod id $podcast_id. Download file path: $path");
        return true;
      } else {
        print(
            "Episode with guid: $guid not found for podcast id $podcast_id to update download path");
        return false;
      }
    } catch (e) {
      print(
          " Error while trying to store download path for episode with guid: $guid. Error: $e");
      return false;
    }
  }

  // remove download path for an episode of a podcast.
  Future<bool> removeDownloadPath(String guid, int podcast_id) async {
    try {
      final episodeBox = await getBox(podcast_id.toString());
      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        // update download path
        await episodeBox.put(
            guid, episode.updateDownloadPath(downloadPath: null));
        print(
            " removed download path for episode with guid: $guid and pod id $podcast_id.");
        return true;
      } else {
        print(
            "Episode with guid: $guid not found for podcast id $podcast_id to remove download path");
        return false;
      }
    } catch (e) {
      print(
          " Error while trying to remove download path for episode with guid: $guid. Error: $e");
      return false;
    }
  }
}
