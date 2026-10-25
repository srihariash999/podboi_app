import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/settings_controller.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/UI/podboi_loader.dart';
import 'package:podboi/UI/home_page.dart';
import 'package:podboi/UI/subscriptions_page.dart';
import 'package:podboi/Services/subscription_sync_service.dart';
import 'package:podboi/UI/player/mini_player.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with WidgetsBindingObserver {
  int _selectedPage = 0;
  final PageController _pageController = PageController();
  final SubscriptionSyncService _subscriptionSync = SubscriptionSyncService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Cached Hive content paints independently; this work is deliberately not
    // awaited by the first frame.
    _subscriptionSync.syncIfDue();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _subscriptionSync.syncIfDue();
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ProviderScope.containerOf(context, listen: false)
          .read(audioController.notifier)
          .checkpoint();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

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
      child: Consumer(
        builder: (context, ref, child) {
          var settings = ref.watch(settingsController);

          if (settings.loading) {
            return Container(
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: PodboiLoader(),
                // CircularProgressIndicator(
                //   color: Theme.of(context).colorScheme.secondary,
                //   strokeWidth: 1.0,
                // ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 2,
                    onPageChanged: (newIndex) {
                      setState(() {
                        _selectedPage = newIndex;
                      });
                    },
                    itemBuilder: (context, index) {
                      if (settings.subsFirst) {
                        return index == 0
                            ? SubscriptionsPage()
                            : HomePage(ref: ref);
                      } else {
                        return index == 0
                            ? HomePage(ref: ref)
                            : SubscriptionsPage();
                      }
                    },
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: MiniPlayer(),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedPage,
              onTap: (newIndex) {
                setState(() {
                  _selectedPage = newIndex;
                });
                _pageController.animateToPage(newIndex,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.ease);
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              showUnselectedLabels: false,
              fixedColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Segoe'),
              selectedLabelStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Segoe'),
              items: [
                if (!settings.subsFirst)
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: "Home",
                    icon: Icon(Icons.home,
                        color: Colors.grey.withOpacityValue(0.5)),
                  ),
                if (settings.subsFirst)
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      Icons.book,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: 'Subscriptions',
                    icon: Icon(
                      Icons.book,
                      color: Colors.grey.withOpacityValue(0.5),
                    ),
                  ),
                if (settings.subsFirst)
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: "Home",
                    icon: Icon(Icons.home,
                        color: Colors.grey.withOpacityValue(0.5)),
                  ),
                if (!settings.subsFirst)
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      Icons.book,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: 'Subscriptions',
                    icon: Icon(
                      Icons.book,
                      color: Colors.grey.withOpacityValue(0.5),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
