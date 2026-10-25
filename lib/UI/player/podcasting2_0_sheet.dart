import 'package:flutter/material.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Services/podcasting2_0_repository.dart';
import 'package:podcast_search/podcast_search.dart' as ps;

class Podcasting20Sheet extends StatelessWidget {
  const Podcasting20Sheet(
      {super.key, required this.song, required this.onSeek});

  final Song song;
  final ValueChanged<Duration> onSeek;

  static Future<void> show(
      BuildContext context, Song song, ValueChanged<Duration> onSeek) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (_) => Podcasting20Sheet(song: song, onSeek: onSeek),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = Podcasting20Repository();
    final scheme = Theme.of(context).colorScheme;
    final secondary = scheme.secondary;
    return Material(
      color: scheme.primary,
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .7,
          child: FutureBuilder<Map<String, dynamic>>(
            future: repository.metadataFor(song.episodeData),
            builder: (context, snapshot) {
              final metadata = snapshot.data ?? const <String, dynamic>{};
              final chapterUrl = metadata['chaptersUrl'] as String? ?? '';
              final transcriptList =
                  (metadata['transcripts'] as List? ?? const []);
              if (chapterUrl.isEmpty && transcriptList.isEmpty) {
                return Center(
                  child: Text(
                    'This publisher has not provided chapters or a transcript.',
                    style: TextStyle(color: secondary),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return DefaultTabController(
                length: transcriptList.isEmpty ? 1 : 2,
                child: Column(children: [
                  TabBar(
                      labelColor: secondary,
                      unselectedLabelColor: secondary.withValues(alpha: 0.55),
                      indicatorColor: secondary,
                      tabs: [
                        const Tab(text: 'Chapters'),
                        if (transcriptList.isNotEmpty)
                          const Tab(text: 'Transcript')
                      ]),
                  Expanded(
                    child: TabBarView(children: [
                      _Chapters(
                          repository: repository,
                          song: song,
                          url: chapterUrl,
                          onSeek: onSeek),
                      if (transcriptList.isNotEmpty)
                        _Transcript(
                            repository: repository,
                            song: song,
                            descriptor: Map<String, dynamic>.from(
                                transcriptList.first as Map),
                            onSeek: onSeek),
                    ]),
                  ),
                ]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Chapters extends StatelessWidget {
  const _Chapters(
      {required this.repository,
      required this.song,
      required this.url,
      required this.onSeek});
  final Podcasting20Repository repository;
  final Song song;
  final String url;
  final ValueChanged<Duration> onSeek;
  @override
  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(
        future: _load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary));
          final chapters = snapshot.data ?? const [];
          if (chapters.isEmpty)
            return Center(
                child: Text('No chapter markers available.',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)));
          return ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (_, index) {
                final chapter =
                    Map<String, dynamic>.from(chapters[index] as Map);
                final start = (chapter['start'] as num? ?? 0).toDouble();
                return ListTile(
                  title: Text(
                      chapter['title'] as String? ?? 'Chapter ${index + 1}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  subtitle: Text(
                      Duration(milliseconds: (start * 1000).round())
                          .toString()
                          .split('.')
                          .first,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.65))),
                  onTap: () =>
                      onSeek(Duration(milliseconds: (start * 1000).round())),
                );
              });
        },
      );
  Future<List<dynamic>> _load() async {
    final metadata = await repository.metadataFor(song.episodeData);
    final cached = metadata['chapters'];
    if (cached is List) return cached;
    if (url.isEmpty) return const [];
    final chapters = await ps.Feed.loadChaptersByUrl(url: url);
    await repository.saveChapters(song.episodeData, chapters.chapters);
    return (await repository.metadataFor(song.episodeData))['chapters']
            as List? ??
        const [];
  }
}

class _Transcript extends StatelessWidget {
  const _Transcript(
      {required this.repository,
      required this.song,
      required this.descriptor,
      required this.onSeek});
  final Podcasting20Repository repository;
  final Song song;
  final Map<String, dynamic> descriptor;
  final ValueChanged<Duration> onSeek;
  @override
  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(
        future: _load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary));
          final lines = snapshot.data ?? const [];
          return ListView.builder(
              itemCount: lines.length,
              itemBuilder: (_, index) {
                final line = Map<String, dynamic>.from(lines[index] as Map);
                return ListTile(
                    title: Text(line['text'] as String? ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                    onTap: () => onSeek(
                        Duration(milliseconds: line['start'] as int? ?? 0)));
              });
        },
      );
  Future<List<dynamic>> _load() async {
    final url = descriptor['url'] as String? ?? '';
    final metadata = await repository.metadataFor(song.episodeData);
    final cached = (metadata['cachedTranscripts'] as Map?)?[url];
    if (cached is List) return cached;
    final transcript = await ps.Feed.loadTranscriptByUrl(
        transcriptUrl: ps.TranscriptUrl(
            url: url, type: _format(descriptor['type'] as String?)));
    await repository.saveTranscript(song.episodeData, url, transcript);
    return ((await repository.metadataFor(
            song.episodeData))['cachedTranscripts'] as Map?)?[url] as List? ??
        const [];
  }

  ps.TranscriptFormat _format(String? value) => switch (value) {
        'json' => ps.TranscriptFormat.json,
        'subrip' => ps.TranscriptFormat.subrip,
        'vtt' => ps.TranscriptFormat.vtt,
        _ => ps.TranscriptFormat.unsupported
      };
}
