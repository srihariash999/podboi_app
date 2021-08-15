import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:podboi/Services/database/subscriptions.dart';

final subscriptionsPageViewController =
    StateNotifierProvider<SubscriptionsPageNotifier, SubscriptionState>((ref) {
  return SubscriptionsPageNotifier();
});

Box _subBox = Hive.box('subscriptionsBox');

class SubscriptionsPageNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionsPageNotifier() : super(SubscriptionState.initial()) {
    _initLoadSubs();
  }

  Future<void> _initLoadSubs() async {
    state = state.copyWith(isLoading: true);
    List<Subscription> _subs = [];
    for (var i in _subBox.values) {
      _subs.add(i as Subscription);
    }
    state = state.copyWith(subscriptionsList: _subs, isLoading: false);
    Box _subsBox = Hive.box('subscriptionsBox');
    _subsBox.watch().listen((event) async {
      print(" new event occured");
      List<Subscription> _subs = [];
      for (var i in _subBox.values) {
        _subs.add(i as Subscription);
      }
      state = state.copyWith(subscriptionsList: _subs, isLoading: false);

      print("reached end of event callback");
    });
  }

  Future<void> loadSubscriptions() async {
    state = state.copyWith(isLoading: true);
    List<Subscription> _subs = [];
    for (var i in _subBox.values) {
      _subs.add(i as Subscription);
    }
    state = state.copyWith(subscriptionsList: _subs, isLoading: false);
  }
}

class SubscriptionState {
  final List<Subscription> subscriptionsList;
  final bool isLoading;
  SubscriptionState({
    required this.isLoading,
    required this.subscriptionsList,
  });
  factory SubscriptionState.initial() {
    return SubscriptionState(
      isLoading: true,
      subscriptionsList: [],
    );
  }
  SubscriptionState copyWith({
    List<Subscription>? subscriptionsList,
    bool? isLoading,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscriptionsList: subscriptionsList ?? this.subscriptionsList,
    );
  }
}
