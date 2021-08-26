import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/Services/database/subscriptions.dart';
import 'package:podboi/UI/base_screen.dart';

// import 'package:podboi/misc/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  var dir = await getApplicationDocumentsDirectory();

  Hive
    ..init(dir.path)
    ..registerAdapter(SubscriptionAdapter());

  await Hive.openBox('subscriptionsBox');
  runApp(
    ProviderScope(
      child: AudioServiceWidget(child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double minHeight = 70;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BaseScreen(),

      //  Stack(
      //   children: [
      //     HomePage(),
      //     MiniPlayer(),
      //   ],
      // ),
    );
  }
}
