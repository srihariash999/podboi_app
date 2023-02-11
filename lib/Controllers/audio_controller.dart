import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/DataModels/song.dart';

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier(ref);
});

Future<MyAudioHandler> initAudioService(var ref) async {
  var s = await AudioService.init(
    builder: () => MyAudioHandler(ref),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.zepplaud.podboi.audio',
      androidNotificationChannelName: 'Podboi Audio Service',
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
    initAudioService(this.ref).then((value) => _audioHandler = value);
  }

  late final MyAudioHandler _audioHandler;

  requestPlayingSong(Song song) async {
    await _loadSong(song);
  }

  requestAddSongToEndOfPlaylist(Song song) async {
    // Add the requested song to end of playlist.
    state = state.copyWith(trackList: [...state.trackList, song]);

    if (state.trackList.length == 1 && state.isPlaying == false) {
      maybePlayNext();
    }
    // print(
    //     " added track to playlist. Length of playlist ${state.trackList.length}");
    // print(" name of the track added: ${song.name}");
  }

  Future _loadSong(Song song) async {
    // final mediaItem = MediaItem(
    //   id: '',
    //   album: song.album,
    //   title: song.name,
    //   artUri: Uri.parse(song.icon),
    //   extras: {'url': song.url},
    // );
    state = state.copyWith(
      playerState: false,
      isPlayerShow: true,
      isPlaying: true,
    );
    var _stream = await _audioHandler.prepareForPlaying(song);

    _stream.listen((pst) {
      print(" player state : $pst");
      final processingState = pst.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        state = state.copyWith(playerState: false);
      } else {
        state = state.copyWith(playerState: true);
      }
    });
    state = state.copyWith(
      isPlaying: true,
      isPlayerShow: true,
      positionStream: AudioService.position,
      audioHandler: _audioHandler,
    );

    try {
      await _audioHandler.play();
      state = state.copyWith(
        isPlaying: true,
        isPlayerShow: true,
        positionStream: AudioService.position,
        audioHandler: _audioHandler,
      );
    } catch (e) {
      print(" cannot play this file !");
      state = state.copyWith(isPlayerShow: false, isPlaying: false);
      return " cannot play this file !";
    }
  }

  void maybePlayNext() async {
    if (state.trackList.isNotEmpty) {
      // print(" track list length : ${state.trackList.length}");
      await stop();
      Song _song = state.trackList[0];
      _loadSong(_song);
      var l = [];
      for (var i = 1; i < state.trackList.length; i++) {
        l.add(i);
      }
      state = state.copyWith(trackList: [...l]);
      // print(" updated track list length : ${state.trackList.length}");
    } else {
      await stop();
    }
  }

  // Function to call from UI to resume playing.
  void resume() async {
    await _audioHandler.play();
  }

  //Function to cal from UI to pause playing.
  void pause() async {
    await _audioHandler.pause();
  }

  //Function to call from UI to stop playing.
  Future<void> stop() async {
    await _audioHandler.stop();
    state = state.copyWith(
      isPlayerShow: false,
      isPlaying: false,
    );
  }

  void callBackToStopFromNotification() {
    print(" inside the callbalc");
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
  final bool playerState;
  final List<Song> trackList;
  AudioState({
    required this.audioHandler,
    required this.isPlaying,
    required this.isPlayerShow,
    required this.positionStream,
    required this.playerState,
    required this.trackList,
  });
  factory AudioState.initial() {
    return AudioState(
        isPlaying: false,
        audioHandler: MyAudioHandler(null),
        isPlayerShow: false,
        positionStream: AudioService.position,
        playerState: false,
        trackList: []);
  }
  AudioState copyWith({
    bool? isPlayerShow,
    bool? isPlaying,
    AudioHandler? audioHandler,
    Stream<Duration>? positionStream,
    bool? playerState,
    List<Song>? trackList,
  }) {
    return AudioState(
      audioHandler: audioHandler ?? this.audioHandler,
      isPlayerShow: isPlayerShow ?? this.isPlayerShow,
      isPlaying: isPlaying ?? this.isPlaying,
      positionStream: positionStream ?? this.positionStream,
      playerState: playerState ?? this.playerState,
      trackList: trackList ?? this.trackList,
    );
  }
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  final StateNotifierProviderRef? ref;

  MyAudioHandler(this.ref) {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (ref == null) {
          _player.stop();
          return;
        }
        ref!.read(audioController.notifier).maybePlayNext();
        // ref?.read(audioController.notifier).stop();
      }
    });
  }

  Future<Stream<PlayerState>> prepareForPlaying(Song song) async {
    final _m = MediaItem(
      id: '',
      album: song.album,
      title: song.name,
      duration: song.duration,
      artUri: Uri.parse(song.icon),
      extras: {'url': song.url},
    );
    mediaItem.add(_m);
    try {
      await _player
          .setAudioSource(AudioSource.uri(Uri.parse(song.url)))
          .then((value) => mediaItem.add(_m));
    } catch (e) {
      print(" error y'aaaaallll  : $e");
    }

    return _player.playerStateStream.asBroadcastStream();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() {
    // print(" here to call the callback");
    ref?.read(audioController.notifier).callBackToStopFromNotification();
    return _player.stop();
  }

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
      if (curr.inSeconds < mediaItem.value!.duration!.inSeconds - 10) {
        Duration newDur = Duration(seconds: curr.inSeconds + 10);
        _player.seek(newDur);
      } else {
        _player.stop();
      }
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
