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

  // Save episodes for a podcast.
  Future<bool> saveEpisodesForPodcast(
      List<EpisodeData> episodes, int podcast_id) async {
    try {
      // Open the box
      final episodeBox = await getBox(podcast_id.toString());
      // Clear the box
      await episodeBox.clear();
      // Add episodes to the box
      for (var episode in episodes) {
        await episodeBox.put(episode.guid, episode);
      }
      print(
          " saved : ${episodes.length} episodes for podcast: $podcast_id to local cache");
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
        episodeBox.put(guid, episode.copyWith(playedDuration: playedDuration));
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
        episodeBox.put(
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
}
