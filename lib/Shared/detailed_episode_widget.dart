import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:podcast_search/podcast_search.dart';

class DetailedEpsiodeViewWidget extends StatelessWidget {
  const DetailedEpsiodeViewWidget({
    Key? key,
    required Episode episode,
  })  : _episode = episode,
        super(key: key);

  final Episode _episode;

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
                    color: Colors.black.withOpacity(0.40),
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  DateFormat('yMMMd').format(_episode.publicationDate!),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black.withOpacity(0.40),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              _episode.title,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black.withOpacity(0.8),
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.black.withOpacity(0.05),
            ),
            alignment: Alignment.center,
            child: ExpandablePanel(
              header: Text(
                " Episode ${_episode.episode ?? ''} Description ",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black.withOpacity(0.8),
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
                    color: Colors.black.withOpacity(0.40),
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
                    color: Colors.black.withOpacity(0.40),
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
