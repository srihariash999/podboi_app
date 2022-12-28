import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Services/database/database_service.dart';
import '../Services/database/database.dart' as db;

final subscriptionsPageViewController =
    StateNotifierProvider<SubscriptionsPageNotifier, SubscriptionState>((ref) {
  return SubscriptionsPageNotifier(ref);
});

class SubscriptionsPageNotifier extends StateNotifier<SubscriptionState> {
  final StateNotifierProviderRef<SubscriptionsPageNotifier, SubscriptionState> ref;
  SubscriptionsPageNotifier(this.ref) : super(SubscriptionState.initial()) {
    _initLoadSubs();
  }

  Future<void> _initLoadSubs() async {
    state = state.copyWith(isLoading: true);
    List<db.SubscriptionData> savedSubs =
        await ref.watch(databaseServiceProvider).getAllSubscriptions();

    state = state.copyWith(subscriptionsList: savedSubs, isLoading: false);
  }

  Future<void> loadSubscriptions() async {
    state = state.copyWith(isLoading: true);
    List<db.SubscriptionData> _subs =
        await ref.watch(databaseServiceProvider).getAllSubscriptions();

    state = state.copyWith(subscriptionsList: _subs, isLoading: false);
  }
}

class SubscriptionState {
  final List<db.SubscriptionData> subscriptionsList;
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
    List<db.SubscriptionData>? subscriptionsList,
    bool? isLoading,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscriptionsList: subscriptionsList ?? this.subscriptionsList,
    );
  }
}
