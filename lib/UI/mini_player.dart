import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:intl/intl.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/Shared/audio_player_resources.dart';

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

          if (_contState.isPlayerShow && !largePlayerOpen) {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                ),
              ),
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

        return CustomScrollView(
          slivers: [
            // Top Spacing
            SliverToBoxAdapter(child: SizedBox(height: 24.0)),

            // Close Button
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Icon(Icons.close),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Album Art and title
            SliverToBoxAdapter(
              child: StreamBuilder<SequenceState?>(
                stream: _contState.player?.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 24.0,
                          left: 18.0,
                          right: 18.0,
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              metadata.artUri.toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          metadata.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.8),
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),

            // Play/Pause, Rewind, Fast Forward buttons
            SliverToBoxAdapter(child: ControlButtons(_contState.player!)),

            // Seekbar
            SliverToBoxAdapter(
              child: StreamBuilder<PositionData>(
                stream: _contState.stream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) {
                      _contState.player?.seek(newPosition);
                    },
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8.0)),

            // Up Next Heading
            StreamBuilder(
              stream: _contState.player?.sequenceStateStream,
              builder: (context, snapshot) {
                return SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          bottom: 16.0,
                          top: 16.0,
                        ),
                        child: Text(
                          "Up Next",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.8),
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Playlist / Queue
            StreamBuilder(
              stream: _contState.player?.sequenceStateStream,
              builder: (context, snapshot) {
                final streamState = snapshot.data;
                final sequence = streamState?.sequence ?? [];
                return SliverReorderableList(
                  itemCount: sequence.length,
                  onReorder: (x, y) {
                    ref.read(audioController.notifier).reorderQueue(x, y);
                  },
                  itemBuilder: (context, i) {
                    // If nothing else in the Queue.
                    if (sequence.length == 1) {
                      return QueueItem(
                        key: ValueKey(i),
                        index: i,
                        isEmptyState: true,
                        showDragHandle: sequence.length > 2,
                        onTap: (int index) {},
                      );
                    }

                    if (i == 0) {
                      return SizedBox(key: ValueKey(i));
                    }

                    return Dismissible(
                      key: ValueKey(sequence[i]),
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      onDismissed: (dismissDirection) {
                        ref.read(audioController.notifier).removeFromQueue(i);
                      },
                      child: QueueItem(
                        key: ValueKey(i),
                        index: i,
                        mediaItem: sequence[i].tag as MediaItem,
                        showDragHandle: sequence.length > 2,
                        onTap: ref
                            .read(audioController.notifier)
                            .skipToSpecificIndex,
                      ),
                    );
                  },
                );
              },
            ),

            // Bottom Spacing
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            )
          ],
        );
      },
    );

    setState(() {
      largePlayerOpen = false;
    });
  }

  /// SmallPlayer Widget. Height is restricted to `_smallPlayerHeight`
  Widget buildSmallPlayer(AudioState _contState, WidgetRef ref) {
    final player = _contState.player;
    return GestureDetector(
      onTap: () => {print(" tapped"), showLargePlayer(ref)},
      child: Card(
        elevation: 0.0,
        color: Colors.transparent,
        child: StreamBuilder<SequenceState?>(
          stream: player?.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final metadata = state!.currentSource!.tag as MediaItem;

            bool canRewind = false;
            bool canFastForward = false;

            if (player?.playing ?? false) {
              if ((player?.position.inSeconds ?? 0) > 30) {
                canRewind = true;
              }

              if ((player?.duration?.inSeconds ?? 0) -
                      (player?.position.inSeconds ?? 0) >
                  30) {
                canFastForward = true;
              }
            }

            const centerButtonSize = 42.0;

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Album art
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 18.0,
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              metadata.artUri.toString(),
                              fit: BoxFit.cover,
                              height: 56.0,
                              width: 56.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Control buttons
                    if (player != null)
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Rewind
                            IconButton(
                              icon: const Icon(
                                Icons.replay_30,
                                size: 34.0,
                              ),
                              onPressed: !canRewind
                                  ? null
                                  : () async {
                                      player.seek(
                                        Duration(
                                          seconds:
                                              player.position.inSeconds - 30,
                                        ),
                                      );
                                    },
                            ),

                            // Pause / Play // Loading
                            StreamBuilder<PlayerState>(
                              stream: player.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;
                                final processingState =
                                    playerState?.processingState;
                                final playing = playerState?.playing;
                                if (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering) {
                                  return Container(
                                    margin: const EdgeInsets.all(8.0),
                                    width: centerButtonSize,
                                    height: centerButtonSize,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  );
                                } else if (playing != true) {
                                  return IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    iconSize: centerButtonSize,
                                    onPressed: player.play,
                                  );
                                } else if (processingState !=
                                    ProcessingState.completed) {
                                  return IconButton(
                                    icon: const Icon(Icons.pause),
                                    iconSize: centerButtonSize,
                                    onPressed: player.pause,
                                  );
                                } else {
                                  return IconButton(
                                    icon: const Icon(Icons.replay),
                                    iconSize: centerButtonSize,
                                    onPressed: () => player.seek(Duration.zero,
                                        index: player.effectiveIndices!.first),
                                  );
                                }
                              },
                            ),

                            // Fast forward
                            IconButton(
                              icon: const Icon(
                                Icons.forward_30,
                                size: 34.0,
                              ),
                              onPressed: !canFastForward
                                  ? null
                                  : () async {
                                      player.seek(
                                        Duration(
                                          seconds:
                                              player.position.inSeconds + 30,
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),

                    // Queue / Playlist
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.playlist_play_rounded,
                            size: 36.0,
                          ),
                          if (_contState.playlist != null &&
                              _contState.playlist!.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                (_contState.playlist!.length - 1).toString(),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Segoe',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 8.0),

                // Progress bar
                if (player?.playing ?? false)
                  StreamBuilder<Duration>(
                    stream: _contState.player?.positionStream,
                    builder: (context, snap) {
                      if (snap.hasData) {
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
                                        _contState.player!.duration!.inSeconds
                                            .toDouble()),
                                color: Colors.red[400],
                              ),
                              Container(
                                height: 5.0,
                                width: MediaQuery.of(context).size.width * 0.9 -
                                    (MediaQuery.of(context).size.width *
                                        0.9 *
                                        (snap.data!.inSeconds.toDouble() /
                                            _contState
                                                .player!.duration!.inSeconds
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
              ],
            );
          },
        ),
      ),
    );
  }
}

class QueueItem extends StatelessWidget {
  final bool isEmptyState;
  final MediaItem? mediaItem;
  final int index;
  final bool showDragHandle;
  final Function(int) onTap;
  const QueueItem({
    super.key,
    required this.index,
    required this.showDragHandle,
    required this.onTap,
    this.isEmptyState = false,
    this.mediaItem,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmptyState || mediaItem == null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Text(
              "Nothing in Up Next",
              style: TextStyle(
                fontSize: 24.0,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            Text(
              "You can queue episodes to play next by swiping right on an episode.",
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Album artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                mediaItem?.artUri.toString() ?? '',
                height: 64.0,
                width: 64.0,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(
              width: 12.0,
            ),

            // Episode details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    mediaItem?.album ?? '',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4),
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    mediaItem?.title ?? '',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.8),
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    Helpers.formatDurationToMinutes(
                      mediaItem?.duration ?? Duration.zero,
                    ),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4),
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Drag handle
            if (showDragHandle)
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: ReorderableDragStartListener(
                  key: ValueKey(index), // Important for reordering
                  index: index,
                  child: Icon(
                    Icons.menu,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(
                Icons.skip_previous,
                size: 42.0,
              ),
              onPressed: player.hasPrevious ? player.seekToPrevious : null,
            ),
          ),
          SizedBox(width: 16.0),
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 64.0,
                  height: 64.0,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => player.seek(Duration.zero,
                      index: player.effectiveIndices!.first),
                );
              }
            },
          ),
          SizedBox(width: 16.0),
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(
                Icons.skip_next,
                size: 42.0,
              ),
              onPressed: player.hasNext ? player.seekToNext : null,
            ),
          ),
        ],
      ),
    );
  }
}
