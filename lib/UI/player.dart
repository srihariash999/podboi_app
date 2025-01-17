import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/Shared/audio_player_resources.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  PageController pageController = PageController();

  bool isLargePlayerOpen = false;

  bool throttle = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer(
        builder: (context, ref, child) {
          // Ref to the controller.
          var _contState = ref.watch(audioController);

          // Loading state or loaded state.
          if (_contState is LoadingAudioState ||
              _contState is LoadedAudioState) {
            return buildSmallPlayer(_contState, ref);
          }

          // Error state.
          else if (_contState is ErrorAudioState) {
            return Container(
              child: Text(" Error: ${_contState.errorMessage}"),
            );
          }

          // Fallback to empty UI.
          return Container();
        },
      ),
    );
  }

  /// Method to call when the user wants the small player UI to expand.
  /// This method opens a Bottom Sheet which fills the entire screen.
  Future<void> showLargePlayer() async {
    isLargePlayerOpen = true;
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return LargePlayer(pageController: pageController);
      },
    );
    isLargePlayerOpen = false;
  }

  /// SmallPlayer Widget. Height is restricted to `_smallPlayerHeight`
  Widget buildSmallPlayer(AudioState _contState, WidgetRef ref) {
    if (_contState is! LoadingAudioState && _contState is! LoadedAudioState) {
      return Container();
    }

    late Song song;
    if (_contState is LoadingAudioState) {
      song = _contState.song;
    } else if (_contState is LoadedAudioState) {
      song = _contState.currentPlaying;
    }

    return Material(
      color: Theme.of(context).highlightColor.withOpacity(0.1),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.08,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: GestureDetector(
          onTap: () {
            // if (_contState is! LoadedAudioState) return;
            showLargePlayer();
          },
          child: Card(
            elevation: 0.0,
            color: Colors.transparent,
            child: Row(
              children: [
                Image.network(
                  song.icon,
                  height: 52.0,
                  width: 52.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8.0),

                // Episode and Podcast details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.name,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.album,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16.0),
                // Loader to indicate episode loading
                if (_contState is LoadingAudioState)
                  MiniplayerLoadingIndicator(),

                if (_contState is LoadedAudioState)
                  MiniplayerActionButtons(
                    state: _contState,
                    ref: ref,
                  ),

                const SizedBox(width: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LargePlayerAlbumArtWidget extends StatelessWidget {
  final Song song;

  const LargePlayerAlbumArtWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 24.0,
            left: 18.0,
            right: 18.0,
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                height: MediaQuery.of(context).size.height * 0.4,
                song.icon,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            song.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              fontFamily: 'Segoe',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class MiniplayerActionButtons extends StatelessWidget {
  const MiniplayerActionButtons(
      {super.key, required this.state, required this.ref});

  final LoadedAudioState state;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: state.processingStateStream,
      builder: (context, snapshot) {
        return Row(
          children: [
            if (snapshot.data == ProcessingState.loading ||
                snapshot.data == ProcessingState.buffering)
              MiniplayerLoadingIndicator(),
            if (snapshot.data == ProcessingState.ready)
              StreamBuilder<PlayerState>(
                stream: state.player.playerStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final playing = snapshot.data!.playing;
                    if (playing != true) {
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 34.0,
                        onPressed: state.player.play,
                      );
                    }
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 34.0,
                      onPressed: state.player.pause,
                    );
                  }
                  return MiniplayerLoadingIndicator();
                },
              ),
          ],
        );
      },
    );
  }
}

class MiniplayerLoadingIndicator extends StatelessWidget {
  const MiniplayerLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      width: 24.0,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
        strokeWidth: 2.0,
      ),
    );
  }
}

