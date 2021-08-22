import 'dart:async';

import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/misc/database.dart';
import 'package:rxdart/streams.dart';
// import 'package:rxdart/streams.dart';

// late ProviderRefBase _mainRef;

// final _audioPlayer = AudioPlayer();

// int current = 0;

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier();
});

class AudioStateNotifier extends StateNotifier<AudioState> {
  AudioStateNotifier() : super(AudioState.initial()) {
    // _mainRef = ref;
  }

  playAction(Song song) async {
    // current = id;

    if (AudioService.running) {
      print(" it is running");
      await AudioService.play();
      state = state.copyWith(isPlaying: true);
    } else {
      print(" fresh init");
      await AudioService.connect();

      await AudioService.start(
          backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
          androidNotificationChannelName: 'Podboi',
          params: {'mediaI': song.url},
          androidNotificationColor: 0xFF4d91be,
          // androidNotificationIcon: 'drawable/ic_launcher.png',
          androidShowNotificationBadge: true,
          // androidEnableQueue: true,
          androidStopForegroundOnPause: true,
          androidResumeOnClick: true
          // fastForwardInterval: Duration(seconds: _fastForwardSeconds),
          // rewindInterval: Duration(seconds: _rewindSeconds),
          );
      await AudioService.play();

      state = state.copyWith(
        isPlaying: true,
        mediaItem: MediaItem(
            id: song.url,
            title: song.name,
            artUri: Uri.parse(song.icon),
            album: song.album,
            duration: song.duration,
            artist: song.artist),
      );
    }
  }

  resumeAction() async {
    await AudioService.play();
  }

  pauseAction() async {
    await AudioService.pause();
    state = state.copyWith(isPlaying: false);
  }

  stopAction() async {
    await AudioService.stop();
  }

  // skipToNext() async {
  //   if (current < songList.length - 1)
  //     current = current + 1;
  //   else
  //     current = 0;

  //   _mediaItem = MediaItem(
  //       id: songList[current].url,
  //       title: songList[current].name,
  //       artUri: Uri.parse(songList[current].icon),
  //       album: songList[current].album,
  //       duration: songList[current].duration,
  //       artist: songList[current].artist);

  //   // AudioServiceBackground.setMediaItem(_mediaItem);
  //   await _audioPlayer.setUrl(_mediaItem.id);
  //   _audioPlayer.play();
  //   state = state.copyWith(mediaItem: _mediaItem);
  //   // AudioServiceBackground.setState(position: Duration.zero);
  // }

  // skipToPrevious() async {
  //   if (current != 0)
  //     current = current - 1;
  //   else
  //     current = songList.length - 1;
  //   _mediaItem = MediaItem(
  //       id: songList[current].url,
  //       title: songList[current].name,
  //       artUri: Uri.parse(songList[current].icon),
  //       album: songList[current].album,
  //       duration: songList[current].duration,
  //       artist: songList[current].artist);

  //   // AudioServiceBackground.setMediaItem(_mediaItem);
  //   await _audioPlayer.setUrl(_mediaItem.id);
  //   _audioPlayer.play();
  //   state = state.copyWith(mediaItem: _mediaItem);
  //   // AudioServiceBackground.setState(position: Duration.zero);
  // }

  // seekTo(double val) {
  //   // AudioService.seekTo(Duration(seconds: val.toInt()));
  // }
}

