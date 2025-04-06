import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/history_controller.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/Shared/episode_display_widget.dart';
import 'package:podboi/UI/podboi_loader.dart';
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

                          List<ListeningHistoryData> _list = ref.watch(
                            historyController
                                .select((value) => value.historyList),
                          );
                          return _loading
                              ? Container(
                                  alignment: Alignment.center,
                                  child: PodboiLoader(),
                                )
                              : _list.length == 0
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        " No history found",
                                        style: TextStyle(
                                          fontFamily: 'Segoe',
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacityValue(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: _refresh,
                                      child: ListView.separated(
                                        itemCount: _list.length,
                                        itemBuilder: (context, index) {
                                          ListeningHistoryData _lhi =
                                              _list[index];
                                          return GestureDetector(
                                            onTap: () async {
                                              ref
                                                  .read(
                                                      audioController.notifier)
                                                  .requestPlayingSong(
                                                    Song(
                                                      url: _lhi.episodeData
                                                              .contentUrl ??
                                                          '',
                                                      icon: _lhi.episodeData
                                                              .imageUrl ??
                                                          '',
                                                      name: _lhi
                                                          .episodeData.title,
                                                      duration: int.parse(_lhi
                                                              .episodeData
                                                              .duration
                                                              ?.toString() ??
                                                          "0"),
                                                      artist: _lhi.episodeData
                                                              .author ??
                                                          '',
                                                      album: _lhi.episodeData
                                                              .podcastName ??
                                                          '',
                                                      episodeData:
                                                          _lhi.episodeData,
                                                    ),
                                                  );
                                              ref
                                                  .read(historyController
                                                      .notifier)
                                                  .saveToHistoryAction(
                                                    data: ListeningHistoryData(
                                                      listenedOn: DateTime.now()
                                                          .toString(),
                                                      episodeData:
                                                          _lhi.episodeData,
                                                    ),
                                                  );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                              ),
                                              child: EpisodeDisplayWidget(
                                                context: context,
                                                posterUrl:
                                                    _lhi.episodeData.imageUrl ??
                                                        "",
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
                                                episodeTitle:
                                                    _lhi.episodeData.title,
                                                episodeDuration: Duration(
                                                      seconds: _lhi.episodeData
                                                              .duration ??
                                                          0,
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
                                                  .withOpacityValue(0.2),
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
