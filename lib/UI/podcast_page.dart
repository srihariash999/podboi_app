import 'package:expandable/expandable.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/podcast_page_controller.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastPage extends StatelessWidget {
  final Item podcast;
  const PodcastPage({Key? key, required this.podcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer(
        builder: (context, ref, child) {
          var _viewController = ref.watch(
            podcastPageViewController(podcast),
          );
          Future<void> refresh() async {
            ref
                .read(podcastPageViewController(podcast).notifier)
                .loadPodcastEpisodes(podcast.feedUrl!);
          }

          return _viewController.isLoading
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 1,
                  ),
                )
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        );
                      },
                      itemCount: _viewController.podcastEpisodes.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return buildTopUI(context);
                        } else {
                          Episode _episode =
                              _viewController.podcastEpisodes[index - 1];
                          return EpsiodeViewWidget(episode: _episode);
                        }
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }

  Container buildTopUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 220.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Image.network(
                    podcast.bestArtworkUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        // height: 40.0,
                        width: MediaQuery.of(context).size.width * 0.60,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          podcast.collectionName ?? 'N/A',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black.withOpacity(0.70),
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yMMMd')
                                    .format(podcast.releaseDate!),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 18.0,
                              ),
                              Text(
                                podcast.country ?? '',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black.withOpacity(0.50),
                                  // fontFamily: 'Segoe',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            child: Wrap(
                              children: podcast.genre!.map(
                                (i) {
                                  int x = podcast.genre!.indexOf(i);
                                  int l = podcast.genre!.length;
                                  String gName = i.name;
                                  if (x < l - 1) gName += " , ";
                                  return Text(
                                    gName,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black.withOpacity(0.70),
                                      fontFamily: 'Segoe',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              bool _isSubbed = ref.watch(
                podcastPageViewController(podcast)
                    .select((value) => value.isSubscribed),
              );
              return _isSubbed
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Subscribed',
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Icon(FeatherIcons.checkCircle,
                              color: Colors.green.withOpacity(0.7)),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ref
                            .read(podcastPageViewController(podcast).notifier)
                            .saveToSubscriptions(podcast);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Subscribe',
                              style: TextStyle(
                                fontFamily: 'Segoe',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Icon(FeatherIcons.plusCircle,
                                color: Colors.orange.withOpacity(0.7)),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}

class EpsiodeViewWidget extends StatelessWidget {
  const EpsiodeViewWidget({
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
                      ? "Season ${_episode.season}"
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
        ],
      ),
    );
  }
}
