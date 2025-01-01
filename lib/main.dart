import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Services/database/settings_box_controller.dart';
import 'package:podboi/Controllers/theme_controller.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/UI/base_screen.dart';
import 'package:podboi/UI/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);

  // Register custom type adapters
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(EpisodeDataAdapter());
  Hive.registerAdapter(CachedPlaybackStateAdapter());
  Hive.registerAdapter(SubscriptionDataAdapter());

  // Open all boxes.
  await Hive.openBox(K.boxes.settingsBox);
  await Hive.openBox<SubscriptionData>(K.boxes.subscriptionBox);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.zepplaud.podboi',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // final session = await AudioSession.instance;
  // await session.configure(const AudioSessionConfiguration.speech());

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
    String? _name = SettingsBoxController.getSavedUserName();

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
