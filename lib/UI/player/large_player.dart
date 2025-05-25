import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/Controllers/settings_controller.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/Shared/audio_player_resources.dart';
import 'package:podboi/UI/player/queue_item.dart';

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
          color: Theme.of(context).colorScheme.primary.withOpacityValue(0.7),
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
                  color: Theme.of(context).highlightColor.withOpacityValue(0.1),
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
                                  .withOpacityValue(0.8),
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
                                  .withOpacityValue(0.8),
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
                              ControlButtons(
                                player,
                                ref: ref,
                                goToQueueAction: () {
                                  widget.pageController.nextPage(
                                    duration: Duration(milliseconds: 150),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),

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
                                        ref
                                            .read(audioController.notifier)
                                            .seek(newPosition);
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

class ControlButtons extends StatelessWidget {
  final AudioPlayer? player;
  final WidgetRef ref;
  final void Function() goToQueueAction;

  const ControlButtons(this.player,
      {super.key, required this.ref, required this.goToQueueAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Stop Button
          StreamBuilder<PlayerState?>(
            stream: player?.playerStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(
                Icons.stop,
                size: 48.0,
              ),
              onPressed: (snapshot.data?.playing ?? false)
                  ? ref.read(audioController.notifier).stop
                  : null,
            ),
          ),

          // Rewind button
          Consumer(
            builder: (context, ref, child) {
              final rewindSec = ref.watch(settingsController.select((s) => s.rewindDuration));
              final rewindIcon = rewindSec == 10 ? Icons.replay_10 : Icons.replay_30;
              return StreamBuilder<PlayerState?>(
                stream: player?.playerStateStream,
                builder: (context, snapshot) => IconButton(
                  icon: Icon(
                    rewindIcon,
                    size: 42.0,
                  ),
                  onPressed: (snapshot.data?.playing ?? false)
                      ? ref.read(audioController.notifier).rewind
                      : null,
                ),
              );
            },
          ),

          // Play/Pause Button
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
                  onPressed: ref.read(audioController.notifier).play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: ref.read(audioController.notifier).pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => player?.seek(
                    Duration.zero,
                    index: player?.effectiveIndices.first,
                  ),
                );
              }
            },
          ),

          // Fast forward button
          Consumer(
            builder: (context, ref, child) {
              final forwardSec = ref.watch(settingsController.select((s) => s.forwardDuration));
              final forwardIcon = forwardSec == 10 ? Icons.forward_10 : Icons.forward_30;
              return StreamBuilder<PlayerState>(
                stream: player?.playerStateStream,
                builder: (context, snapshot) => IconButton(
                  icon: Icon(
                    forwardIcon,
                    size: 42.0,
                  ),
                  onPressed: (snapshot.data?.playing ?? false)
                      ? ref.read(audioController.notifier).fastForward
                      : null,
                ),
              );
            },
          ),

          // Queue View Button
          IconButton(
            icon: const Icon(
              Icons.playlist_play_outlined,
              size: 42.0,
            ),
            onPressed: goToQueueAction,
          ),
        ],
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
              color:
                  Theme.of(context).colorScheme.secondary.withOpacityValue(0.8),
              fontFamily: 'Segoe',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
