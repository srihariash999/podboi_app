import 'package:expandable/expandable.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/podcast_page_controller.dart';
import 'package:podboi/Shared/detailed_episode_widget.dart';
import 'package:podboi/UI/mini_player.dart';
// import 'package:podboi/misc/database.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastPage extends StatelessWidget {
  final Item podcast;
  PodcastPage({Key? key, required this.podcast}) : super(key: key);

  final TextEditingController episodeSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 18.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    var _viewController = ref.watch(
                      podcastPageViewController(podcast),
                    );
                    if (_viewController.isLoading) {
                      return Container();
                    }
                    return Expanded(
                      child: TextField(
                        controller: episodeSearchController,
                        onChanged: (String s) {
                          ref
                              .read(podcastPageViewController(podcast).notifier)
                              .filterEpisodesWithQuery(s);
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            LineIcons.search,
                            size: 20.0,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.7),
                          ),
                          suffix: Padding(
                            padding:
                                const EdgeInsets.only(right: 12.0, top: 2.0),
                            child: GestureDetector(
                              onTap: () {
                                episodeSearchController.clear();
                                ref
                                    .read(podcastPageViewController(podcast)
                                        .notifier)
                                    .filterEpisodesWithQuery('');
                              },
                              child: Icon(
                                LineIcons.timesCircle,
                                size: 20.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.7),
                              ),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                          hintText: "  Search Episodes",
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.7),
                          ),
                          fillColor:
                              Theme.of(context).highlightColor.withOpacity(0.5),
                          filled: true,
                          focusColor: Colors.black.withOpacity(0.30),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Consumer(
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
                            color: Theme.of(context).colorScheme.secondary,
                            strokeWidth: 1,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.2),
                                ),
                              );
                            },
                            itemCount:
                                _viewController.podcastEpisodes.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return buildTopUI(context);
                              }
                              Episode _episode =
                                  _viewController.podcastEpisodes[index - 1];
                              return DetailedEpsiodeViewWidget(
                                episode: _episode,
                                ref: ref,
                                podcast: podcast,
                              );
                            },
                          ),
                        );
                },
              ),
            ),
            Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }

  Widget buildTopUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Hero(
                  tag: 'logo${podcast.collectionId}',
                  child: Container(
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
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.60,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      podcast.collectionName ?? 'N/A',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.70),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Column(
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
                            DateFormat('yMMMd').format(podcast.releaseDate!),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.50),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.50),
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.70),
                                  fontFamily: 'Segoe',
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  bool _isSubbed = ref.watch(
                    podcastPageViewController(podcast)
                        .select((value) => value.isSubscribed),
                  );
                  bool _isLoading = ref.watch(
                    podcastPageViewController(podcast)
                        .select((value) => value.isLoading),
                  );
                  return _isLoading
                      ? Container(
                          width: 110.0,
                          height: 1.0,
                          child: LinearProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Theme.of(context).highlightColor,
                            minHeight: 1,
                          ),
                        )
                      : _isSubbed
                          ? GestureDetector(
                              onTap: () {
                                ref
                                    .read(podcastPageViewController(podcast)
                                        .notifier)
                                    .removeFromSubscriptionsAction(podcast);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Subscribed',
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Icon(
                                      FeatherIcons.checkCircle,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                ref
                                    .read(podcastPageViewController(podcast)
                                        .notifier)
                                    .saveToSubscriptionsAction(podcast);
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
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Icon(FeatherIcons.plusCircle,
                                        color: Colors.orange),
                                  ],
                                ),
                              ),
                            );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Content Advisory: ",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.50),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${podcast.contentAdvisoryRating}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.80),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white38,
            ),
            child: ExpandablePanel(
              theme: ExpandableThemeData(
                  iconColor: Theme.of(context).colorScheme.secondary),
              header: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "About Podcast",
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.6),
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              collapsed: Container(),
              expanded: Consumer(
                builder: (context, ref, child) {
                  String _description = ref.watch(
                      podcastPageViewController(podcast)
                          .select((value) => value.description));
                  bool _isLoading = ref.watch(
                    podcastPageViewController(podcast)
                        .select((value) => value.isLoading),
                  );
                  return _isLoading
                      ? Container(
                          width: 200.0,
                          height: 1.0,
                          child: LinearProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Theme.of(context).highlightColor,
                            minHeight: 1,
                          ),
                        )
                      : Html(
                          data: _description,
                        );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 16.0, bottom: 12.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
              height: 4.0,
            ),
          ),
        ],
      ),
    );
  }
}
