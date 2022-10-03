import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/audio_controller.dart';
// import 'package:podboi/Controllers/history_controller.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Services/database/database.dart';
import 'package:podcast_search/podcast_search.dart';

class DetailedEpsiodeViewWidget extends StatelessWidget {
  const DetailedEpsiodeViewWidget({
    Key? key,
    required Episode episode,
    required SubscriptionData podcast,
    required WidgetRef ref,
  })  : _episode = episode,
        _podcast = podcast,
        _ref = ref,
        super(key: key);

  final Episode _episode;
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
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 12.0),
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
                                data: _episode.description,
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
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
                        ),
                      ),
                      Text(
                        DateFormat('yMMMd').format(_episode.publicationDate!),
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.40),
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Text(
                        (_episode.season != null ? "S-${_episode.season}" : "") +
                            (_episode.episode != null ? "  E-${_episode.episode}" : ""),
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.40),
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
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
                        ),
                      ),
                      Text(
                        "${_episode.duration?.inMinutes} minutes",
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.40),
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      // Text(
                      //   _episode.author != null
                      //       ? _episode.author!.length > 35
                      //           ? _episode.author!.substring(0, 32) + '....'
                      //           : _episode.author!
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
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
                    child: Text(
                      _episode.title,
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
                    print("episode link: ${_episode.contentUrl}");
                    _ref.read(audioController.notifier).requestPlayingSong(
                          Song(
                            url: _episode.contentUrl!,
                            icon: _podcast.artworkUrl,
                            name: _episode.title,
                            duration: _episode.duration,
                            artist: "${_episode.author}",
                            album: _podcast.podcastName,
                          ),
                        );

                    //TODO: handle this logic after new LHI feature is set.
                    // _ref.read(historyController.notifier).saveToHistoryAction(
                    //     url: _episode.contentUrl!.toString(),
                    //     name: _episode.title,
                    //     artist: "${_episode.author}",
                    //     icon: _podcast.bestArtworkUrl!,
                    //     album: "${_podcast.collectionName}",
                    //     duration: _episode.duration!.inSeconds.toString(),
                    //     listenedOn: DateTime.now().toString(),
                    //     podcastArtWork: _podcast.bestArtworkUrl!,
                    //     podcastName: "${_podcast.collectionName}");
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
