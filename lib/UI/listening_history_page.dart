import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/history_controller.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Services/database/database.dart';
import 'package:podboi/Shared/episode_display_widget.dart';
import 'package:podboi/UI/player.dart';

class ListeningHistoryView extends StatelessWidget {
  ListeningHistoryView({Key? key, required this.ref}) : super(key: key);
  final WidgetRef ref;
  Future<void> _refresh() async {
    ref.read(historyController.notifier).getHistory(fullRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text(
            'Listening History',
            style: TextStyle(
              fontFamily: 'Segoe',
              fontSize: 22.0,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          bool _loading = ref.watch(
                              historyController.select((v) => v.isLoading));
                          bool _loadMoreLoading = ref.watch(historyController
                              .select((v) => v.isLoadMoreLoading));
                          bool _noNextPage = ref.watch(
                              historyController.select((v) => v.noNextPage));
                          List<ListeningHistoryData> _list = ref.watch(
                            historyController
                                .select((value) => value.historyList),
                          );
                          return _loading
                              ? Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                )
                              : _list.length == 0
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        " No history found",
                                        style: TextStyle(
                                          // fontFamily: 'Segoe',
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: _refresh,
                                      child: ListView.separated(
                                        itemCount: _list.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == _list.length) {
                                            if (_noNextPage) return Container();
                                            return InkWell(
                                              onTap: () => ref
                                                  .read(historyController
                                                      .notifier)
                                                  .getNextPage(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 12.0,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _loadMoreLoading
                                                        ? "Loading more ..."
                                                        : "Load More",
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          ListeningHistoryData _lhi =
                                              _list[index];
                                          return GestureDetector(
                                            onTap: () async {
                                              ref
                                                  .read(
                                                      audioController.notifier)
                                                  .requestPlayingSong(
                                                    Song(
                                                      url: _lhi.url,
                                                      icon: _lhi.icon,
                                                      name: _lhi.name,
                                                      duration: Duration(
                                                        seconds: int.parse(
                                                            _lhi.duration),
                                                      ),
                                                      artist: _lhi.artist,
                                                      album: _lhi.album,
                                                      episodeData: EpisodeData(
                                                        id: _lhi.id,
                                                        guid:
                                                            _lhi.id.toString(),
                                                        title: _lhi.name,
                                                        description: _lhi.name,
                                                      ),
                                                    ),
                                                  );
                                              ref
                                                  .read(historyController
                                                      .notifier)
                                                  .saveToHistoryAction(
                                                    url: _lhi.url,
                                                    name: _lhi.name,
                                                    artist: _lhi.artist,
                                                    icon: _lhi.icon,
                                                    album: _lhi.album,
                                                    duration: _lhi.duration,
                                                    listenedOn: DateTime.now()
                                                        .toString(),
                                                    podcastArtWork:
                                                        _lhi.podcastArtwork,
                                                    podcastName:
                                                        _lhi.podcastName,
                                                  );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                              ),
                                              child: EpisodeDisplayWidget(
                                                context: context,
                                                posterUrl: _lhi.podcastArtwork,
                                                episodeUploadDate:
                                                    DateFormat('yMMMd').format(
                                                          DateTime.parse(
                                                              _lhi.listenedOn),
                                                        ) +
                                                        ', ' +
                                                        DateFormat('hh:mm aa')
                                                            .format(
                                                          DateTime.parse(
                                                              _lhi.listenedOn),
                                                        ),
                                                episodeTitle: _lhi.name,
                                                episodeDuration: Duration(
                                                      seconds: int.parse(
                                                          _lhi.duration),
                                                    ).inMinutes.toString() +
                                                    " Mins",
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 22.0),
                                            child: Divider(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.2),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MiniPlayer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
