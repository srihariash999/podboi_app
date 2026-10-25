import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/UI/player/large_player.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  late final PageController _pageController;

  bool isLargePlayerOpen = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            return buildSmallPlayer(
              _contState,
              ref,
              isError: true,
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
    if (isLargePlayerOpen || !mounted) return;
    isLargePlayerOpen = true;
    try {
      // Keep the sheet in the current navigator. Using the root navigator
      // bypasses route-local inherited state on detail screens and was the
      // reason this control stopped opening reliably.
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black54,
        builder: (_) => LargePlayer(pageController: _pageController),
      );
    } finally {
      isLargePlayerOpen = false;
    }
  }

  /// SmallPlayer Widget. Height is restricted to `_smallPlayerHeight`
  Widget buildSmallPlayer(
    AudioState _contState,
    WidgetRef ref, {
    bool isError = false,
  }) {
    if (_contState is! LoadingAudioState &&
        _contState is! LoadedAudioState &&
        _contState is! ErrorAudioState) {
      return Container();
    }

    late Song song;
    if (_contState is LoadingAudioState) {
      song = _contState.song;
    } else if (_contState is LoadedAudioState) {
      song = _contState.currentPlaying;
    } else if (_contState is ErrorAudioState) {
      song = (ref.read(audioController.notifier).getCurrentPlayingSong)!;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 64.0,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // This is deliberately an opaque surface. A translucent mini player
          // becomes unreadable over episode art and scrolling content.
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            top: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacityValue(0.16),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacityValue(0.18),
              blurRadius: 12.0,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: GestureDetector(
                onTap: showLargePlayer,
                onVerticalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) < -120) {
                    showLargePlayer();
                  }
                },
                child: Card(
                  elevation: 0.0,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: CachedNetworkImage(
                          imageUrl: song.icon,
                          height: 52.0,
                          width: 52.0,
                          fit: BoxFit.cover,
                        ),
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
                                    .withOpacityValue(0.8),
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

                      if (_contState is LoadedAudioState && !isError)
                        MiniplayerActionButtons(
                          state: _contState,
                          ref: ref,
                        ),

                      // Retry button.
                      if (isError)
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          iconSize: 34.0,
                          onPressed: () {
                            ref
                                .read(audioController.notifier)
                                .requestPlayingSong(song);
                          },
                        ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ),
              ),
            ),
            if (_contState is LoadedAudioState)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: StreamBuilder<PositionData>(
                  stream: _contState.positionStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    final duration =
                        data?.duration ?? _contState.episodeDuration;
                    final progress = duration.inMilliseconds == 0
                        ? 0.0
                        : (data?.position.inMilliseconds ?? 0) /
                            duration.inMilliseconds;
                    return LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 2,
                      color: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacityValue(0.18),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
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
    return StreamBuilder<PlayerState>(
      stream: state.player.playerStateStream,
      initialData: state.player.playerState,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        if (playerState == null) return const MiniplayerLoadingIndicator();
        // Buffering while playing must still expose Pause. Hiding the control
        // behind a spinner made active playback look stuck.
        if (playerState.playing) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 34.0,
            onPressed: ref.read(audioController.notifier).pause,
          );
        }
        if (playerState.processingState == ProcessingState.loading) {
          return const MiniplayerLoadingIndicator();
        }
        return IconButton(
          icon: Icon(
            playerState.processingState == ProcessingState.completed
                ? Icons.replay
                : Icons.play_arrow,
          ),
          iconSize: 34.0,
          onPressed: ref.read(audioController.notifier).play,
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
