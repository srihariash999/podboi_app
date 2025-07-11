import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/podcast_page_controller.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/Shared/detailed_episode_widget.dart';
import 'package:podboi/UI/player/mini_player.dart';
import 'package:podboi/UI/podboi_loader.dart';

class PodcastPage extends StatelessWidget {
  final SubscriptionData subscription;
  PodcastPage({Key? key, required this.subscription}) : super(key: key);

  final TextEditingController episodeSearchController = TextEditingController();

  void onTapThreeDot(BuildContext context, WidgetRef ref, bool episodesSort) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .read(podcastPageViewController(
                        subscription,
                      ).notifier)
                      .toggleEpisodesSort();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      episodesSort
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacityValue(0.70),
                    ),
                    Text(
                      " Sort Episodes Newest to Oldest",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacityValue(0.70),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Icon(Icons.arrow_downward),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref
                      .read(podcastPageViewController(
                        subscription,
                      ).notifier)
                      .toggleEpisodesSort();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      episodesSort
                          ? Icons.check_box_outline_blank
                          : Icons.check_box,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacityValue(0.70),
                    ),
                    Text(
                      "Sort Episodes Oldest to Newest",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacityValue(0.70),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Icon(Icons.arrow_upward),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, b) {
                return [
                  // Container(
                  //   color: Colors.yellowAccent,
                  //   height: 200,
                  //   width: double.infinity,
                  // ),
                  SliverAppBar(
                    leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    titleSpacing: 0.0,
                    actions: [
                      Consumer(
                        builder: (context, ref, child) {
                          // True --> new to old
                          // False --> old to new
                          bool _episodesSort = ref
                              .watch(
                                podcastPageViewController(subscription),
                              )
                              .epSortingIncr;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: InkWell(
                              onTap: () {
                                onTapThreeDot(context, ref, _episodesSort);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 6.0),
                                child: Icon(
                                  Icons.more_vert,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    centerTitle: false,
                    expandedHeight: 32.0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0.0,
                    floating: true,
                    snap: true,
                    stretch: true,
                    title: Consumer(
                      builder: (context, ref, child) {
                        var _viewController = ref.watch(
                          podcastPageViewController(subscription),
                        );

                        if (_viewController.isLoading) {
                          return Container();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 38.0,
                              width: MediaQuery.of(context).size.width * 0.76,
                              child: TextField(
                                controller: episodeSearchController,
                                onChanged: (String s) {
                                  ref
                                      .read(podcastPageViewController(
                                              subscription)
                                          .notifier)
                                      .filterEpisodesWithQuery(s);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    LineIcons.search,
                                    size: 20.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacityValue(0.7),
                                  ),
                                  suffixIcon: episodeSearchController
                                          .text.isEmpty
                                      ? null
                                      : InkWell(
                                          onTap: () {
                                            episodeSearchController.clear();
                                            ref
                                                .read(podcastPageViewController(
                                                        subscription)
                                                    .notifier)
                                                .filterEpisodesWithQuery('');
                                          },
                                          child: Icon(
                                            LineIcons.timesCircle,
                                            size: 20.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacityValue(0.7),
                                          ),
                                        ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 16.0),
                                  hintText: "Search Episodes",
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  fillColor: Theme.of(context)
                                      .highlightColor
                                      .withOpacityValue(0.5),
                                  filled: true,
                                  focusColor:
                                      Colors.black.withOpacityValue(0.30),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    // flexibleSpace: FlexibleSpaceBar(
                    //   title:
                    // ),
                  ),
                ];
              },
              body: Column(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        var isLoading = ref.watch(
                          podcastPageViewController(subscription)
                              .select((value) => value.isLoading),
                        );

                        var eps = ref.watch(
                          podcastPageViewController(subscription)
                              .select((value) => value.podcastEpisodes),
                        );

                        Future<void> refresh() async {
                          ref
                              .read(podcastPageViewController(subscription)
                                  .notifier)
                              .loadPodcastEpisodes(subscription.feedUrl,
                                  subscription.podcastId ?? subscription.id);
                        }

                        return isLoading
                            ? Container(
                                alignment: Alignment.center,
                                child: PodboiLoader(),
                              )
                            : RefreshIndicator(
                                onRefresh: refresh,
                                color: Theme.of(context).colorScheme.secondary,
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  separatorBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacityValue(0.2),
                                      ),
                                    );
                                  },
                                  itemCount: eps.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return EpisodeDetailComponent(
                                        subscription: subscription,
                                      );
                                    }
                                    EpisodeData _episode = eps[index - 1];
                                    return DetailedEpsiodeViewWidget(
                                      episodeData: _episode,
                                      ref: ref,
                                      podcast: subscription,
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
          ),
        ),
      ),
    );
  }
}

class EpisodeDetailComponent extends StatefulWidget {
  const EpisodeDetailComponent({super.key, required this.subscription});
  final SubscriptionData subscription;
  @override
  State<EpisodeDetailComponent> createState() => _EpisodeDetailComponentState();
}

class _EpisodeDetailComponentState extends State<EpisodeDetailComponent> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTapped = !isTapped;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: AnimatedContainer(
                    height: isTapped ? 110.0 : 100.0,
                    width: isTapped ? 110 : 100.0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        width: 100.0,
                        height: 100.0,
                        widget.subscription.artworkUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.60,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.subscription.podcastName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacityValue(0.70),
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
                            if (widget.subscription.releaseDate != null)
                              Text(
                                DateFormat('yMMMd')
                                    .format(widget.subscription.releaseDate!),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacityValue(0.50),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (widget.subscription.releaseDate != null)
                              SizedBox(
                                width: 18.0,
                              ),
                            Text(
                              widget.subscription.country ?? '',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacityValue(0.50),
                                // fontFamily: 'Segoe',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          widget.subscription.genre ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacityValue(0.70),
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.60,
                        //   child: Wrap(
                        //     children: subscription.genre!.map(
                        //       (i) {
                        //         int x = subscription.genre!.indexOf(i);
                        //         int l = subscription.genre!.length;
                        //         String gName = i.name;
                        //         if (x < l - 1) gName += " , ";
                        //         return Text(
                        //           gName,
                        //           style: TextStyle(
                        //             fontSize: 12.0,
                        //             color:
                        //                 Theme.of(context).colorScheme.secondary.withOpacityValue(0.70),
                        //             fontFamily: 'Segoe',
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         );
                        //       },
                        //     ).toList(),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
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
                    podcastPageViewController(widget.subscription)
                        .select((value) => value.isSubscribed),
                  );

                  bool _isSubscribeButtonLoading = ref.watch(
                    podcastPageViewController(widget.subscription)
                        .select((value) => value.isSubscribeButtonLoading),
                  );

                  if (_isSubscribeButtonLoading)
                    return Container(
                      width: 124.0,
                      decoration: BoxDecoration(
                        color: Colors.yellow.withOpacityValue(0.3),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 19.0),
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          backgroundColor: Theme.of(context).highlightColor,
                          minHeight: 1,
                        ),
                      ),
                    );

                  if (_isSubbed)
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(podcastPageViewController(widget.subscription)
                                .notifier)
                            .removeFromSubscriptionsAction(
                                widget.subscription, ref);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacityValue(0.2),
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
                    );
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(podcastPageViewController(widget.subscription)
                              .notifier)
                          .saveToSubscriptionsAction(widget.subscription, ref);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacityValue(0.2),
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
                          Icon(FeatherIcons.plusCircle, color: Colors.orange),
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
                            .withOpacityValue(0.50),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${widget.subscription.contentAdvisory ?? ' N.A '}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacityValue(0.80),
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
          if (isTapped)
            Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    String _description = ref.watch(
                        podcastPageViewController(widget.subscription)
                            .select((value) => value.description));
                    bool _isLoading = ref.watch(
                      podcastPageViewController(widget.subscription)
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
              ],
            )
          // InkWell(
          //   onTap: () => onTapAboutPodcast(context),
          //   child: Container(
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(12.0),
          //       // color: Colors.white38,
          //       color:
          //           Theme.of(context).colorScheme.secondary.withOpacityValue(0.05),
          //     ),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Text(
          //             "About Podcast",
          //             style: TextStyle(
          //               fontSize: 18.0,
          //               color: Theme.of(context)
          //                   .colorScheme
          //                   .secondary
          //                   .withOpacityValue(0.6),
          //               fontFamily: 'Segoe',
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //         IconButton(
          //           onPressed: null,
          //           icon: Icon(
          //             Icons.arrow_forward_ios,
          //             color: Theme.of(context).colorScheme.secondary,
          //             size: 16.0,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // ExpandablePanel(
          //   theme: ExpandableThemeData(
          //       iconColor: Theme.of(context).colorScheme.secondary),
          //   header: Padding(
          //     padding: const EdgeInsets.only(top: 8.0),
          //     child: Text(
          //       "About Podcast",
          //       style: TextStyle(
          //         fontSize: 17.0,
          //         color: Theme.of(context)
          //             .colorScheme
          //             .secondary
          //             .withOpacityValue(0.6),
          //         fontFamily: 'Segoe',
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          //   collapsed: Container(),
          //   expanded: Consumer(
          //     builder: (context, ref, child) {
          //       String _description = ref.watch(
          //           podcastPageViewController(podcast)
          //               .select((value) => value.description));
          //       bool _isLoading = ref.watch(
          //         podcastPageViewController(podcast)
          //             .select((value) => value.isLoading),
          //       );
          //       return _isLoading
          //           ? Container(
          //               width: 200.0,
          //               height: 1.0,
          //               child: LinearProgressIndicator(
          //                 color: Theme.of(context).colorScheme.secondary,
          //                 backgroundColor: Theme.of(context).highlightColor,
          //                 minHeight: 1,
          //               ),
          //             )
          //           : Html(
          //               data: _description,
          //             );
          //     },
          //   ),
          // ),
          // ),
          // SizedBox(
          //   height: 12.0,
          // ),
        ],
      ),
    );
  }
}
