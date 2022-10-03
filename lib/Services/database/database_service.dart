// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:podboi/Services/database/database.dart';
// import 'package:podcast_search/podcast_search.dart';

final _db = MyDb();

final databaseServiceProvider = Provider((ref) {
  return DatabaseService();
});

class IsSubbed {
  int? id;
  bool value;
  IsSubbed({
    this.id,
    required this.value,
  });
}

class DatabaseService {
  /// Method that saves a given podcast item to user's subscriptions.
  Future<int?> savePodcastToSubs(SubscriptionData podcast) async {
    try {
      var isSub = await isPodcastSubbed(podcast);
      print(" is sub : ${isSub.value} ${isSub.id}");
      if (isSub.value) {
        return null;
      }

      // Try and create subscription.
      return await _db.insertSubscription(
        podcast.podcastName,
        podcast.podcastId,
        podcast.feedUrl,
        podcast.artworkUrl,
        DateTime.now(),
        null,
        podcast.trackCount,
        podcast.releaseDate,
        podcast.country,
        podcast.genre,
        podcast.contentAdvisory,
      );
    } catch (e) {
      print(" error saving podcast: $e");

      //if saving failed, return false.
      return null;
    }
  }

  Future<IsSubbed> isPodcastSubbed(SubscriptionData podcast) async {
    // If the collection id being queried is null, return false.
    if (podcast.podcastId == null) return IsSubbed(value: false);

    // Get stored subs with given id.
    var res = await _db.selectSubscriptionUsingId(podcast.podcastId).get();

    // If the result is empty, podcast is not subbed.
    if (res.isEmpty) return IsSubbed(value: false);

    // If not empty, podcast is subbed.
    return IsSubbed(value: true, id: res.first.id);
  }

  Future<List<SubscriptionData>> getAllSubscriptions() async {
    try {
      var res = await _db.selectAllSubscriptions().get();
      return res;
    } catch (e) {
      return [];
    }
  }

  Future<bool> removePodcastFromSubs(int id) async {
    try {
      await deleteEpisodesFromCacheById(id);
      await _db.deleteSubscriptionUsingId(id);
      return true;
    } catch (e) {
      print(" error deleting podcast: $e");
      return false;
    }
  }

  Future<List<ListeningHistoryData>> getLhiList() async {
    List<ListeningHistoryData> _lhis = await _db.selectAllLHIs().get();
    return _lhis;
  }

  Future<bool> saveLhi(ListeningHistoryData lhi) async {
    print(" here to save to history yo ${lhi.name} ");
    try {
      await _db.insertLHI(
        lhi.url,
        lhi.artist,
        lhi.icon,
        lhi.album,
        lhi.duration,
        lhi.podcastName,
        lhi.podcastArtwork,
        lhi.listenedOn,
        lhi.name,
      );
      return true;
    } catch (e) {
      print(" error saving lhi: $e");
      return false;
    }
  }

  Future<bool> removeLhiItem(int id) async {
    try {
      await _db.deleteLHIUsingId(id);
      return true;
    } catch (e) {
      print("error removing item: $e");
      return false;
    }
  }

  Future<bool> saveEpsiodesToCache(List<EpisodeData> episodes) async {
    try {
      for (var i in episodes) {
        await _db.insertEpisode(
          i.guid,
          i.title,
          i.description,
          i.link,
          i.publicationDate,
          i.contentUrl,
          i.imageUrl,
          i.author,
          i.season,
          i.episodeNumber,
          i.duration,
          i.podcastId,
          i.podcastName,
        );
      }
      print(" ${episodes.length} episodes saved to cache");
      return true;
    } catch (e) {
      print(" error saving episode:  $e");

      //if saving failed, return false.
      return false;
    }
  }

  Future<List<EpisodeData>> getEpisodesFromCacheById(int id) async {
    try {
      return await _db.selectEpisodesUsingPodcastId(id).get();
    } catch (e) {
      print(" error in getting episodes from cache: $e");
      return [];
    }
  }

  Future<bool> deleteEpisodesFromCacheById(int id) async {
    try {
      await _db.deleteEpisodeUsingId(id);
      return true;
    } catch (e) {
      print(" error in deleting episodes from cache: $e");
      return false;
    }
  }
}
