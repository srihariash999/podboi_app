import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podcast_search/podcast_search.dart' as ps;

/// Small, schema-free sidecar store for optional Podcasting 2.0 data. Keeping
/// it separate from the legacy Hive episode adapter avoids a destructive model
/// migration for existing installs.
class Podcasting20Repository {
  Future<Box<dynamic>> get _box async =>
      Hive.box<dynamic>(K.boxes.podcasting20Box);

  String keyFor(EpisodeData episode) => '${episode.podcastId}:${episode.guid}';

  Future<void> savePodcast(ps.Podcast podcast, int podcastId) async {
    await (await _box).put('podcast:$podcastId', {
      'guid': podcast.guid,
      'funding': podcast.funding
          .where((item) => item.url != null && item.url!.isNotEmpty)
          .map((item) => {'url': item.url, 'label': item.value})
          .toList(),
      'persons': podcast.persons.map(_person).toList(),
    });
  }

  Future<void> saveEpisode(ps.Episode source, EpisodeData episode) async {
    await (await _box).put(keyFor(episode), _episodeMetadata(source));
  }

  /// Persist a feed in one Hive transaction rather than one transaction per
  /// episode. Large feeds otherwise compete with the route transition for UI
  /// isolate time.
  Future<void> saveEpisodes(
      List<ps.Episode> sources, List<EpisodeData> episodes) async {
    assert(sources.length == episodes.length);
    final entries = <dynamic, dynamic>{
      for (var index = 0; index < episodes.length; index++)
        keyFor(episodes[index]): _episodeMetadata(sources[index]),
    };
    if (entries.isNotEmpty) await (await _box).putAll(entries);
  }

  Map<String, dynamic> _episodeMetadata(ps.Episode source) {
    return {
      'chaptersUrl': source.chapters?.url ?? '',
      'chaptersType': source.chapters?.type ?? '',
      'transcripts': source.transcripts
          .map((item) => {
                'url': item.url,
                'type': item.type.name,
                'language': item.language,
                'rel': item.rel,
              })
          .toList(),
      'persons': source.persons.map(_person).toList(),
      'alternateEnclosures': source.alternateEnclosures
          .map((item) => {
                'title': item.title,
                'mimeType': item.mimeType,
                'sources': item.sources.map((source) => source.uri).toList(),
              })
          .toList(),
    };
  }

  Future<Map<String, dynamic>> metadataFor(EpisodeData episode) async {
    final raw = (await _box).get(keyFor(episode));
    return raw is Map ? Map<String, dynamic>.from(raw) : const {};
  }

  Future<void> saveChapters(EpisodeData episode, List<dynamic> chapters) async {
    final value = await metadataFor(episode);
    value['chapters'] = chapters
        .where((chapter) => chapter.toc == true)
        .map(
          (chapter) => {
            'title': chapter.title,
            'start': chapter.startTime,
            'end': chapter.endTime,
            'image': chapter.imageUrl,
            'url': chapter.url,
          },
        )
        .toList();
    await (await _box).put(keyFor(episode), value);
  }

  Future<void> saveTranscript(
      EpisodeData episode, String url, ps.Transcript transcript) async {
    final value = await metadataFor(episode);
    final cached =
        Map<String, dynamic>.from(value['cachedTranscripts'] as Map? ?? {});
    cached[url] = transcript.subtitles
        .map((line) => {
              'start': line.start.inMilliseconds,
              'end': line.end.inMilliseconds,
              'text': line.data,
              'speaker': line.speaker,
            })
        .toList();
    value['cachedTranscripts'] = cached;
    await (await _box).put(keyFor(episode), value);
  }

  Map<String, dynamic> _person(dynamic person) => {
        'name': person.name,
        'role': person.role,
        'group': person.group,
        'image': person.image,
        'link': person.link,
      };
}
