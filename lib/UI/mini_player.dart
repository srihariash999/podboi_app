import 'package:audio_service/audio_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:flutter/material.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  double _height = 80.0;
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
              return _contState.isPlayerShow == false
                  ? Container(
                      height: _height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red.withOpacity(0.2),
                    )
                  : AnimatedContainer(
                      // height: _height,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.4),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          topLeft: Radius.circular(16.0),
                        ),
                        color: Colors.grey.withOpacity(0.05),
                      ),
                      height: _height,
                      duration: Duration(milliseconds: 200),
                      child: _height == 80.0
                          ? buildSmallPlayer(_contState, ref)
                          : buildLargePlayer(_contState, ref),
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
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_height == 380.0) {
                      _height = 80.0;
                    } else {
                      _height = 380.0;
                    }
                  });
                },
                icon: Icon(
                  Icons.expand_more,
                  size: 36.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_height == 380.0) {
                      _height = 80.0;
                    } else {
                      _height = 380.0;
                    }
                  });
                },
                onVerticalDragUpdate: (details) {
                  int sensitivity = 8;
                  if (details.delta.dy > sensitivity) {
                    setState(() {
                      if (_height == 380.0) {
                        _height = 80.0;
                      } else {
                        _height = 380.0;
                      }
                    });
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'albumArt',
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
                    Container(
                      padding: EdgeInsets.only(top: 4.0),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        '${_contState.mediaItem?.title}',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Segoe'),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.expand_more,
                  color: Colors.transparent,
                  size: 36.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: StreamBuilder<PlaybackState>(
              stream: _contState.playbackStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                if (playing)
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          size: 50.0,
                        ),
                        onPressed: () {
                          ref.read(audioController.notifier).rewind();
                          // AudioService.pause();
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        icon: Icon(
                          FeatherIcons.pauseCircle,
                          size: 50.0,
                        ),
                        onPressed: () {
                          ref.read(audioController.notifier).pauseAction();
                          // AudioService.pause();
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          size: 50.0,
                        ),
                        onPressed: () {
                          ref.read(audioController.notifier).fastForward();
                          // AudioService.pause();
                        },
                      ),
                    ],
                  );
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
              }),
        ),
        StreamBuilder<Duration>(
            stream: _contState.positionStream,
            builder: (context, snap) {
              if (snap.hasData) {
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(snap.data!),
                            ),
                            Text(
                              '- ' +
                                  _formatDuration(
                                    Duration(
                                        seconds: _contState.mediaItem!.duration!
                                                .inSeconds -
                                            snap.data!.inSeconds),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        min: 0.0,
                        max: _contState.mediaItem!.duration!.inSeconds
                            .toDouble(),
                        value: snap.data!.inSeconds.toDouble(),
                        inactiveColor: Colors.black.withOpacity(0.1),
                        activeColor: Colors.red[400],
                        onChanged: (double d) {
                          ref.read(audioController.notifier).seekTo(d);
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            })
      ],
    );
  }

  Widget buildSmallPlayer(AudioState _contState, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_height == 380.0) {
                      _height = 80.0;
                    } else {
                      _height = 380.0;
                    }
                  });
                },
                onVerticalDragUpdate: (details) {
                  int sensitivity = 8;
                  if (details.delta.dy < -sensitivity) {
                    setState(() {
                      if (_height == 380.0) {
                        _height = 80.0;
                      } else {
                        _height = 380.0;
                      }
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.expand_less,
                    ),
                    Flexible(
                        child: Hero(
                      tag: 'albumArt',
                      child: Container(
                        height: 60,
                        width: 60,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0)),
                        child: _contState.mediaItem != null
                            ? Image.network(
                                _contState.mediaItem!.artUri.toString())
                            : null,
                      ),
                    )),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          _contState.mediaItem != null
                              ? _contState.mediaItem!.title
                              : "  ",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Segoe',
                          ),
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
                          IconButton(
                              icon: Icon(
                                Icons.replay_10,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).rewind();
                                // AudioService.pause();
                              }),
                          IconButton(
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
                          IconButton(
                              icon: Icon(
                                Icons.forward_10,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref
                                    .read(audioController.notifier)
                                    .fastForward();
                                // AudioService.pause();
                              }),
                        ],
                      ),
                    );
                  else
                    return Container(
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                FeatherIcons.playCircle,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref
                                    .read(audioController.notifier)
                                    .resumeAction();
                                // AudioService.pause();
                              }),
                          IconButton(
                              icon: Icon(
                                FeatherIcons.stopCircle,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).stopAction();
                                // AudioService.pause();
                              }),
                        ],
                      ),
                    );
                })
          ],
        ),
        SizedBox(
          height: 2.0,
        ),
        StreamBuilder<Duration>(
            stream: _contState.positionStream,
            builder: (context, snap) {
              if (snap.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width *
                            0.95 *
                            (snap.data!.inSeconds.toDouble() /
                                _contState.mediaItem!.duration!.inSeconds
                                    .toDouble()),
                        color: Colors.red[400],
                      ),
                      Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width * 0.95 -
                            (MediaQuery.of(context).size.width *
                                0.95 *
                                (snap.data!.inSeconds.toDouble() /
                                    _contState.mediaItem!.duration!.inSeconds
                                        .toDouble())),
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                );
                // Container(
                //   child: Slider(
                //     min: 0.0,
                //     max: _contState.mediaItem!.duration!.inSeconds.toDouble(),
                //     value: snap.data!.inSeconds.toDouble(),
                //     inactiveColor: Colors.black.withOpacity(0.1),
                //     activeColor: Colors.orange.withOpacity(0.8),
                //     onChanged: (double d) {
                //       ref.read(audioController.notifier).seekTo(d);
                //     },
                //   ),
                // );
              } else {
                return Container();
              }
            }),
        SizedBox(
          height: 1.0,
        ),
      ],
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
