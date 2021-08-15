import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/search_controller.dart';
import 'package:podboi/UI/podcast_page.dart';
import 'package:podcast_search/podcast_search.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search for a Podcast';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.7),
        ),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 16.0,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.8),
          fontFamily: 'Segoe',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        hintStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.4),
          fontFamily: 'Segoe',
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
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var _viewController = ref.watch(
        searchScreenController,
      );
      if (query.length > 1) {
        ref.read(searchScreenController.notifier).getsearchResults(query);
      }
      return _viewController.isLoading
          ? Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                color: Colors.black,
              ),
            )
          : _viewController.searchResults.length == 0
              ? Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Text(
                    " Search for a podcast",
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: _viewController.searchResults.length,
                      itemBuilder: (context, index) {
                        Item result = _viewController.searchResults[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
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
                                  podcast: result,
                                ),
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
                                      borderRadius: BorderRadius.circular(12.0),
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
                                                  result.collectionName == null
                                                      ? ''
                                                      : result.collectionName!,
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
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
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
                                                MainAxisAlignment.spaceBetween,
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
                                                  color: Colors.black
                                                      .withOpacity(0.50),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: Text(
                                                  "${result.trackCount ?? 'N/A'} Episodes",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w200,
                                                    color: Colors.black
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
    });
  }

  

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Colors.white,
      );
}
