import 'package:audio_service/audio_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:flutter/material.dart';

const double _smallPlayerSize = 80.0;
const double _largePlayerSize = 380.0;

// Mini Player widget.  ( Having two states, one for small, one for large players);

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  // _height variable sets the height of the player.
  double _height = _smallPlayerSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer(
        builder: (context, ref, child) {
          // Ref to the controller.
          var _contState = ref.watch(audioController);

          if (_contState.audioHandler.mediaItem.value != null) {
            return _contState.isPlayerShow == false
                ? Container(
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red.withOpacity(0.2),
                  )
                : AnimatedContainer(
                    // height: _height,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                      ),
                    ),
                    height: _height,
                    duration: Duration(milliseconds: 200),
                    child: _height == _smallPlayerSize
                        ? Material(
                            color: Theme.of(context)
                                .highlightColor
                                .withOpacity(0.3),
                            child: buildSmallPlayer(_contState, ref),
                          )
                        : Material(
                            color: Theme.of(context)
                                .highlightColor
                                .withOpacity(0.3),
                            child: buildLargePlayer(_contState, ref),
                          ),
                  );
          } else {
            return Container();
          }
        },
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_height == _largePlayerSize) {
                      _height = _smallPlayerSize;
                    } else {
                      _height = _largePlayerSize;
                    }
                  });
                },
                icon: Icon(
                  Icons.expand_more,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 36.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_height == _largePlayerSize) {
                      _height = _smallPlayerSize;
                    } else {
                      _height = _largePlayerSize;
                    }
                  });
                },
                onVerticalDragUpdate: (details) {
                  int sensitivity = 8;
                  if (details.delta.dy > sensitivity) {
                    setState(() {
                      if (_height == _largePlayerSize) {
                        _height = _smallPlayerSize;
                      } else {
                        _height = _largePlayerSize;
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
                          child: _contState.audioHandler.mediaItem.value != null
                              ? Image.network(
                                  _contState
                                      .audioHandler.mediaItem.value!.artUri
                                      .toString(),
                                )
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4.0),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        _contState.audioHandler.mediaItem.value != null
                            ? _contState.audioHandler.mediaItem.value!.title
                            : " -- ",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.secondary,
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
              stream: _contState.audioHandler.playbackState,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                if (playing)
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 50.0,
                        ),
                        onPressed: () {
                          ref.read(audioController.notifier).rewind();
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        icon: Icon(
                          FeatherIcons.pauseCircle,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 50.0,
                        ),
                        onPressed: () {
                          ref.read(audioController.notifier).pause();
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 50.0,
                        ),
                        onPressed: () {
                          ref.read(audioController.notifier).fastForward();
                        },
                      ),
                    ],
                  );
                else
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(
                            FeatherIcons.playCircle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 42.0,
                          ),
                          onPressed: () {
                            ref.read(audioController.notifier).resume();
                          }),
                      IconButton(
                          icon: Icon(
                            FeatherIcons.stopCircle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 42.0,
                          ),
                          onPressed: () {
                            ref.read(audioController.notifier).stop();
                          }),
                    ],
                  );
              }),
        ),
        StreamBuilder<Duration>(
            stream: _contState.positionStream,
            builder: (context, snap) {
              if (snap.hasData &&
                  _contState.audioHandler.mediaItem.value != null &&
                  _contState.audioHandler.mediaItem.value!.duration != null) {
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
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              '- ' +
                                  _formatDuration(
                                    Duration(
                                        seconds: _contState
                                                .audioHandler
                                                .mediaItem
                                                .value!
                                                .duration!
                                                .inSeconds -
                                            snap.data!.inSeconds),
                                  ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        min: 0.0,
                        max: _contState
                            .audioHandler.mediaItem.value!.duration!.inSeconds
                            .toDouble(),
                        value: snap.data!.inSeconds.toDouble(),
                        inactiveColor: Colors.black.withOpacity(0.1),
                        activeColor: Colors.red[400],
                        onChanged: (double d) {
                          ref
                              .read(audioController.notifier)
                              .seekTo(Duration(seconds: d.toInt()));
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
                    if (_height == _largePlayerSize) {
                      _height = _smallPlayerSize;
                    } else {
                      _height = _largePlayerSize;
                    }
                  });
                },
                onVerticalDragUpdate: (details) {
                  int sensitivity = 8;
                  if (details.delta.dy < -sensitivity) {
                    setState(() {
                      if (_height == _largePlayerSize) {
                        _height = _smallPlayerSize;
                      } else {
                        _height = _largePlayerSize;
                      }
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.expand_less,
                      color: Theme.of(context).colorScheme.secondary,
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
                        child: _contState.audioHandler.mediaItem.value != null
                            ? Image.network(
                                _contState.audioHandler.mediaItem.value!.artUri
                                    .toString(),
                              )
                            : null,
                      ),
                    )),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          _contState.audioHandler.mediaItem.value != null
                              ? _contState.audioHandler.mediaItem.value!.title
                              : "  ",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
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
                stream: _contState.audioHandler.playbackState,
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
                                color: Theme.of(context).colorScheme.secondary,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).rewind();
                              }),
                          IconButton(
                              icon: Icon(
                                FeatherIcons.pauseCircle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).pause();
                                // AudioService.pause();
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.forward_10,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref
                                    .read(audioController.notifier)
                                    .fastForward();
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
                                color: Theme.of(context).colorScheme.secondary,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).resume();
                              }),
                          IconButton(
                              icon: Icon(
                                FeatherIcons.stopCircle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 32.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).stop();
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
              if (snap.hasData &&
                  _contState.audioHandler.mediaItem.value != null &&
                  _contState.audioHandler.mediaItem.value!.duration != null) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width *
                            0.9 *
                            (snap.data!.inSeconds.toDouble() /
                                _contState.audioHandler.mediaItem.value!
                                    .duration!.inSeconds
                                    .toDouble()),
                        color: Colors.red[400],
                      ),
                      Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width * 0.9 -
                            (MediaQuery.of(context).size.width *
                                0.9 *
                                (snap.data!.inSeconds.toDouble() /
                                    _contState.audioHandler.mediaItem.value!
                                        .duration!.inSeconds
                                        .toDouble())),
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                );
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
