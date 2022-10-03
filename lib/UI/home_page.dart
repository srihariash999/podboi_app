import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/home_screen_controller.dart';
import 'package:podboi/Controllers/profile_screen_controller.dart';
import 'package:podboi/Services/database/database.dart';
// import 'package:podboi/Shared/episode_display_widget.dart';
import 'package:podboi/Shared/podcast_display_widget.dart';
import 'package:podboi/UI/podcast_page.dart';
import 'package:podboi/UI/profile_screen.dart';
import 'package:podboi/UI/search_page.dart';
import 'package:podcast_search/podcast_search.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.ref}) : super(key: key);
  final WidgetRef ref;

  Future<void> _refresh() async {
    ref.read(homeScreenController.notifier).getTopPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: buildTopUi(context),
              ),
              SliverToBoxAdapter(
                child: buildSearchRow(context),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    bottom: 8.0,
                    top: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Discover",
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        "Top podcasts today on Podboi today",
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              ),
              buildDiscoverPodcastsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildSearchRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 18.0,
        bottom: 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            child: Theme(
              data: ThemeData(
                primaryColor: Theme.of(context).primaryColor.withOpacity(0.20),
              ),
              child: TextField(
                readOnly: true,
                cursorColor: Colors.black.withOpacity(0.30),
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    LineIcons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintText: "  Search",
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  fillColor: Theme.of(context).highlightColor.withOpacity(0.5),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDiscoverPodcastsRow(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<Item> _topPodcasts = ref.watch(
        homeScreenController.select((value) => value.topPodcasts),
      );
      bool _isLoading = ref.watch(homeScreenController.select((value) => value.isLoading));
      return _isLoading
          ? SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  strokeWidth: 1.0,
                ),
              ),
            )
          : _topPodcasts.length == 0
              ? Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.50,
                      alignment: Alignment.center,
                      child: Text(
                        " No Podcasts to show",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                  ],
                )
              : SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150.0,
                    mainAxisExtent: 160.0,
                  ),

                  delegate: SliverChildBuilderDelegate(
                    ((context, index) {
                      Item _item = _topPodcasts[index];
                      SubscriptionData _podcast = SubscriptionData(
                        id: 0,
                        podcastId: _item.collectionId,
                        podcastName: _item.collectionName ?? "",
                        feedUrl: _item.feedUrl ?? "",
                        artworkUrl: _item.bestArtworkUrl ?? "",
                        dateAdded: DateTime.now(),
                        releaseDate: _item.releaseDate,
                        genre: _item.genre?.map((e) => "${e.name}, ").toList().toString(),
                        country: _item.country,
                        lastEpisodeDate: null,
                        trackCount: _item.trackCount,
                        contentAdvisory: _item.contentAdvisoryRating,
                      );
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                final tween = Tween(begin: begin, end: end);
                                final curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: curve,
                                );

                                return SlideTransition(
                                  position: tween.animate(curvedAnimation),
                                  child: child,
                                );
                              },
                              pageBuilder: (_, __, ___) => PodcastPage(
                                subscription: _podcast,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'logo${_item.collectionId}',
                          child: PodcastDisplayWidget(
                            name: _item.collectionName ?? 'N/A',
                            posterUrl: _item.bestArtworkUrl ?? '',
                            context: context,
                          ),
                        ),
                      );
                    }),
                    childCount: _topPodcasts.length,
                  ),
                  // physics: BouncingScrollPhysics(),
                );
    });
  }

  Padding buildTopUi(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          Consumer(builder: (context, ref, child) {
            String _name = ref.watch(
              profileController.select((value) => value.userName),
            );
            String _avatar = ref.watch(profileController.select((value) => value.userAvatar));
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hi $_name",
                  style: TextStyle(
                    // fontFamily: 'Segoe',
                    fontSize: 26.0,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end);
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: curve,
                            );

                            return SlideTransition(
                              position: tween.animate(curvedAnimation),
                              child: child,
                            );
                          },
                          pageBuilder: (_, __, ___) => ProfileScreen()),
                    );
                  },
                  child: Container(
                    height: 60.0,
                    width: 55.0,
                    child: Icon(
                      _avatar == 'user'
                          ? LineIcons.user
                          : _avatar == 'userNinja'
                              ? LineIcons.userNinja
                              : LineIcons.userAstronaut,
                      size: 38.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            );
          }),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Text(
                "Search for podcasts that you like",
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
