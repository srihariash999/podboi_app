import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/UI/home_page.dart';
// import 'package:podboi/misc/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(ProviderScope(child: MyApp()));
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
      home: HomePage(),

      //  Stack(
      //   children: [
      //     HomePage(),
      //     MiniPlayer(),
      //   ],
      // ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer(
        builder: (context, ref, child) {
          var _contState = ref.watch(audioController);
          if (_contState.mediaItem != null) {
            print(" this is init");
            return AnimatedContainer(
              duration: Duration(seconds: 1),
              child: SizedBox(
                height: 70,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Flexible(
                                    child: Container(
                                  height: 60,
                                  width: 60,
                                  child: _contState.mediaItem != null
                                      ? Image.network(_contState
                                          .mediaItem!.artUri
                                          .toString())
                                      : null,
                                )),
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      _contState.mediaItem != null
                                          ? _contState.mediaItem!.title
                                          : "  ",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<PlayerState>(
                            stream: _contState.playerStateStream,
                            builder: (context, snapshot) {
                              final playing = snapshot.data?.playing ?? false;
                              if (playing)
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: ElevatedButton(
                                            child: Icon(Icons.pause),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      audioController.notifier)
                                                  .pauseAction();
                                              // AudioService.pause();
                                            }),
                                      ),
                                      ElevatedButton(
                                          child: Icon(Icons.stop),
                                          onPressed: () {
                                            ref
                                                .read(audioController.notifier)
                                                .stopAction();
                                          }),
                                    ],
                                  ),
                                );
                              else
                                return ElevatedButton(
                                    child: Icon(Icons.play_arrow),
                                    onPressed: () {
                                      ref
                                          .read(audioController.notifier)
                                          .resumeAction();
                                      // if (AudioService.running) {
                                      //   AudioService.play();
                                      // } else {
                                      //   AudioService.start(
                                      //     backgroundTaskEntrypoint:
                                      //         _backgroundTaskEntrypoint,
                                      //   );
                                      // }
                                    });
                            })
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
