import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/theme_controller.dart';
import 'package:podboi/Services/database/subscriptions.dart';
import 'package:podboi/UI/base_screen.dart';
import 'package:podboi/UI/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var dir = await getApplicationDocumentsDirectory();

  Hive
    ..init(dir.path)
    ..registerAdapter(SubscriptionAdapter());

  await Hive.openBox('subscriptionsBox');
  await Hive.openBox('generalBox');
  await Hive.openBox('historyBox');

  // await initAudioService();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}



class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    String? _name = Hive.box('generalBox').get('userName');

    return Consumer(builder: (context, ref, child) {
      ThemeData _currTheme = ref.watch(themeController).themeData;

      // ref.watch(audioController.notifier).getAudioStatus().then((value) {
      //   print(" This is main ^^^^^^^^^^^^ : $value");
      // });

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.secondary));
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: _currTheme,
        home: _name == null ? WelcomePage() : BaseScreen(),
      );
    });
  }
}
