import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/subscription_controller.dart';
import 'package:podboi/Services/database/subscriptions.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              var _viewController = ref.watch(subscriptionsPageViewController);
              return _viewController.isLoading
                  ? Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 1.0,
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: _viewController.subscriptionsList.length,
                        itemBuilder: (context, index) {
                          Subscription _subscription =
                              _viewController.subscriptionsList[index];
                          return Container(
                            height: 120.0,
                            width: 120.0,
                            child: Image.network(
                              _subscription.podcast.bestArtworkUrl ?? '',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
