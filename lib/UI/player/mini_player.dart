import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/Controllers/audio_controller.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/UI/player/large_player.dart';

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
      color: Theme.of(context).highlightColor.withOpacityValue(0.1),
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
                        onPressed: ref.read(audioController.notifier).play,
                      );
                    }
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 34.0,
                      onPressed: ref.read(audioController.notifier).pause,
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
