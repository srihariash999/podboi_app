import 'dart:async';

import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/misc/database.dart';
import 'package:rxdart/streams.dart';

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier(ref);
});

class AudioStateNotifier extends StateNotifier<AudioState> {
  final ref;
  AudioStateNotifier(this.ref) : super(AudioState.initial()) {
    // _mainRef = ref;
  }

  playAction(Song song) async {
    // current = id;

    if (AudioService.running) {
      print(" it is running");
      await AudioService.stop();
      await AudioService.start(
          backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
          androidNotificationChannelName: 'Podboi',
          params: {
            'songUrl': song.url,
            'albumArt': song.icon,
            'name': song.name,
            'album': song.album,
            'artist': song.artist,
            'duration': song.duration?.inSeconds
          },
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
        playbackStateStream: AudioService.playbackStateStream,
        positionStream: AudioService.positionStream,
        mediaItem: MediaItem(
            id: song.url,
            title: song.name,
            artUri: Uri.parse(song.icon),
            album: song.album,
            duration: song.duration,
            artist: song.artist),
      );
      state.playbackStateStream.listen((PlaybackState event) {
        print(" new event yo : $event");
        if (event.playing) {
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
      });
    } else {
      print(" fresh init");
      await AudioService.connect();

      await AudioService.start(
          backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
          androidNotificationChannelName: 'Podboi',
          params: {
            'songUrl': song.url,
            'albumArt': song.icon,
            'name': song.name,
            'album': song.album,
            'artist': song.artist,
            'duration': song.duration?.inSeconds
          },
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
      state.playbackStateStream.listen((PlaybackState event) {
        print(" new event yo : $event");
        if (event.playing) {
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
      });
    }
  }

  resumeAction() async {
    await AudioService.play();
  }

  pauseAction() async {
    await AudioService.pause();
    print(" pause called <_____________________>");
  }

  stopAction() async {
    await AudioService.stop();
    state = state.copyWith(isPlaying: false);
  }

  seekTo(double val) {
    AudioService.seekTo(Duration(seconds: val.toInt()));
  }

  rewind() async {
    AudioService.rewind();
  }

  fastForward() async {
    AudioService.fastForward();
  }
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

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();
  // late ProviderRefBase _mainRef;
  late MediaItem _mediaItem;
  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    AudioServiceBackground.setState(
      controls: [
        MediaControl.rewind,
        MediaControl.pause,
        MediaControl.fastForward,
      ],
      systemActions: [MediaAction.seekBackward, MediaAction.seekForward],
      playing: true,
      processingState: AudioProcessingState.connecting,
    );
    // Connect to the URL
    _mediaItem = MediaItem(
      id: params!['songUrl'],
      title: params['name'],
      artUri: Uri.parse(params['albumArt']),
      album: params['album'],
      duration: Duration(seconds: params['duration']),
      artist: params['artist'],
    );
    // _mainRef = params['ref'];
    await _audioPlayer.setUrl(_mediaItem.id);
    AudioServiceBackground.setMediaItem(_mediaItem);
    // Now we're ready to play
    _audioPlayer.play();
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(
      controls: [
        MediaControl.rewind,
        MediaControl.pause,
        MediaControl.fastForward,
      ],
      systemActions: [MediaAction.seekBackward, MediaAction.seekForward],
      playing: true,
      processingState: AudioProcessingState.ready,
    );
  }

  @override
  Future<void> onRewind() async {
    print(" this is called <- seek backward");

    Duration curr = _audioPlayer.position;
    print(" curr is : ${curr.inSeconds}");
    Duration newDur = curr.inSeconds > 10
        ? Duration(seconds: curr.inSeconds - 10)
        : Duration(seconds: 0);
     _audioPlayer.seek(newDur);
    AudioServiceBackground.setState(position: newDur);

    return super.onRewind();
  }

  @override
  Future<void> onFastForward() async {
    print(" this is called -> seek forward");

    Duration curr = _audioPlayer.position;
    print(" curr is : ${curr.inSeconds}");
    Duration newDur = curr.inSeconds < _mediaItem.duration!.inSeconds - 10
        ? Duration(seconds: curr.inSeconds + 10)
        : Duration(seconds: _mediaItem.duration!.inSeconds);
     _audioPlayer.seek(newDur);
    AudioServiceBackground.setState(position: newDur);

    return super.onFastForward();
  }

  @override
  Future<void> onStop() async {
    AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.ready);
    await _audioPlayer.stop();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    AudioServiceBackground.setState(
      controls: [
        MediaControl.rewind,
        MediaControl.pause,
        MediaControl.fastForward,
      ],
      systemActions: [MediaAction.seekBackward, MediaAction.seekForward],
      playing: true,
      processingState: AudioProcessingState.ready,
    );
    await _audioPlayer.play();
    return super.onPlay();
  }

  @override
  Future<void> onPause() async {
    AudioServiceBackground.setState(
      controls: [
        MediaControl.rewind,
        MediaControl.play,
        MediaControl.fastForward,
      ],
      systemActions: [MediaAction.seekBackward, MediaAction.seekForward],
      playing: false,
      processingState: AudioProcessingState.ready,
    );
    await _audioPlayer.pause();
    // await _mainRef.read(audioController.notifier).pauseAction();
    return super.onPause();
  }

  @override
  Future<void> onSkipToNext() async {
    // if (current < songList.length - 1)
    //   current = current + 1;
    // else
    //   current = 0;
    // mediaItem = MediaItem(
    //     id: songList[current].url,
    //     title: songList[current].name,
    //     artUri: Uri.parse(songList[current].icon),
    //     album: songList[current].album,
    //     duration: songList[current].duration,
    //     artist: songList[current].artist);
    // AudioServiceBackground.setMediaItem(mediaItem);
    // await _audioPlayer.setUrl(mediaItem.id);
    // AudioServiceBackground.setState(position: Duration.zero);
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() async {
    // if (current != 0)
    //   current = current - 1;
    // else
    //   current = songList.length - 1;
    // mediaItem = MediaItem(
    //     id: songList[current].url,
    //     title: songList[current].name,
    //     artUri: Uri.parse(songList[current].icon),
    //     album: songList[current].album,
    //     duration: songList[current].duration,
    //     artist: songList[current].artist);
    // AudioServiceBackground.setMediaItem(mediaItem);
    // await _audioPlayer.setUrl(mediaItem.id);
    // AudioServiceBackground.setState(position: Duration.zero);
    return super.onSkipToPrevious();
  }

  @override
  Future<void> onSeekTo(Duration position) {
    _audioPlayer.seek(position);
    AudioServiceBackground.setState(position: position);
    return super.onSeekTo(position);
  }
}
