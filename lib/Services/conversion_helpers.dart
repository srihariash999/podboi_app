import 'dart:convert';

import 'package:podboi/DataModels/ListeningHistoryItem.dart';
import 'package:podcast_search/podcast_search.dart';

Map<String, dynamic> itemToMap(Item item) {
  return {
    'artistId': item.artistId,
    'collectionId': item.collectionId,
    'trackId': item.trackId,
    'guid': item.guid,
    'artistName': item.artistName,
    'collectionName': item.collectionName,
    'trackName': item.trackName,
    'collectionCensoredName': item.collectionCensoredName,
    'trackCensoredName': item.trackCensoredName,
    'artistViewUrl': item.artistViewUrl,
    'collectionViewUrl': item.collectionViewUrl,
    'feedUrl': item.feedUrl,
    'trackViewUrl': item.trackViewUrl,
    'artworkUrl30': item.artworkUrl30,
    'artworkUrl60': item.artworkUrl60,
    'artworkUrl100': item.artworkUrl100,
    'artworkUrl600': item.artworkUrl600,
    'artworkUrl': item.artworkUrl,
    'releaseDate': item.releaseDate,
    'collectionExplicitness': item.collectionExplicitness,
    'trackExplicitness': item.trackExplicitness,
    'trackCount': item.trackCount,
    'country': item.country,
    'primaryGenreName': item.primaryGenreName,
    'contentAdvisoryRating': item.contentAdvisoryRating,
    'genre': item.genre?.map((x) => genreToMap(x)).toList(),
  };
}

//$ Methods for Item class.

String itemToJson(Map itemMap) => json.encode(itemMap);

Item itemFromMap(Map<String, dynamic> map) {
  return Item(
    artistId: map['artistId'],
    collectionId: map['collectionId'],
    trackId: map['trackId'],
    guid: map['guid'],
    artistName: map['artistName'],
    collectionName: map['collectionName'],
    trackName: map['trackName'],
    collectionCensoredName: map['collectionCensoredName'],
    trackCensoredName: map['trackCensoredName'],
    artistViewUrl: map['artistViewUrl'],
    collectionViewUrl: map['collectionViewUrl'],
    feedUrl: map['feedUrl'],
    trackViewUrl: map['trackViewUrl'],
    artworkUrl30: map['artworkUrl30'],
    artworkUrl60: map['artworkUrl60'],
    artworkUrl100: map['artworkUrl100'],
    artworkUrl600: map['artworkUrl600'],
    artworkUrl: map['artworkUrl'],
    releaseDate: map['releaseDate'],
    collectionExplicitness: map['collectionExplicitness'],
    trackExplicitness: map['trackExplicitness'],
    trackCount: map['trackCount'],
    country: map['country'],
    primaryGenreName: map['primaryGenreName'],
    contentAdvisoryRating: map['contentAdvisoryRating'],
    genre: List<Genre>.from(map['genre']?.map((x) => genreFromMap(x))),
  );
}

//$ Methods for 'Genre' class
String genreToJson(Genre genre) => json.encode(genreToMap(genre));

Map<String, dynamic> genreToMap(Genre genre) {
  return {
    'id': genre.id,
    'name': genre.name,
  };
}

Genre genreFromMap(Map<dynamic, dynamic> genreMap) {
  return Genre(
    genreMap['id'] ?? 0,
    genreMap['name'] ?? 'random genre',
  );
}

// $ Methods for ListeningHistoryItem class.abstract

ListeningHistoryItem lhiFromMap(Map<dynamic, dynamic> lhiMap) {
  return ListeningHistoryItem(
    url: lhiMap['url'],
    name: lhiMap['name'],
    artist: lhiMap['artist'],
    icon: lhiMap['icon'],
    album: lhiMap['album'],
    duration: lhiMap['duration'],
    listenedOn: lhiMap['listenedOn'],
    podcastArtWork: lhiMap['podcastArtWork'],
    podcastName: lhiMap['podcastName'],
  );
}

Map<dynamic, dynamic> lhiToMap(ListeningHistoryItem lhi) {
  return {
    'url': lhi.url,
    'name': lhi.name,
    'artist': lhi.artist,
    'icon': lhi.icon,
    'album': lhi.album,
    'duration': lhi.duration,
    'listenedOn': lhi.listenedOn,
    'podcastArtWork': lhi.podcastArtWork,
    'podcastName': lhi.podcastName,
  };
}
