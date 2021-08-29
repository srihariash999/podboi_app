import 'package:expandable/expandable.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podcast_search/podcast_search.dart';

class DetailedEpsiodeViewWidget extends StatelessWidget {
  const DetailedEpsiodeViewWidget({
    Key? key,
    required Episode episode,
    required Item podcast,
    required WidgetRef ref,
  })  : _episode = episode,
        _podcast = podcast,
        _ref = ref,
        super(key: key);

  final Episode _episode;
  final Item _podcast;
  final WidgetRef _ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _episode.season != null
                      ? "Season ${_episode.season}" +
                          "  Episode ${_episode.episode ?? ''}"
                      : '' + "Episode ${_episode.episode ?? ''}",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).accentColor.withOpacity(0.40),
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  DateFormat('yMMMd').format(_episode.publicationDate!),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).accentColor.withOpacity(0.40),
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    _episode.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).accentColor.withOpacity(0.8),
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    print("episode link: ${_episode.contentUrl}");
                    await _ref.read(audioController.notifier).playAction(
                          Song(
                              url: _episode.contentUrl!,
                              icon: _podcast.bestArtworkUrl!,
                              name: _episode.title,
                              duration: _episode.duration,
                              artist: "${_episode.author}",
                              album: "${_podcast.collectionName}"),
                        );
                  },
                  icon: Icon(
                    FeatherIcons.play,
                    color: Theme.of(context).accentColor,
                  ))
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white38,
            ),
            alignment: Alignment.center,
            child: ExpandablePanel(
              theme:
                  ExpandableThemeData(iconColor: Theme.of(context).accentColor),
              header: Text(
                " Episode ${_episode.episode ?? ''} Description ",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).accentColor.withOpacity(0.8),
                  fontFamily: 'Segoe',
                  fontWeight: FontWeight.w400,
                ),
              ),
              collapsed: Container(),
              expanded: Html(
                data: _episode.description,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_episode.duration?.inMinutes} minutes",
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Theme.of(context).accentColor.withOpacity(0.40),
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  _episode.author != null
                      ? _episode.author!.length > 35
                          ? _episode.author!.substring(0, 32) + '....'
                          : _episode.author!
                      : ' -- ',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Theme.of(context).accentColor.withOpacity(0.40),
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
