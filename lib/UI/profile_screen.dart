import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/profile_screen_controller.dart';
import 'package:podboi/Controllers/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
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
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Consumer(builder: (context, ref, child) {
              String _name = ref
                  .watch(profileController.select((value) => value.userName));
              String _avatar = ref
                  .watch(profileController.select((value) => value.userAvatar));

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                color: Theme.of(context).accentColor,
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
                              color: Theme.of(context).accentColor,
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
                    child: TextButton(
                      onPressed: () async {
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return ProfileEditWidget(
                                userName: _name,
                                userAvatar: _avatar,
                              );
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).buttonColor,
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Text(
                          'EDIT',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            SizedBox(
              height: 52.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Listening history",
                      style: TextStyle(
                        // fontFamily: 'Segoe',
                        fontSize: 20.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    LineIcons.history,
                    size: 28.0,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: Theme.of(context).accentColor.withOpacity(0.2),
                height: 1.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Theme",
                      style: TextStyle(
                        // fontFamily: 'Segoe',
                        fontSize: 20.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Consumer(builder: (context, ref, child) {
                    String _currentTheme =
                        ref.watch(themeController).currentTheme;
                    print(" ******* switch is built: $_currentTheme");
                    return Row(
                      children: [
                        Icon(
                          _currentTheme == 'light'
                              ? FeatherIcons.sun
                              : FeatherIcons.moon,
                          size: 30.0,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        CupertinoSwitch(
                          value: _currentTheme == 'light',
                          trackColor: Theme.of(context).primaryColorLight,
                          activeColor: Theme.of(context).primaryColorLight,
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
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: Theme.of(context).accentColor.withOpacity(0.2),
                height: 1.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
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
      color: Theme.of(context).backgroundColor.withOpacity(0.8),
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
                  color: Theme.of(context).accentColor.withOpacity(0.9),
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
                  cursorColor: Theme.of(context).accentColor,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      LineIcons.user,
                      color: Theme.of(context).accentColor,
                    ),
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                    hintText: " What do we call you ? ",
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).accentColor.withOpacity(0.50),
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
                  color: Theme.of(context).accentColor.withOpacity(0.9),
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
                        ? Theme.of(context).accentColor
                        : Theme.of(context).accentColor.withOpacity(0.4),
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
                        ? Theme.of(context).accentColor
                        : Theme.of(context).accentColor.withOpacity(0.4),
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
                        ? Theme.of(context).accentColor
                        : Theme.of(context).accentColor.withOpacity(0.4),
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
                TextButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xFF98c1d9).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(18.0)),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Consumer(builder: (context, ref, child) {
                  bool _loading = ref.watch(
                    profileController.select((value) => value.loading),
                  );
                  return TextButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Text(
                        _loading ? 'Saving...' : 'Save',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (!_loading) {
                        await ref.read(profileController.notifier).editProfile(
                              name: _nameController.text.trim(),
                              avatar: _selectedAvatar,
                            );
                        Navigator.pop(context);
                      }
                    },
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
