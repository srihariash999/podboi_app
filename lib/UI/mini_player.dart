import 'package:audio_service/audio_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:flutter/material.dart';

const double _smallPlayerSize = 80.0;

/// Mini Player widget.
///
/// In `Small Player` state, Ui is a height restricted (to `_smallPlayerHeight`) container with controls and details.
///
/// In `Large/Expanded Player` state, a bottom sheet filling entire screen is opened with details and controls.
///

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool largePlayerOpen = false;

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer(
        builder: (context, ref, child) {
          // Ref to the controller.
          var _contState = ref.watch(audioController);

          if (!_contState.isPlayerShow && largePlayerOpen) {
            try {
              Navigator.pop(context);
            } catch (e) {
              print("Error caught while closing large player on playback end");
              print(e);
            }
          }

          if (_contState.audioHandler.mediaItem.value != null &&
              _contState.isPlayerShow &&
              !largePlayerOpen) {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                ),
              ),
              height: _smallPlayerSize,
              child: Material(
                color: Theme.of(context).highlightColor.withOpacity(0.3),
                child: buildSmallPlayer(_contState, ref),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  /// Method to call when the user wants the small player UI to expand.
  /// This method opens a Bottom Sheet which fills the entire screen.
  Future<void> showLargePlayer(WidgetRef ref) async {
    var _contState = ref.watch(audioController);
    setState(() {
      largePlayerOpen = true;
    });

    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        if (!ref.watch(audioController).isPlayerShow) {
          Navigator.pop(context);
        }
        return SizedBox(
          height: (MediaQuery.of(context).size.height * 0.94) -
              MediaQuery.of(context).viewPadding.top,
          child: PageView(
            controller: pageController,
            children: [
              Column(
                children: [
                  SizedBox(height: 8.0),
                  // Top action buttons of bottom sheet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Container(
                        height: 5.0,
                        width: 64.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Hero(
                        tag: 'albumArt',
                        child: _contState.audioHandler.mediaItem.value != null
                            ? Image.network(
                                _contState.audioHandler.mediaItem.value!.artUri
                                    .toString(),
                              )
                            : Container(),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      _contState.audioHandler.mediaItem.value != null
                          ? _contState.audioHandler.mediaItem.value!.title
                          : " -- ",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Segoe',
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  // State buttons stream builder
                  StreamBuilder<PlaybackState>(
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
                              width: 18.0,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                return ref.read(audioController).playerState ==
                                        false
                                    ? Container(
                                        height: 50.0,
                                        width: 50.0,
                                        margin: EdgeInsets.only(
                                            top: 12.0, left: 12.0),
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          FeatherIcons.pauseCircle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 50.0,
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(audioController.notifier)
                                              .pause();
                                        },
                                      );
                              },
                            ),
                            SizedBox(
                              width: 18.0,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.forward_10,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 50.0,
                              ),
                              onPressed: () {
                                ref
                                    .read(audioController.notifier)
                                    .fastForward();
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
                                Icons.replay_10,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 44.0,
                              ),
                              onPressed: () {
                                ref.read(audioController.notifier).rewind();
                              },
                            ),
                            IconButton(
                                icon: Icon(
                                  FeatherIcons.playCircle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                Navigator.pop(context);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.forward_10,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 42.0,
                              ),
                              onPressed: () {
                                ref
                                    .read(audioController.notifier)
                                    .fastForward();
                              },
                            ),
                          ],
                        );
                    },
                  ),
                  SizedBox(height: 48.0),
                  // Progress bar stream builder
                  StreamBuilder<Duration>(
                    stream: _contState.positionStream,
                    builder: (context, snap) {
                      if (snap.hasData &&
                          _contState.audioHandler.mediaItem.value != null &&
                          _contState.audioHandler.mediaItem.value!.duration !=
                              null) {
                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(snap.data!),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Slider(
                                min: 0.0,
                                max: _contState.audioHandler.mediaItem.value!
                                    .duration!.inSeconds
                                    .toDouble(),
                                value: snap.data!.inSeconds.toDouble(),
                                inactiveColor: Theme.of(context)
                                    .primaryColorLight
                                    .withOpacity(0.2),
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
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: 24.0),
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      SizedBox(height: 8.0),
                      // Top action buttons of bottom sheet
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              pageController.previousPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 24.0,
                            ),
                          ),
                          Container(
                            height: 5.0,
                            width: 64.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 12.0, top: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Description ",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.8),
                              fontFamily: 'Segoe',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Consumer(builder: (context, ref, child) {
                        var episodeData = ref.read(audioController).episodeData;
                        print(
                            "inside the desc builder. val: ${episodeData?.description} #");
                        if (episodeData?.description != null)
                          return Html(data: episodeData?.description);

                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.center,
                          child: Text(
                            "Episode description not available.",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.7),
                              fontFamily: 'Segoe',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      largePlayerOpen = false;
    });
  }

  /// SmallPlayer Widget. Height is restricted to `_smallPlayerHeight`
  Widget buildSmallPlayer(AudioState _contState, WidgetRef ref) {
    return GestureDetector(
      onTap: () => showLargePlayer(ref),
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dy < -sensitivity) {
          showLargePlayer(ref);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Used a card to have the empty area of the widget to be tappable.
            // Basically increases the tap target size. Useful if the title of
            // Podcast episode is very small.
            child: Card(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
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
                              child: _contState.audioHandler.mediaItem.value !=
                                      null
                                  ? Image.network(
                                      _contState
                                          .audioHandler.mediaItem.value!.artUri
                                          .toString(),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              _contState.audioHandler.mediaItem.value != null
                                  ? _contState
                                      .audioHandler.mediaItem.value!.title
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 32.0,
                                  ),
                                  onPressed: () {
                                    ref.read(audioController.notifier).rewind();
                                  }),
                              _contState.playerState == false
                                  ? Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 24.0,
                                            width: 24.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              FeatherIcons.stopCircle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 32.0,
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      audioController.notifier)
                                                  .stop();
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        FeatherIcons.pauseCircle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 32.0,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(audioController.notifier)
                                            .pause();
                                        // AudioService.pause();
                                      },
                                    ),
                              IconButton(
                                icon: Icon(
                                  Icons.forward_10,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 32.0,
                                ),
                                onPressed: () {
                                  ref
                                      .read(audioController.notifier)
                                      .fastForward();
                                },
                              ),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 32.0,
                                ),
                                onPressed: () {
                                  ref.read(audioController.notifier).resume();
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  FeatherIcons.stopCircle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 32.0,
                                ),
                                onPressed: () {
                                  ref.read(audioController.notifier).stop();
                                },
                              ),
                            ],
                          ),
                        );
                    },
                  )
                ],
              ),
            ),
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
              }
              return Container();
            },
          ),
          SizedBox(
            height: 4.0,
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
