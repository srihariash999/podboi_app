import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Services/database/subscription_box_controller.dart';

final subscriptionsPageViewController =
    StateNotifierProvider<SubscriptionsPageNotifier, SubscriptionState>((ref) {
  return SubscriptionsPageNotifier();
});

class SubscriptionsPageNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionsPageNotifier() : super(SubscriptionState.initial()) {
    loadSubscriptions();
  }

  Future<void> loadSubscriptions() async {
    state = state.copyWith(isLoading: true);
    List<SubscriptionData> _subs =
        await SubscriptionBoxController.getSubscriptions();

    state = state.copyWith(subscriptionsList: _subs, isLoading: false);
  }
}

class SubscriptionState {
  final List<SubscriptionData> subscriptionsList;
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
    List<SubscriptionData>? subscriptionsList,
    bool? isLoading,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscriptionsList: subscriptionsList ?? this.subscriptionsList,
    );
  }
}