class AudioState {
  final MediaItem? mediaItem;
  // final Stream<Duration> positionStream;
  // final Stream<PlayerState> playerStateStream;
  final bool isPlaying;
  final ValueStream<MediaItem?> currentMediaItemStream;
  final ValueStream<PlaybackState> playbackStateStream;
  final ValueStream<Duration> positionStream;
  AudioState({
    this.mediaItem,
    // required this.positionStream,
    // required this.playerStateStream,
    required this.currentMediaItemStream,
    required this.playbackStateStream,
    required this.isPlaying,
    required this.positionStream,
  });
  factory AudioState.initial() {
    return AudioState(
      // positionStream: _audioPlayer.positionStream,
      // playerStateStream: _audioPlayer.playerStateStream,
      isPlaying: false,
      currentMediaItemStream: AudioService.currentMediaItemStream,
      playbackStateStream: AudioService.playbackStateStream,
      positionStream: AudioService.positionStream,
    );
  }
  AudioState copyWith(
      {MediaItem? mediaItem,
      // Stream<Duration>? positionStream,
      // Stream<PlayerState>? playerStateStream,
      bool? isPlaying,
      ValueStream<MediaItem?>? currentMediaItemStream,
      ValueStream<PlaybackState>? playbackStateStream,
      ValueStream<Duration>? positionStream}) {
    return AudioState(
      mediaItem: mediaItem,
      // positionStream: positionStream ?? this.positionStream,
      // playerStateStream: playerStateStream ?? this.playerStateStream,
      isPlaying: isPlaying ?? this.isPlaying,
      currentMediaItemStream:
          currentMediaItemStream ?? this.currentMediaItemStream,
      playbackStateStream: playbackStateStream ?? this.playbackStateStream,
      positionStream: positionStream ?? this.positionStream,
    );
  }
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

// class AudioPlayerTask extends BackgroundAudioTask {
//   final _audioPlayer = AudioPlayer();
//   late String songUrl;

//   @override
//   Future<void> onStart(Map<String, dynamic>? params) async {
//     songUrl = params?['media'];
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       MediaAction.seekTo
//     ], playing: true, processingState: AudioProcessingState.connecting);
//     // Connect to the URL
//     await _audioPlayer.setUrl(songUrl);
//     AudioServiceBackground.setMediaItem(songUrl);
//     // Now we're ready to play
//     _audioPlayer.play();
//     // Broadcast that we're playing, and what controls are available.
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       MediaAction.seekTo
//     ], playing: true, processingState: AudioProcessingState.ready);
//   }

//   @override
//   Future<void> onStop() async {
//     AudioServiceBackground.setState(
//         controls: [],
//         playing: false,
//         processingState: AudioProcessingState.ready);
//     await _audioPlayer.stop();
//     await super.onStop();
//   }

//   @override
//   Future<void> onPlay() async {
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       MediaAction.seekTo
//     ], playing: true, processingState: AudioProcessingState.ready);
//     await _audioPlayer.play();
//     return super.onPlay();
//   }

//   @override
//   Future<void> onPause() async {
//     AudioServiceBackground.setState(controls: [
//       MediaControl.play,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       MediaAction.seekTo
//     ], playing: false, processingState: AudioProcessingState.ready);
//     await _audioPlayer.pause();
//     return super.onPause();
//   }

//   @override
//   Future<void> onSkipToNext() async {
//     // if (current < songList.length - 1)
//     //   current = current + 1;
//     // else
//     //   current = 0;
//     // mediaItem = MediaItem(
//     //     id: songList[current].url,
//     //     title: songList[current].name,
//     //     artUri: Uri.parse(songList[current].icon),
//     //     album: songList[current].album,
//     //     duration: songList[current].duration,
//     //     artist: songList[current].artist);
//     // AudioServiceBackground.setMediaItem(mediaItem);
//     // await _audioPlayer.setUrl(mediaItem.id);
//     // AudioServiceBackground.setState(position: Duration.zero);
//     return super.onSkipToNext();
//   }

//   @override
//   Future<void> onSkipToPrevious() async {
//     // if (current != 0)
//     //   current = current - 1;
//     // else
//     //   current = songList.length - 1;
//     // mediaItem = MediaItem(
//     //     id: songList[current].url,
//     //     title: songList[current].name,
//     //     artUri: Uri.parse(songList[current].icon),
//     //     album: songList[current].album,
//     //     duration: songList[current].duration,
//     //     artist: songList[current].artist);
//     // AudioServiceBackground.setMediaItem(mediaItem);
//     // await _audioPlayer.setUrl(mediaItem.id);
//     // AudioServiceBackground.setState(position: Duration.zero);
//     return super.onSkipToPrevious();
//   }

//   @override
//   Future<void> onSeekTo(Duration position) {
//     _audioPlayer.seek(position);
//     AudioServiceBackground.setState(position: position);
//     return super.onSeekTo(position);
//   }
// }

class AudioPlayerTask extends BackgroundAudioTask {
  // final List<MediaItem> _queue = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  // late AudioSession _session;
  // late AudioProcessingState _skipState;
  // late bool _playing;
  // bool _interrupted = false;
  // late bool _stopAtEnd;
  // late int _cacheMax;
  // int _index = 0;
  // late bool _isQueue;
  // bool get hasNext => _queue.length > 0;
  late String _songUrl;
  // MediaItem get mediaItem => hasNext ? _queue[_index] : null;

  // late StreamSubscription<PlayerState> _playerStateSubscription;
  // late StreamSubscription<PlaybackEvent> _eventSubscription;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    // AudioServiceBackground.androidForceEnableMediaButtons();
    AudioServiceBackground.setState(controls: [
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,
      MediaControl.skipToPrevious
    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.connecting);
    print("${params?['mediaI']}");
    _songUrl = params?['mediaI'];
    print(" trying to  set: $_songUrl");
    AudioServiceBackground.setMediaItem(MediaItem(
        id: _songUrl, album: "Some album", title: "na vatta lo song"));
    await _audioPlayer.setUrl(_songUrl);
    print(" url is set: $_songUrl");
    return super.onStart(params);
  }

  @override
  Future<void> onSkipToNext() {
    // TODO: implement onSkipToNext
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    // TODO: implement onSkipToPrevious
    return super.onSkipToPrevious();
  }

  @override
  Future<void> onPlay() async {
    await _audioPlayer.play();
    print("audio is playing");
    AudioServiceBackground.setState(controls: [
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,
      MediaControl.skipToPrevious
    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.ready);
    return super.onPlay();
  }

  @override
  Future<void> onStop() {
    _audioPlayer.stop();
    AudioServiceBackground.setState(
        controls: [],
        systemActions: [],
        playing: false,
        processingState: AudioProcessingState.stopped);
    return super.onStop();
  }

  @override
  Future<void> onPause() {
    _audioPlayer.pause();
    AudioServiceBackground.setState(controls: [
      MediaControl.play,
      MediaControl.stop,
      MediaControl.skipToNext,
      MediaControl.skipToPrevious
    ], systemActions: [
      MediaAction.seekTo
    ], playing: false, processingState: AudioProcessingState.ready);

    return super.onPause();
  }
}
