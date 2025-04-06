import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Constants/theme_data.dart';
import 'package:podboi/Controllers/welcome_page_controller.dart';
import 'package:podboi/UI/podboi_primary_button.dart';
import 'package:podboi/UI/base_screen.dart';
import 'package:podboi/UI/avatar_widget.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();

  Brightness _getStatusBarBrightness(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness: _getStatusBarBrightness(context),
        statusBarBrightness: _getStatusBarBrightness(context),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Consumer(
          builder: (context, ref, child) {
            var selectedAvatar = ref.watch(welcomePageController).avatar;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 38.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Segoe',
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 4.0),
                            child: Text(
                              "🙂",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Segoe',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Thank you very much for choosing Podboi. ",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Segoe',
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Text(
                        "Tell us a bit about yourself",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.7),
                          fontFamily: 'Segoe',
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.black.withOpacity(0.30),
                          ),
                          child: TextField(
                            controller: _nameController,
                            cursorColor: Colors.black.withOpacity(0.30),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.black.withOpacity(0.60),
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                LineIcons.user,
                                color: Colors.black.withOpacity(0.40),
                              ),
                              isCollapsed: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              hintText: " What do we call you ? ",
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.50),
                              ),
                              fillColor: Colors.black.withOpacity(0.05),
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
                      Text(
                        "Choose an avatar",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.7),
                          fontFamily: 'Segoe',
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AvatarWidget(
                            selectedAvatar: selectedAvatar,
                            avatarName: K.avatarNames.user,
                          ),
                          AvatarWidget(
                            selectedAvatar: selectedAvatar,
                            avatarName: K.avatarNames.userNinja,
                          ),
                          AvatarWidget(
                            selectedAvatar: selectedAvatar,
                            avatarName: K.avatarNames.userAstronaut,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PodboiPrimaryButton(
                            customWitdh:
                                MediaQuery.of(context).size.width * 0.35,
                            onTap: () async {
                              String defaultName = ref
                                  .read(welcomePageController.notifier)
                                  .defaultUserName;

                              String defaultAvatar = ref
                                  .read(welcomePageController.notifier)
                                  .defaultAvatar;
                              await ref
                                  .read(welcomePageController.notifier)
                                  .saveNameRequest(
                                    nameToSave: defaultName,
                                    avatarToSave: defaultAvatar,
                                  );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BaseScreen(),
                                ),
                              );
                            },
                            color: Theme.of(context)
                                .highlightColor
                                .withOpacity(0.7),
                            child: Text(
                              'SKIP',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: kGeneralButtonColor,
                              ),
                            ),
                          ),
                          PodboiPrimaryButton(
                            customWitdh:
                                MediaQuery.of(context).size.width * 0.35,
                            onTap: () async {
                              bool r = await ref
                                  .read(welcomePageController.notifier)
                                  .saveNameRequest(
                                    nameToSave: _nameController.text.trim(),
                                    avatarToSave: selectedAvatar,
                                  );

                              if (r) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BaseScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please enter a valid name",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Segoe',
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            color: kGeneralButtonColor,
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
