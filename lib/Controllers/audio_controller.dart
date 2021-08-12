import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/misc/database.dart';
// import 'package:rxdart/streams.dart';

late MediaItem _mediaItem;
// late ProviderRefBase _mainRef;

final _audioPlayer = AudioPlayer();

int current = 0;

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier(ref);
});

class AudioStateNotifier extends StateNotifier<AudioState> {
  AudioStateNotifier(this.ref) : super(AudioState.initial()) {
    // _mainRef = ref;
  }
  final ProviderRefBase ref;
  playAction(int id) async {
    current = id;
    _mediaItem = MediaItem(
        id: songList[current].url,
        title: songList[current].name,
        artUri: Uri.parse(songList[current].icon),
        album: songList[current].album,
        duration: songList[current].duration,
        artist: songList[current].artist);

    if (_audioPlayer.playing) {
      _audioPlayer.stop();
      await _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(_mediaItem.id),
        tag: _mediaItem,
      ));
      await _audioPlayer.play();
    } else {
      state = state.copyWith(mediaItem: _mediaItem);
      await _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(_mediaItem.id),
        tag: _mediaItem,
      ));
      await _audioPlayer.play();
    }

    // if (AudioService.running) {
    //   state = state.copyWith(mediaItem: _mediaItem);
    //   await _audioPlayer.setUrl(_mediaItem.id);
    //   await _audioPlayer.play();
    //   AudioService.play();
    // } else {
    //   await _audioPlayer.setUrl(_mediaItem.id);
    //   // AudioServiceBackground.setMediaItem(_mediaItem);
    //   // Now we're ready to play
    //   _audioPlayer.play();
    //   // AudioService.start(
    //     // backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
    //   // );

    //   state = state.copyWith(mediaItem: _mediaItem);
    // }
  }

  resumeAction() {
    _audioPlayer.play();
    // AudioServiceBackground.setState(controls: [
    //   MediaControl.pause,
    //   MediaControl.stop,
    //   MediaControl.skipToNext,
    //   MediaControl.skipToPrevious
    // ], systemActions: [
    //   MediaAction.seekTo
    // ], playing: true, processingState: AudioProcessingState.ready);
  }

  pauseAction() {
    _audioPlayer.pause();
  }

  stopAction() async {
    _audioPlayer.stop();
    // AudioServiceBackground.setState(
    // controls: [],
    // playing: false,
    // processingState: AudioProcessingState.ready);

    state = state.copyWith(mediaItem: null);
  }

  skipToNext() async {
    if (current < songList.length - 1)
      current = current + 1;
    else
      current = 0;

    _mediaItem = MediaItem(
        id: songList[current].url,
        title: songList[current].name,
        artUri: Uri.parse(songList[current].icon),
        album: songList[current].album,
        duration: songList[current].duration,
        artist: songList[current].artist);

    // AudioServiceBackground.setMediaItem(_mediaItem);
    await _audioPlayer.setUrl(_mediaItem.id);
    _audioPlayer.play();
    state = state.copyWith(mediaItem: _mediaItem);
    // AudioServiceBackground.setState(position: Duration.zero);
  }

  skipToPrevious() async {
    if (current != 0)
      current = current - 1;
    else
      current = songList.length - 1;
    _mediaItem = MediaItem(
        id: songList[current].url,
        title: songList[current].name,
        artUri: Uri.parse(songList[current].icon),
        album: songList[current].album,
        duration: songList[current].duration,
        artist: songList[current].artist);

    // AudioServiceBackground.setMediaItem(_mediaItem);
    await _audioPlayer.setUrl(_mediaItem.id);
    _audioPlayer.play();
    state = state.copyWith(mediaItem: _mediaItem);
    // AudioServiceBackground.setState(position: Duration.zero);
  }

  seekTo(double val) {
    // AudioService.seekTo(Duration(seconds: val.toInt()));
  }
}

class AudioState {
  final MediaItem? mediaItem;
  final Stream<Duration> positionStream;
  final Stream<PlayerState> playerStateStream;
  // final ValueStream<MediaItem?> currentMediaItemStream;
  // final ValueStream<PlaybackState> playbackStateStream;
  // final ValueStream<Duration> positionStream;
  AudioState({
    this.mediaItem,
    required this.positionStream,
    required this.playerStateStream,
    // required this.currentMediaItemStream,
    // required this.playbackStateStream,
    // required this.positionStream,
  });
  factory AudioState.initial() {
    return AudioState(
      positionStream: _audioPlayer.positionStream,
      playerStateStream: _audioPlayer.playerStateStream,
      // currentMediaItemStream: AudioService.currentMediaItemStream,
      // playbackStateStream: AudioService.playbackStateStream,
      // positionStream: AudioService.positionStream,
    );
  }
  AudioState copyWith({
    MediaItem? mediaItem,
    Stream<Duration>? positionStream,
    Stream<PlayerState>? playerStateStream,
    // ValueStream<MediaItem?>? currentMediaItemStream,
    // ValueStream<PlaybackState>? playbackStateStream,
    // ValueStream<Duration>? positionStream
  }) {
    return AudioState(
      mediaItem: mediaItem,
      positionStream: positionStream ?? this.positionStream,
      playerStateStream: playerStateStream ?? this.playerStateStream,
      // currentMediaItemStream:
      //     currentMediaItemStream ?? this.currentMediaItemStream,
      // playbackStateStream: playbackStateStream ?? this.playbackStateStream,
      // positionStream: positionStream ?? this.positionStream,
    );
  }
}

// _backgroundTaskEntrypoint() {
//   AudioServiceBackground.run(() => _AudioPlayerTask());
// }
// class _AudioPlayerTask extends BackgroundAudioTask {
//   @override
//   Future<void> onStart(Map<String, dynamic>? params) async {
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       MediaAction.seekTo
//     ], playing: true, processingState: AudioProcessingState.connecting);

//     AudioServiceBackground.setMediaItem(_mediaItem);

//     // Broadcast that we're playing, and what controls are available.
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       MediaAction.seekTo
//     ], playing: true, processingState: AudioProcessingState.ready);
//     return super.onStart(params);
//   }

//   @override
//   Future<void> onStop() async {
//     _mainRef.read(audioController.notifier).stopAction();
//     await super.onStop();
//   }

//   @override
//   Future<void> onPlay() async {
//     _mainRef.read(audioController.notifier).resumeAction();

//     return super.onPlay();
//   }

//   @override
//   Future<void> onPause() async {
//     _mainRef.read(audioController.notifier).pauseAction();
//     AudioServiceBackground.setState(controls: [
//       MediaControl.play,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       MediaAction.seekTo
//     ], playing: false, processingState: AudioProcessingState.ready);
//     return super.onPause();
//   }

//   @override
//   Future<void> onSkipToNext() async {
//     _mainRef.read(audioController.notifier).skipToNext();
//     return super.onSkipToNext();
//   }

//   @override
//   Future<void> onSkipToPrevious() async {
//     _mainRef.read(audioController.notifier).skipToPrevious();
//     return super.onSkipToPrevious();
//   }

//   @override
//   Future<void> onSeekTo(Duration position) {
//     _audioPlayer.seek(position);
//     AudioServiceBackground.setState(position: position);
//     return super.onSeekTo(position);
//   }
// }
