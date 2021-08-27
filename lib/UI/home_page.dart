import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/home_screen_controller.dart';
// import 'package:podboi/Shared/episode_display_widget.dart';
import 'package:podboi/Shared/podcast_display_widget.dart';
import 'package:podboi/UI/podcast_page.dart';
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            children: [
              buildTopUi(),
              buildSearchRow(context),
              buildDiscoverPodcastsRow(context),
              buildNewEpisodes(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildNewEpisodes() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Episodes",
            style: TextStyle(
              fontFamily: 'Segoe',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                ' No new episodes to show',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Segoe',
                ),
              ),
            ),
            // child: Column(
            //   children: [
            //     EpisodeDisplayWidget(
            //       posterUrl:
            //           "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/99%25_Invisible_logo.jpg/1200px-99%25_Invisible_logo.jpg",
            //       episodeTitle: "454- War,Famine,Pestilence, and Design",
            //       episodeDuration: "31m",
            //       episodeUploadDate: "Yesterday",
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //       child: Divider(
            //         color: Colors.black.withOpacity(0.20),
            //       ),
            //     ),
            //     EpisodeDisplayWidget(
            //       posterUrl:
            //           "https://upload.wikimedia.org/wikipedia/en/e/e1/No_Such_Thing_As_A_Fish_logo.jpg",
            //       episodeTitle:
            //           "No Such Thing As Crossing the Futility Boundary",
            //       episodeDuration: "51m",
            //       episodeUploadDate: "Friday",
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //       child: Divider(
            //         color: Colors.black.withOpacity(0.20),
            //       ),
            //     ),
            //     EpisodeDisplayWidget(
            //       posterUrl:
            //           "https://megaphone.imgix.net/podcasts/9a4c2c2a-3e8b-11e8-bd53-9b1115bac0fa/image/uploads_2F1525125320167-fd4zi01j82i-e7a9a485ccc4505ac3ddaacdb5fbfd57_2Fdecoder-ring-3000px.jpg?w=525&h=525",
            //       episodeTitle: "Selling Out",
            //       episodeDuration: "49m",
            //       episodeUploadDate: "Friday",
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //       child: Divider(
            //         color: Colors.black.withOpacity(0.20),
            //       ),
            //     ),
            //     EpisodeDisplayWidget(
            //       posterUrl:
            //           "https://is4-ssl.mzstatic.com/image/thumb/Podcasts125/v4/2e/45/35/2e4535eb-6609-0b06-c703-69b2420b433d/mza_11307628467914885774.png/1200x1200bb.jpg",
            //       episodeTitle: "Your Dinosaur Questions Answered",
            //       episodeDuration: "1h",
            //       episodeUploadDate: "21 July",
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //       child: Divider(
            //         color: Colors.black.withOpacity(0.20),
            //       ),
            //     ),
            //     EpisodeDisplayWidget(
            //       posterUrl:
            //           "https://images.squarespace-cdn.com/content/v1/53bc57f0e4b00052ff4d7ccd/1479474490617-GFZQ09UDJYDS482NVHLJ/lore-logo-light.png?format=1500w",
            //       episodeTitle: "Epsiode 175: Head Case ",
            //       episodeDuration: "39m",
            //       episodeUploadDate: "19 July",
            //     ),
            //   ],
            // ),
          ),
        ],
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
            width: MediaQuery.of(context).size.width * 0.85,
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.black.withOpacity(0.30),
              ),
              child: TextField(
                readOnly: true,
                cursorColor: Colors.black.withOpacity(0.30),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.60),
                ),
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    LineIcons.search,
                    color: Colors.black.withOpacity(0.40),
                  ),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintText: "  Search",
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.30),
                  ),
                  fillColor: Colors.black.withOpacity(0.05),
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

  Padding buildDiscoverPodcastsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 18.0,
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
              color: Colors.black,
            ),
          ),
          Text(
            "Top podcasts today on Podboi in India",
            style: TextStyle(
                fontFamily: 'Segoe',
                fontSize: 14.0,
                fontWeight: FontWeight.w200,
                color: Colors.black.withOpacity(0.50)),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
              height: 160.0,
              child: Consumer(builder: (context, ref, child) {
                List<Item> _topPodcasts = ref.watch(
                  homeScreenController.select((value) => value.topPodcasts),
                );
                return _topPodcasts.length == 0
                    ? Container(
                        alignment: Alignment.center,
                        child: Text(
                          " No Podcasts to show",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6),
                            fontFamily: 'Segoe',
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: _topPodcasts.length,
                        itemBuilder: (context, index) {
                          Item _item = _topPodcasts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                                    podcast: _item,
                                  ),
                                ),
                              );
                            },
                            child: PodcastDisplayWidget(
                              name: _item.collectionName ?? 'N/A',
                              posterUrl: _item.bestArtworkUrl ?? '',
                            ),
                          );
                        },
                      );
              })),
        ],
      ),
    );
  }

  Padding buildTopUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Consumer(builder: (context, ref, child) {
                String _name = ref.watch(
                    homeScreenController.select((value) => value.userName));
                return Text(
                  "Hi $_name",
                  style: TextStyle(
                    // fontFamily: 'Segoe',
                    fontSize: 26.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),
              Container(
                height: 60.0,
                width: 55.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Image.network(
                  "https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Text(
                "Search for podcasts that interest you",
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 16.0,
                  color: Colors.black.withOpacity(0.50),
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
