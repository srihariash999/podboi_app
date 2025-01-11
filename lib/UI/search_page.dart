import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/search_controller.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/UI/Common/podboi_loader.dart';
import 'package:podboi/UI/podcast_page.dart';
import 'package:podcast_search/podcast_search.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search for a Podcast';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Theme.of(context).colorScheme.secondary,
      appBarTheme: AppBarTheme(
        // backgroundColor: Theme.of(context).backgroundColor,

        backgroundColor: Theme.of(context).highlightColor.withOpacity(0.4),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.7),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 16.0,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          fontFamily: 'Segoe',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        hintStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
          fontFamily: 'Segoe',
        ),
        // fillColor: Theme.of(context).highlightColor.withOpacity(0.4),
        // filled: true,
        focusColor: Theme.of(context).colorScheme.secondary.withOpacity(0.30),
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
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Consumer(builder: (context, ref, child) {
        var _viewController = ref.watch(
          searchScreenController,
        );
        if (query.length > 1) {
          ref.read(searchScreenController.notifier).getsearchResults(query);
        }
        return _viewController.isLoading
            ? Container(
                margin: const EdgeInsets.only(top: 10.0),
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                child: PodboiLoader(),
                //  CircularProgressIndicator(
                //   strokeWidth: 1.0,
                //   color: Theme.of(context).highlightColor,
                // ),
              )
            : _viewController.searchResults.length == 0
                ? Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    color: Theme.of(context).colorScheme.primary,
                    alignment: Alignment.bottomCenter,
                    child: Text(" Search for a podcast",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  )
                : Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: ListView.builder(
                        itemCount: _viewController.searchResults.length,
                        itemBuilder: (context, index) {
                          Item result = _viewController.searchResults[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    String genreString = "";
                                    if (result.genre != null) {
                                      for (var e in result.genre!) {
                                        genreString += "${e.name}, ";
                                      }
                                    }
                                    if (genreString.length > 2) {
                                      genreString = genreString.substring(
                                          0, genreString.length - 2);
                                    }
                                    return PodcastPage(
                                      subscription: SubscriptionData(
                                        id: 0,
                                        podcastName:
                                            result.collectionName ?? "N/A",
                                        feedUrl: result.feedUrl ?? "",
                                        artworkUrl: result.bestArtworkUrl ?? "",
                                        dateAdded: DateTime.now(),
                                        podcastId: result.collectionId,
                                        lastEpisodeDate: null,
                                        trackCount: result.trackCount,
                                        releaseDate: result.releaseDate,
                                        country: result.country,
                                        genre: genreString,
                                        contentAdvisory:
                                            result.contentAdvisoryRating,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'logo${result.collectionId}',
                              child: Container(
                                height: 100.0,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Container(
                                      height: 80.0,
                                      width: 80.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        result.bestArtworkUrl ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    result.collectionName ==
                                                            null
                                                        ? ''
                                                        : result
                                                            .collectionName!,
                                                    //         .length >
                                                    //     40
                                                    // ? result.collectionName!
                                                    //         .substring(
                                                    //             0, 37) +
                                                    //     '...'
                                                    // : result.collectionName!,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Segoe',
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  result.releaseDate == null
                                                      ? ""
                                                      : DateFormat('yMMMd')
                                                          .format(result
                                                              .releaseDate!),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w200,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                        .withOpacity(0.50),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Text(
                                                    "${result.trackCount ?? 'N/A'} Episodes",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Segoe',
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                          .withOpacity(0.50),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }));
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.primary,
      );
}
