import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/profile_screen_controller.dart';
import 'package:podboi/Controllers/subscription_controller.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/UI/podboi_loader.dart';
import 'package:podboi/UI/podcast_page.dart';
import 'package:podboi/UI/profile_page.dart';
import 'package:podboi/Services/subscription_sync_service.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 20.0, bottom: 20.0),
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
                  Consumer(
                    builder: (context, ref, child) {
                      String _avatar = ref.watch(profileController
                          .select((value) => value.userAvatar));
                      return GestureDetector(
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
                    },
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  var _viewController =
                      ref.watch(subscriptionsPageViewController);
                  Future<void> refresh() async {
                    // Pull-to-refresh explicitly bypasses the hourly automatic
                    // sync guard, then reloads the reactive local projection.
                    await SubscriptionSyncService().refreshNow();
                    ref
                        .read(subscriptionsPageViewController.notifier)
                        .loadSubscriptions();
                  }

                  return _viewController.isLoading
                      ? Container(
                          alignment: Alignment.center,
                          child: PodboiLoader(),
                          // CircularProgressIndicator(
                          //   color: Colors.black,
                          //   strokeWidth: 1.0,
                          // ),
                        )
                      : Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: RefreshIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                              onRefresh: refresh,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                  maxCrossAxisExtent: 130.0,
                                  mainAxisExtent: 130.0,
                                ),
                                itemCount:
                                    _viewController.subscriptionsList.length,
                                itemBuilder: (context, index) {
                                  SubscriptionData _subscription =
                                      _viewController.subscriptionsList[index];
                                  final artworkCacheSize = (120.0 *
                                          MediaQuery.devicePixelRatioOf(
                                              context))
                                      .round();
                                  final unlistenedCount =
                                      _viewController.unlistenedCounts[
                                          _subscription.podcastId];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => PodcastPage(
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
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Center(
                                            child: Text(
                                              '${_subscription.podcastName}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 120.0,
                                          width: 120.0,
                                          // margin: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: CachedNetworkImage(
                                            imageUrl: _subscription.artworkUrl,
                                            fit: BoxFit.cover,
                                            memCacheWidth: artworkCacheSize,
                                            memCacheHeight: artworkCacheSize,
                                            maxWidthDiskCache: artworkCacheSize,
                                            maxHeightDiskCache:
                                                artworkCacheSize,
                                            fadeInDuration: Duration.zero,
                                            fadeOutDuration: Duration.zero,
                                            // Keep the podcast name beneath
                                            // the image as the intentional
                                            // fallback when artwork is absent.
                                            placeholder: (_, __) =>
                                                const SizedBox.expand(),
                                            errorWidget: (_, __, ___) =>
                                                const SizedBox.expand(),
                                          ),
                                        ),
                                        if ((unlistenedCount ?? 0) > 0)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Semantics(
                                              label:
                                                  '$unlistenedCount unlistened episodes',
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 22),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '$unlistenedCount',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
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
