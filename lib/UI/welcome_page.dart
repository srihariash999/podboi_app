import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Controllers/general_box_controller.dart';
import 'package:podboi/UI/base_screen.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _nameController = TextEditingController();

  String _selectedAvatar = 'user';

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
                        "Welcome ",
                        style: TextStyle(
                          fontSize: 38.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Segoe',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
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
                              ? Colors.black
                              : Colors.black.withOpacity(0.4),
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
                              ? Colors.black
                              : Colors.black.withOpacity(0.4),
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
                              ? Colors.black
                              : Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        if (_nameController.text.trim().length > 0) {
                          bool r = await saveNameRequest(
                            nameToSave: _nameController.text.trim(),
                            avatarToSave: _selectedAvatar,
                          );
                          if (r) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BaseScreen(),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.symmetric(horizontal: 36.0),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFF3d5a80),
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        bool r = await saveNameRequest(
                          nameToSave: 'User',
                          avatarToSave: _selectedAvatar,
                        );
                        if (r) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BaseScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.symmetric(horizontal: 36.0),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFF98c1d9).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Text(
                          'SKIP',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3d5a80),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
