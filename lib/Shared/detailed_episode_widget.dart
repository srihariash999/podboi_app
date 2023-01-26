import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/history_controller.dart';
// import 'package:podboi/Controllers/history_controller.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Services/database/database.dart';
// import 'package:podcast_search/podcast_search.dart';

class DetailedEpsiodeViewWidget extends StatelessWidget {
  const DetailedEpsiodeViewWidget({
    Key? key,
    required EpisodeData episodeData,
    required SubscriptionData podcast,
    required WidgetRef ref,
  })  : _episodeData = episodeData,
        _podcast = podcast,
        _ref = ref,
        super(key: key);

  final EpisodeData _episodeData;
  final SubscriptionData _podcast;
  final WidgetRef _ref;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * .7,
                child: Column(
                  children: [
                    SizedBox(height: 16.0),
                    Container(
                      height: 5.0,
                      width: 64.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 12.0, top: 12.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Description ",
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.8),
                                      fontFamily: 'Segoe',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Html(
                                data: _episodeData.description,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, right: 4.0),
                        child: Icon(
                          Icons.calendar_month,
                          size: 13.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.50),
                        ),
                      ),
                      Text(
                        DateFormat('yMMMd').format(
                          _episodeData.publicationDate!.toLocal(),
                        ),
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.40),
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Text(
                        (_episodeData.season != null
                                ? "S-${_episodeData.season}"
                                : "") +
                            (_episodeData.episodeNumber != null
                                ? "  E-${_episodeData.episodeNumber}"
                                : ""),
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.40),
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, right: 4.0),
                        child: Icon(
                          Icons.watch_later_outlined,
                          size: 13.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.50),
                        ),
                      ),
                      Text(
                        "${Duration(seconds: _episodeData.duration ?? 0).inMinutes} minutes",
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.40),
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      // Text(
                      //   _episodeData.author != null
                      //       ? _episodeData.author!.length > 35
                      //           ? _episodeData.author!.substring(0, 32) + '....'
                      //           : _episodeData.author!
                      //       : ' -- ',
                      //   style: TextStyle(
                      //     fontSize: 10.0,
                      //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.40),
                      //     fontFamily: 'Segoe',
                      //     fontWeight: FontWeight.w800,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 8.0),
                    child: Text(
                      _episodeData.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    print("episodeData link: ${_episodeData.contentUrl}");
                    _ref.read(audioController.notifier).requestPlayingSong(
                          Song(
                            url: _episodeData.contentUrl!,
                            icon: _podcast.artworkUrl,
                            name: _episodeData.title,
                            duration:
                                Duration(seconds: _episodeData.duration ?? 0),
                            artist: "${_episodeData.author}",
                            album: _podcast.podcastName,
                          ),
                        );

                    _ref.read(historyController.notifier).saveToHistoryAction(
                          url: _episodeData.contentUrl!.toString(),
                          name: _episodeData.title,
                          artist: "${_episodeData.author}",
                          icon: _podcast.artworkUrl,
                          album: "${_podcast.podcastName}",
                          duration:
                              Duration(seconds: _episodeData.duration ?? 0)
                                  .inSeconds
                                  .toString(),
                          listenedOn: DateTime.now().toString(),
                          podcastArtWork: _podcast.artworkUrl,
                          podcastName: "${_podcast.podcastName}",
                        );
                  },
                  icon: Icon(
                    FeatherIcons.play,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
