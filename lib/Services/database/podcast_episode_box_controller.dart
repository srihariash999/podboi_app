import 'package:hive/hive.dart';
import 'package:podboi/DataModels/episode_data.dart';

class PodcastEpisodeBoxController {
  // Get stored episodes if present for a podcast
  static Future<List<EpisodeData>?> maybeGetEpisodesForPodcast(
      int podcast_id) async {
    Box<EpisodeData>? episodeBox;
    try {
      episodeBox = await Hive.openBox<EpisodeData>(podcast_id.toString());
      // get episodes
      var episodes = episodeBox.values.toList();
      // await episodeBox.close();
      return episodes;
    } catch (e) {
      print(
          " Error while trying to fetch cached episodes for podcast with id: $podcast_id. Error: $e");
      // await episodeBox?.close();
      return null;
    }
  }

  // Save episodes for a podcast.
  static Future<bool> saveEpisodesForPodcast(
      List<EpisodeData> episodes, int podcast_id) async {
    try {
      // Open the box
      var box = await Hive.openBox<EpisodeData>(podcast_id.toString());
      // Clear the box
      await box.clear();
      // Add episodes to the box
      for (var episode in episodes) {
        await box.put(episode.guid, episode);
      }
      // box.close();
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
  static Future<bool> storePlayedDuration(
      String guid, int playedDuration, int podcast_id) async {
    Box<EpisodeData>? episodeBox;
    Box<EpisodeData>? box;
    try {
      episodeBox =
          box ?? await Hive.openBox<EpisodeData>(podcast_id.toString());
      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        // update played duration
        episodeBox.put(guid, episode.copyWith(playedDuration: playedDuration));
        print(
            " stored played duration for episode with guid: $guid and pod id $podcast_id. Updated duration: $playedDuration");
        // await episodeBox.close();
        return true;
      } else {
        print(
            "Episode with guid: $guid not found for podcast id $podcast_id to store played duration ");
        // await episodeBox.close();
        return false;
      }
    } catch (e) {
      print(
          " Error while trying to store played duration for episode with guid: $guid. Error: $e");
      // await episodeBox?.close();
      return false;
    }
  }

  // Get played duration of an episode of a podcast.
  static Future<int?> getPlayedDuration(String guid, int podcast_id) async {
    Box<EpisodeData>? episodeBox;
    try {
      // Open the box
      episodeBox = await Hive.openBox<EpisodeData>(podcast_id.toString());
      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        print(
            " stored played duration for episode with guid: $guid. Duration: ${episode.playedDuration}");
        // await episodeBox.close();
        return episode.playedDuration;
      } else {
        print("Episode with guid: $guid not foud to get played duration ");
        // await episodeBox.close();
        return null;
      }
    } catch (e) {
      print(
          " Error while trying to get played duration for episode with guid: $guid. Error: $e");
      return null;
    }
  }

  // Save an episode as played.
  static Future<bool> markEpisodeAsPlayed(String guid, int podcast_id) async {
    Box<EpisodeData>? episodeBox;
    try {
      // Open the box
      episodeBox = await Hive.openBox<EpisodeData>(podcast_id.toString());
      // get episode
      var episode = episodeBox.get(guid);
      if (episode != null) {
        // update played duration
        episodeBox.put(
            guid, episode.copyWith(playedDuration: episode.duration));
        print(
            " stored played duration for episode with guid: $guid and pod id $podcast_id. Updated duration: ${episode.duration}");
        // await episodeBox.close();
        return true;
      } else {
        print(
            "Episode with guid: $guid and podcast id $podcast_id not found to store played duration ");
        // await episodeBox.close();
        return false;
      }
    } catch (e) {
      print(
          " Error while trying to store played duration for episode with guid: $guid. Error: $e");
      // await episodeBox?.close();
      return false;
    }
  }
}
