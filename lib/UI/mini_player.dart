import 'package:audio_service/audio_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:flutter/material.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  double _height = 70.0;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Consumer(
          builder: (context, ref, child) {
            var _contState = ref.watch(audioController);
            if (_contState.mediaItem != null) {
              print(" this is init");
              return _contState.isPlaying == false
                  ? Container(
                      height: _height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red.withOpacity(0.2),
                      child: Text(" nothing playing"),
                    )
                  : AnimatedContainer(
                      // height: _height,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                      ),
                      height: _height,
                      duration: Duration(milliseconds: 400),
                      child: SizedBox(
                        height: _height,
                        child: _height == 70.0
                            ? buildSmallPlayer(_contState, ref)
                            : buildLargePlayer(_contState, ref),
                      ),
                    );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Column buildLargePlayer(AudioState _contState, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 16.0,
        ),
        Expanded(
          flex: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (_height == 380.0) {
                  _height = 70.0;
                } else {
                  _height = 380.0;
                }
              });
            },
            child: Center(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Image.network(
                  _contState.mediaItem!.artUri.toString(),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<PlaybackState>(
                  stream: _contState.playbackStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    if (playing)
                      return IconButton(
                          icon: Icon(
                            FeatherIcons.pauseCircle,
                            size: 42.0,
                          ),
                          onPressed: () {
                            ref.read(audioController.notifier).pauseAction();
                            // AudioService.pause();
                          });
                    else
                      return IconButton(
                          icon: Icon(
                            FeatherIcons.playCircle,
                            size: 42.0,
                          ),
                          onPressed: () {
                            ref.read(audioController.notifier).resumeAction();
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
          ),
        ),
      ],
    );
  }

  Column buildSmallPlayer(AudioState _contState, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_height == 380.0) {
                      _height = 70.0;
                    } else {
                      _height = 380.0;
                    }
                  });
                },
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      height: 60,
                      width: 60,
                      child: _contState.mediaItem != null
                          ? Image.network(
                              _contState.mediaItem!.artUri.toString())
                          : null,
                    )),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            StreamBuilder<PlaybackState>(
                stream: _contState.playbackStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  if (playing)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                                icon: Icon(
                                  FeatherIcons.pauseCircle,
                                  size: 32.0,
                                ),
                                onPressed: () {
                                  ref
                                      .read(audioController.notifier)
                                      .pauseAction();
                                  // AudioService.pause();
                                }),
                          ),
                          IconButton(
                              icon: Icon(
                                FeatherIcons.stopCircle,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).stopAction();
                              }),
                        ],
                      ),
                    );
                  else
                    return ElevatedButton(
                        child: Icon(
                          FeatherIcons.playCircle,
                          size: 32.0,
                        ),
                        onPressed: () {
                          ref.read(audioController.notifier).resumeAction();
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
    );
  }
}