class QueueItem extends StatelessWidget {
  final bool isEmptyState;
  final Song song;
  final int index;
  final bool showDragHandle;
  final Function(int) onTap;
  const QueueItem({
    super.key,
    required this.index,
    required this.showDragHandle,
    required this.onTap,
    this.isEmptyState = false,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmptyState) {
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
              "Nothing in Queue",
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
                song.icon,
                height: 64.0,
                width: 64.0,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12.0),

            // Episode details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    song.album,
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
                    song.name,
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
                      Duration(seconds: song.duration ?? 0),
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
  final AudioPlayer? player;
  final WidgetRef ref;

  const ControlButtons(this.player, {super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rewind button
          StreamBuilder<PlayerState?>(
            stream: player?.playerStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(
                Icons.replay_30,
                size: 42.0,
              ),
              onPressed: (snapshot.data?.playing ?? false)
                  ? ref.read(audioController.notifier).rewind
                  : null,
            ),
          ),
          SizedBox(width: 16.0),
          StreamBuilder<PlayerState>(
            stream: player?.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState =
                  playerState?.processingState ?? ProcessingState.loading;
              final playing = playerState?.playing ?? false;
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
                  onPressed: player?.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: player?.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => player?.seek(Duration.zero,
                      index: player?.effectiveIndices!.first),
                );
              }
            },
          ),
          SizedBox(width: 16.0),

          // Fast forward button
          StreamBuilder<PlayerState>(
            stream: player?.playerStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(
                Icons.forward_30,
                size: 42.0,
              ),
              onPressed: (snapshot.data?.playing ?? false)
                  ? ref.read(audioController.notifier).fastForward
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class LargePlayer extends StatefulWidget {
  const LargePlayer({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<LargePlayer> createState() => _LargePlayerState();
}

class _LargePlayerState extends State<LargePlayer> {
  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          // color: Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        padding: const EdgeInsets.only(top: 12.0),
        child: Consumer(
          builder: (context, ref, child) {
            var state = ref.watch(audioController);

            List<Song> playlist = ref.watch(audioController).playlist;

            if (state is! LoadedAudioState && state is! LoadingAudioState)
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                padding: const EdgeInsets.only(top: 12.0),
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  strokeWidth: 2.0,
                ),
              );

            late Song song;
            AudioPlayer? player;

            if (state is LoadedAudioState) {
              song = state.currentPlaying;
              player = state.player;
            }

            if (state is LoadingAudioState) {
              song = state.song;
            }

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedSlide(
                      offset: Offset(currentPage == 0 ? 0.08 : 0.88, 0),
                      duration: Duration(milliseconds: 150),
                      child: Container(
                        height: 4.0,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Up Next Heading
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentPage == 0)
                          Text(
                            "Current Playing",
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
                        InkWell(
                          onTap: () {
                            if (currentPage == 0) {
                              widget.pageController.nextPage(
                                duration: Duration(milliseconds: 150),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              widget.pageController.previousPage(
                                duration: Duration(milliseconds: 150),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Icon(
                            currentPage == 0
                                ? Icons.arrow_forward
                                : Icons.arrow_back,
                            size: 28.0,
                          ),
                        ),
                        if (currentPage == 1)
                          Text(
                            "Queue ${playlist.isEmpty ? "" : "(${playlist.length})"}",
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),
                  Expanded(
                    child: PageView.builder(
                      controller: widget.pageController,
                      itemCount: 2,
                      onPageChanged: (v) {
                        setState(() {
                          currentPage = v;
                        });
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              // Album Art and title
                              LargePlayerAlbumArtWidget(song: song),

                              SizedBox(height: 12.0),

                              // Play/Pause, Rewind, Fast Forward buttons
                              ControlButtons(player, ref: ref),

                              // Seekbar
                              if (state is LoadedAudioState)
                                StreamBuilder<PositionData>(
                                  stream: (state).positionStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return SeekBar(
                                      duration: positionData?.duration ??
                                          state.player.duration ??
                                          state.episodeDuration,
                                      position: positionData?.position ??
                                          state.player.position,
                                      bufferedPosition:
                                          positionData?.bufferedPosition ??
                                              state.player.position,
                                      onChangeEnd: (newPosition) {
                                        state.player.seek(newPosition);
                                      },
                                    );
                                  },
                                ),

                              SizedBox(height: 18.0)
                            ],
                          );
                        }

                        return Column(
                          children: [
                            // Empty Queue Tile
                            if (playlist.isEmpty)
                              QueueItem(
                                index: -1,
                                isEmptyState: true,
                                showDragHandle: playlist.length >= 2,
                                onTap: (int index) {},
                                song: Song.dummy(),
                              ),
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  // Playlist / Queue
                                  if (playlist.isNotEmpty)
                                    SliverReorderableList(
                                      itemCount: playlist.length,
                                      onReorder: (x, y) {
                                        ref
                                            .read(audioController.notifier)
                                            .reorderQueue(x, y);
                                      },
                                      itemBuilder: (context, i) {
                                        return Dismissible(
                                          key: ValueKey(playlist[i].url),
                                          background: Container(
                                            color: Colors.redAccent,
                                            alignment: Alignment.centerRight,
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.delete,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onDismissed: (dismissDirection) {
                                            ref
                                                .read(audioController.notifier)
                                                .removeFromQueue(i);
                                          },
                                          child: QueueItem(
                                            index: i,
                                            song: playlist[i],
                                            showDragHandle:
                                                playlist.length >= 2,
                                            onTap: (int s) {
                                              ref
                                                  .read(
                                                      audioController.notifier)
                                                  .skipToSpecificIndex(s);
                                            },
                                          ),
                                        );
                                      },
                                    ),

                                  // Bottom Spacing
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
