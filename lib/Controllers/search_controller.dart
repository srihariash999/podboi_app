import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';

var _search = Search();

final searchScreenController =
    StateNotifierProvider<SearchScreenViewNotifier, SearchState>((ref) {
  return SearchScreenViewNotifier();
});

String _prevQuery = '';
final TextEditingController _searchController = TextEditingController();

class SearchScreenViewNotifier extends StateNotifier<SearchState> {
  SearchScreenViewNotifier() : super(SearchState.initial());

  getsearchResults(String query) async {
    if (query != _prevQuery) {
       state = state.copyWith(isLoading: true);
      _prevQuery = query;
      SearchResult charts = await _search.search(query);
      List<Item> _searchResults = [];
      for (var i in charts.items) {
        _searchResults.add(i);
      }
      state = state.copyWith(searchResults: _searchResults, isLoading: false);
    }
  }
}

class SearchState {
  final List<Item> searchResults;
  final TextEditingController searchController;
  final bool isLoading;
  SearchState(
      {required this.searchResults,
      required this.searchController,
      required this.isLoading});
  factory SearchState.initial() {
    return SearchState(
      searchResults: [],
      searchController: _searchController,
      isLoading: false,
    );
  }
  SearchState copyWith({List<Item>? searchResults, bool? isLoading}) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      searchController: this.searchController,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
