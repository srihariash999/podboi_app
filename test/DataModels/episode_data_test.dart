import 'package:flutter_test/flutter_test.dart';
import 'package:podboi/DataModels/episode_data.dart';

void main() {
  const episode = EpisodeData(
    id: 0,
    guid: 'episode-1',
    title: 'Episode one',
    description: 'Description',
    podcastId: 42,
    duration: 120,
    playedDuration: 20,
    downloadPath: '/downloads/episode.mp3',
  );

  group('EpisodeData.hasSameContentAs', () {
    test('returns true for identical persisted content', () {
      expect(episode.hasSameContentAs(episode.copyWith()), isTrue);
    });

    test('detects local playback changes', () {
      expect(
        episode.hasSameContentAs(episode.copyWith(playedDuration: 40)),
        isFalse,
      );
    });
  });
}
