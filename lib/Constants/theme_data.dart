import 'package:flutter/material.dart';

const kLightThemeKey = 'light';
const kDarkThemeKey = 'dark';

ThemeData kLightThemeData = ThemeData(
  primaryColor: Color(0xFF302F4D),
  primaryColorLight: Color(0xFF302F4D),
  highlightColor: Color(0xFF98c1d9),
  // buttonColor: Color(0xFF3d5a80),
  colorScheme: ColorScheme.light(
    secondary: Colors.black,
    primary: Colors.white,
  ),
);

ThemeData kDarkThemeData = ThemeData(
  primaryColor: Color(0xFF302F4D),
  primaryColorLight: Colors.white,
  colorScheme: ColorScheme.dark(
    secondary: Colors.white,
    primary: Color(0xFF120D31),
  ),
  highlightColor: Color(0xFF98c1d9),
  // buttonColor: Color(0xFF3d5a80),
);
