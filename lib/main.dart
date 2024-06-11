import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/Controllers/theme_controller.dart';

import 'package:podboi/UI/base_screen.dart';
import 'package:podboi/UI/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  final database = Directory('${appDocumentDirectory.path}/database');

  Hive.init(database.path);

  await Hive.openBox('generalBox');

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    String? _name = Hive.box('generalBox').get('userName');

    return Consumer(builder: (context, ref, child) {
      // Get current selected theme (fallback to default)
      ThemeData _currTheme = ref.watch(themeController).themeData;

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.secondary),
      );

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // Setting theme setting to current selected theme
        theme: _currTheme,
        // home: LoginScreen(),
        home: _name == null ? WelcomePage() : BaseScreen(),
      );
    });
  }
}
