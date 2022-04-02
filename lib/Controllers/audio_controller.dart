import 'dart:async';

import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/DataModels/song.dart';

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier(ref);
});

Future<MyAudioHandler> initAudioService() async {
  var s = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  print(" audio service is inited");
  return s;
}

class AudioStateNotifier extends StateNotifier<AudioState> {
  final ref;
  AudioStateNotifier(this.ref) : super(AudioState.initial()) {
    initAudioService().then((value) => _audioHandler = value);
  }

  late final MyAudioHandler _audioHandler;

  requestPlayingSong(Song song) async {
    await _loadSong(song);
  }

  Future<void> _loadSong(Song song) async {
    // final mediaItem = MediaItem(
    //   id: '',
    //   album: song.album,
    //   title: song.name,
    //   artUri: Uri.parse(song.icon),
    //   extras: {'url': song.url},
    // );
    await _audioHandler.prepareForPlaying(song);

    _audioHandler.play();
    state = state.copyWith(
      isPlaying: true,
      isPlayerShow: true,
      positionStream: AudioService.position,
      audioHandler: _audioHandler,
    );
  }

  // Function to call from UI to resume playing.
  void resume() => _audioHandler.play();

  //Function to cal from UI to pause playing.
  void pause() => _audioHandler.pause();

  //Function to call from UI to stop playing.
  void stop() {
    _audioHandler.stop();
    state = state.copyWith(
      isPlayerShow: false,
      isPlaying: false,
    );
  }

  //Function to call from UI to fast forward 10 seconds .
  void fastForward() => _audioHandler.fastForward();

  //Function to call from UI to reqind 10 seconds .
  void rewind() => _audioHandler.rewind();

  // Function to call from UI to seek to a position.
  void seekTo(Duration position) => _audioHandler.seek(position);
}

class AudioState {
  // final Stream<Duration> positionStream;
  // final Stream<PlayerState> playerStateStream;
  final bool isPlaying;
  final bool isPlayerShow;
  final AudioHandler audioHandler;
  final Stream<Duration> positionStream;
  AudioState({
    // required this.positionStream,
    // required this.playerStateStream,
    required this.audioHandler,
    required this.isPlaying,
    required this.isPlayerShow,
    required this.positionStream,
  });
  factory AudioState.initial() {
    return AudioState(
      // positionStream: _audioPlayer.positionStream,
      // playerStateStream: _audioPlayer.playerStateStream,
      isPlaying: false,
      audioHandler: MyAudioHandler(),
      isPlayerShow: false,
      positionStream: AudioService.position,
    );
  }
  AudioState copyWith({
    bool? isPlayerShow,
    bool? isPlaying,
    AudioHandler? audioHandler,
    Stream<Duration>? positionStream,
  }) {
    return AudioState(
      audioHandler: audioHandler ?? this.audioHandler,
      isPlayerShow: isPlayerShow ?? this.isPlayerShow,
      isPlaying: isPlaying ?? this.isPlaying,
      positionStream: positionStream ?? this.positionStream,
    );
  }
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  Future<void> prepareForPlaying(Song song) async {
    final _m = MediaItem(
      id: '',
      album: song.album,
      title: song.name,
      duration: song.duration,
      artUri: Uri.parse(song.icon),
      extras: {'url': song.url},
    );
    mediaItem.add(_m);
    _player.setAudioSource(AudioSource.uri(Uri.parse(song.url)));
    // ... and also the current media item via mediaItem.
  }

  void notifyAudioHandlerAboutPlaybackEvents() {
    print(" in here to set playback events");
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
            MediaControl.skipToNext,
          ],
          systemActions: const {
            MediaAction.seek,
          },
          // androidCompactActionIndices: const [0, 1, 3],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          repeatMode: const {
            LoopMode.off: AudioServiceRepeatMode.none,
            LoopMode.one: AudioServiceRepeatMode.one,
            LoopMode.all: AudioServiceRepeatMode.all,
          }[_player.loopMode]!,
          shuffleMode: (_player.shuffleModeEnabled)
              ? AudioServiceShuffleMode.all
              : AudioServiceShuffleMode.none,
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
    print(" done setting up playback events");
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration d) => _player.seek(d);

  @override
  Future<void> rewind() async {
    print(" this is called <- seek backward");

    Duration curr = _player.position;
    print(" curr is : ${curr.inSeconds}");
    Duration newDur = curr.inSeconds > 10
        ? Duration(seconds: curr.inSeconds - 10)
        : Duration(seconds: 0);
    _player.seek(newDur);

    return super.rewind();
  }

  @override
  Future<void> fastForward() async {
    print(" this is called -> seek forward");

    if (mediaItem.value != null && mediaItem.value!.duration != null) {
      Duration curr = _player.position;
      print(" curr is : ${curr.inSeconds}");
      Duration newDur =
          curr.inSeconds < mediaItem.value!.duration!.inSeconds - 10
              ? Duration(seconds: curr.inSeconds + 10)
              : Duration(seconds: mediaItem.value!.duration!.inSeconds);
      _player.seek(newDur);
    }

    return super.fastForward();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
