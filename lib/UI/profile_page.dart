import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/profile_screen_controller.dart';
import 'package:podboi/Controllers/theme_controller.dart';
import 'package:podboi/UI/Common/custom_chip_button.dart';
import 'package:podboi/UI/Pages/settings_page.dart';
import 'package:podboi/UI/listening_history_page.dart';
import 'package:podboi/UI/player.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        FeatherIcons.arrowLeft,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        String _name = ref.watch(profileController
                            .select((value) => value.userName));
                        String _avatar = ref.watch(profileController
                            .select((value) => value.userAvatar));

                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Text(
                                        "$_name",
                                        style: TextStyle(
                                          // fontFamily: 'Segoe',
                                          fontSize: 28.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 60.0,
                                      width: 55.0,
                                      child: Icon(
                                        _avatar == 'user'
                                            ? LineIcons.user
                                            : _avatar == 'userNinja'
                                                ? LineIcons.userNinja
                                                : LineIcons.userAstronaut,
                                        size: 38.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Center(
                              child: CustomChipButtonWidget(
                                onTap: () async {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ProfileEditWidget(
                                        userName: _name,
                                        userAvatar: _avatar,
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'EDIT',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 52.0,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        String _currentTheme =
                            ref.watch(themeController).currentTheme;
                        return Column(
                          children: [
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              height: 1.0,
                            ),

                            // Listening History Tile
                            ProfilePageTileWidget(
                              tailingWidget: Icon(
                                LineIcons.history,
                                size: 28.0,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              tileName: "Listening history",
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      final tween =
                                          Tween(begin: begin, end: end);
                                      final curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: curve,
                                      );

                                      return SlideTransition(
                                        position:
                                            tween.animate(curvedAnimation),
                                        child: child,
                                      );
                                    },
                                    pageBuilder: (_, __, ___) =>
                                        ListeningHistoryView(ref: ref),
                                  ),
                                );
                              },
                            ),

                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              height: 1.0,
                            ),

                            // Theme Tile
                            ProfilePageTileWidget(
                              onTap: () {
                                if (_currentTheme == 'light') {
                                  ref
                                      .read(themeController.notifier)
                                      .changeTheme('dark');
                                } else {
                                  ref
                                      .read(themeController.notifier)
                                      .changeTheme('light');
                                }
                              },
                              tileName: "Theme",
                              tailingWidget: Row(
                                children: [
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 500),
                                    switchInCurve: Curves.easeInSine,
                                    switchOutCurve: Curves.easeOutSine,
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      final offsetAnimation = Tween<Offset>(
                                              begin: Offset(0.0, 0.8),
                                              end: Offset(0.0, 0.0))
                                          .animate(animation);
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                    child: _currentTheme == 'light'
                                        ? Icon(
                                            FeatherIcons.sun,
                                            key: UniqueKey(),
                                            size: 30.0,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          )
                                        : Icon(
                                            FeatherIcons.moon,
                                            key: UniqueKey(),
                                            size: 30.0,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                  ),
                                  SizedBox(
                                    width: 6.0,
                                  ),
                                  CupertinoSwitch(
                                    value: _currentTheme == 'light',
                                    trackColor: Theme.of(context).primaryColor,
                                    activeColor:
                                        Theme.of(context).highlightColor,
                                    onChanged: (val) async {
                                      if (val) {
                                        ref
                                            .read(themeController.notifier)
                                            .changeTheme('light');
                                      } else {
                                        ref
                                            .read(themeController.notifier)
                                            .changeTheme('dark');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              height: 1.0,
                            ),

                            // Settings Tile
                            ProfilePageTileWidget(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      final tween =
                                          Tween(begin: begin, end: end);
                                      final curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: curve,
                                      );

                                      return SlideTransition(
                                        position:
                                            tween.animate(curvedAnimation),
                                        child: child,
                                      );
                                    },
                                    pageBuilder: (_, __, ___) => SettingsPage(),
                                  ),
                                );
                              },
                              tileName: "Settings",
                              tailingWidget: Icon(
                                Icons.settings_rounded,
                                size: 28.0,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),

                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              height: 1.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePageTileWidget extends StatelessWidget {
  const ProfilePageTileWidget({
    required this.onTap,
    required this.tileName,
    required this.tailingWidget,
    super.key,
  });

  final void Function()? onTap;
  final String tileName;
  final Widget tailingWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                tileName,
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            tailingWidget,
          ],
        ),
      ),
    );
  }
}

class ProfileEditWidget extends StatefulWidget {
  const ProfileEditWidget({
    Key? key,
    required this.userAvatar,
    required this.userName,
  }) : super(key: key);
  final String userName;
  final String userAvatar;

  @override
  _ProfileEditWidgetState createState() => _ProfileEditWidgetState();
}

class _ProfileEditWidgetState extends State<ProfileEditWidget> {
  late String _selectedAvatar;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _selectedAvatar = widget.userAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                "Change Name",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                  fontFamily: 'Segoe',
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Theme(
                data: ThemeData(
                  primaryColor:
                      Theme.of(context).primaryColor.withOpacity(0.30),
                ),
                child: TextField(
                  controller: _nameController,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      LineIcons.user,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                    hintText: " What do we call you ? ",
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.50),
                    ),
                    fillColor:
                        Theme.of(context).highlightColor.withOpacity(0.4),
                    filled: true,
                    focusColor: Colors.black.withOpacity(0.30),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                "Change avatar",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                  fontFamily: 'Segoe',
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = 'user';
                    });
                  },
                  child: Icon(
                    LineIcons.user,
                    size: 52.0,
                    color: _selectedAvatar == 'user'
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = 'userNinja';
                    });
                  },
                  child: Icon(
                    LineIcons.userNinja,
                    size: 52.0,
                    color: _selectedAvatar == 'userNinja'
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = 'userAstronaut';
                    });
                  },
                  child: Icon(
                    LineIcons.userAstronaut,
                    size: 52.0,
                    color: _selectedAvatar == 'userAstronaut'
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomChipButtonWidget(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Consumer(builder: (context, ref, child) {
                  bool _loading = ref.watch(
                    profileController.select((value) => value.loading),
                  );
                  return CustomChipButtonWidget(
                    onTap: () async {
                      if (!_loading) {
                        await ref.read(profileController.notifier).editProfile(
                              name: _nameController.text.trim(),
                              avatar: _selectedAvatar,
                            );
                        Navigator.pop(context);
                      }
                    },
                    color: Color(0xFF98c1d9).withOpacity(0.7),
                    child: Text(
                      _loading ? 'Saving...' : 'Save',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
