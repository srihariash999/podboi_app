import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/history_controller.dart';
import 'package:podboi/Controllers/podcast_page_controller.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Helpers/helpers.dart';

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

  double _computePlayingDuration(EpisodeData episodeData) {
    if (episodeData.playedDuration == null ||
        episodeData.duration == null ||
        episodeData.duration == 0) return 0.0;

    return (episodeData.playedDuration! / episodeData.duration!).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final playedDuration = _computePlayingDuration(_episodeData);
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              .withOpacityValue(0.8),
                                          fontFamily: 'Segoe',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _ref
                                              .read(podcastPageViewController(
                                                      _podcast)
                                                  .notifier)
                                              .markEpisodeAsPlayed(
                                                  _episodeData);
                                        },
                                        icon: Icon(Icons.check_circle),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {
                                          _ref
                                              .read(audioController.notifier)
                                              .requestAddingToQueue(
                                                Song(
                                                  url: _episodeData.contentUrl!,
                                                  icon: _podcast.artworkUrl,
                                                  name: _episodeData.title,
                                                  duration:
                                                      _episodeData.duration ??
                                                          0,
                                                  artist:
                                                      "${_episodeData.author}",
                                                  album: _podcast.podcastName,
                                                  episodeData: _episodeData,
                                                ),
                                              );
                                        },
                                        icon: Icon(Icons.playlist_add),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Html(
                                data: _episodeData.description,
                                onLinkTap: (url, _, __) {
                                  if (url != null) {
                                    Helpers.launchUrl(url);
                                  }
                                },
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
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Slidable(
          key: ValueKey(_episodeData.contentUrl),
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  _ref.read(audioController.notifier).requestAddingToQueue(
                        Song(
                          url: _episodeData.contentUrl!,
                          icon: _podcast.artworkUrl,
                          name: _episodeData.title,
                          duration: _episodeData.duration ?? 0,
                          artist: "${_episodeData.author}",
                          album: _podcast.podcastName,
                          episodeData: _episodeData,
                        ),
                      );
                },
                backgroundColor: Color(0xFF0392CF),
                foregroundColor: Colors.white,
                icon: Icons.playlist_add,
                label: 'Up Next',
              ),
            ],
          ),
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
                                .withOpacityValue(0.50),
                          ),
                        ),
                        if (_episodeData.publicationDate != null)
                          Text(
                            DateFormat('yMMMd').format(
                              _episodeData.publicationDate!.toLocal(),
                            ),
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacityValue(0.40),
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
                                .withOpacityValue(0.40),
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
                                .withOpacityValue(0.50),
                          ),
                        ),
                        Text(
                          "${Helpers.formatDurationToMinutes(Duration(seconds: _episodeData.duration ?? 0))}",
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacityValue(0.40),
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
                        //     color: Theme.of(context).colorScheme.secondary.withOpacityValue(0.40),
                        //     fontFamily: 'Segoe',
                        //     fontWeight: FontWeight.w800,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: CachedNetworkImage(
                        imageUrl: _episodeData.imageUrl ?? _podcast.artworkUrl,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          height: 42.0,
                          width: 42.0,
                          child: Icon(Icons.error, color: Colors.grey),
                        ),
                        height: 42.0,
                        width: 42.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          _episodeData.title,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          if (playedDuration > 0.0)
                            CircularProgressIndicator(
                              value: playedDuration,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacityValue(0.70),
                              ),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacityValue(0.2),
                              strokeWidth: 2.0,
                            ),
                          SizedBox(
                            width: 39.0,
                            height: 36.0,
                            child: InkWell(
                              onTap: () async {
                                _ref
                                    .read(audioController.notifier)
                                    .requestPlayingSong(
                                      Song(
                                        url: _episodeData.contentUrl!,
                                        icon: _episodeData.imageUrl ??
                                            _podcast.artworkUrl,
                                        name: _episodeData.title,
                                        duration: _episodeData.duration ?? 0,
                                        artist: "${_episodeData.author}",
                                        album: _podcast.podcastName,
                                        episodeData: _episodeData,
                                      ),
                                    );

                                _ref
                                    .read(historyController.notifier)
                                    .saveToHistoryAction(
                                      data: ListeningHistoryData(
                                        listenedOn: DateTime.now().toString(),
                                        episodeData: _episodeData,
                                      ),
                                    );
                              },
                              child: Icon(
                                (playedDuration > 0.99)
                                    ? FeatherIcons.check
                                    : FeatherIcons.play,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
