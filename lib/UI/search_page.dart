import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/search_controller.dart';
import 'package:podcast_search/podcast_search.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
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
      return _viewController.isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                color: Colors.black,
              ),
            )
          : _viewController.searchResults.length == 0
              ? Container(
                  alignment: Alignment.center,
                  child: Text(
                    " Search for a podcast",
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: _viewController.searchResults.map((Item result) {
                      return Container(
                        height: 100.0,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Row(
                          children: [
                            Container(
                              height: 50.0,
                              width: 50.0,
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
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            result.collectionName == null
                                                ? ''
                                                : result.collectionName!
                                                            .length >
                                                        30
                                                    ? result.collectionName!
                                                            .substring(0, 27) +
                                                        '...'
                                                    : result.collectionName!,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Segoe',
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6.0,
                                    ),
                                    Text(
                                      result.releaseDate == null
                                          ? ""
                                          : DateFormat('yMMMd')
                                              .format(result.releaseDate!),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black.withOpacity(0.50),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
