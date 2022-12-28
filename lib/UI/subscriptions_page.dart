// import 'dart:convert';yyyyyy

// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/profile_screen_controller.dart';
// import 'package:podboi/Services/conversion_helpers.dart';
import 'package:podboi/UI/podcast_page.dart';
import 'package:podboi/UI/profile_screen.dart';
// import 'package:podcast_search/podcast_search.dart';

import 'package:podboi/Controllers/subscription_controller.dart';

import '../Services/database/database.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).backgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 20.0, bottom: 20.0),
                    child: Text(
                      "Your Subscriptions",
                      style: TextStyle(
                        fontFamily: 'Segoe',
                        fontSize: 22.0,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Consumer(builder: (context, ref, child) {
                    String _avatar =
                        ref.watch(profileController.select((value) => value.userAvatar));
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
                            pageBuilder: (_, __, ___) => ProfileScreen(),
                          ),
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
                          size: 32.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  var _viewController = ref.watch(subscriptionsPageViewController);
                  Future<void> refresh() async {
                    ref.read(subscriptionsPageViewController.notifier).loadSubscriptions();
                  }

                  return _viewController.isLoading
                      ? Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 1.0,
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: RefreshIndicator(
                              onRefresh: refresh,
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  // crossAxisCount: 3,
                                  // childAspectRatio: 1.5,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                  maxCrossAxisExtent: 130.0,
                                  mainAxisExtent: 130.0,
                                ),
                                itemCount: _viewController.subscriptionsList.length,
                                itemBuilder: (context, index) {
                                  SubscriptionData _subscription =
                                      _viewController.subscriptionsList[index];
                                  print(" release: ${_subscription.releaseDate}");
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
                                            subscription: _subscription,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 120.0,
                                          width: 120.0,
                                          margin: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Center(
                                            child: Text(
                                              '${_subscription.podcastName}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Hero(
                                          tag: 'logo${_subscription.podcastId}',
                                          child: Container(
                                            height: 120.0,
                                            width: 120.0,
                                            // margin: EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                              _subscription.artworkUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
