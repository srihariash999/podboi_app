import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:rxdart/rxdart.dart';

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier(ref);
});

class AudioStateNotifier extends StateNotifier<AudioState> {
  final ref;

  AudioPlayer? _player;
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);
  int nextMediaId = 0;
  int addedCount = 0;

  Stream<PositionData>? get _positionDataStream =>
      _player?.positionStream != null &&
              _player?.bufferedPositionStream != null &&
              _player?.durationStream != null
          ? Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
              _player!.positionStream,
              _player!.bufferedPositionStream,
              _player!.durationStream,
              (position, bufferedPosition, duration) => PositionData(
                  position, bufferedPosition, duration ?? Duration.zero))
          : null;

  AudioStateNotifier(this.ref) : super(AudioState.initial()) {}

  // ** Function to call from UI to add a song to the queue (plays the song if queue is empty)
  Future<void> requestAddingToQueue(Song song) async {
    if (_playlist.length == 0) {
      requestPlayingSong(song);
      return;
    }

    _playlist.add(
      AudioSource.uri(
        Uri.parse(song.url),
        tag: MediaItem(
          id: '${nextMediaId++}',
          album: song.album,
          title: song.name,
          artUri: Uri.parse(song.icon),
          duration: song.duration,
        ),
      ),
    );
  }

  //**  Function to call from UI to play a song
  Future<void> requestPlayingSong(Song song) async {
    state = state.copyWith(isPlayerShow: true, isPlaying: true);

    _player ??= AudioPlayer();

    _playlist.insert(
      0,
      AudioSource.uri(
        Uri.parse(song.url),
        tag: MediaItem(
          id: '${nextMediaId++}',
          album: song.album,
          title: song.name,
          artUri: Uri.parse(song.icon),
          duration: song.duration,
        ),
      ),
    );

    // Listen to errors during playback.
    _player?.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    bool _hasReachedEnd = false;

    _player?.positionStream.listen((position) {
      // Check if the current position is at or beyond the episode's end
      if (position.inSeconds >= _player!.duration!.inSeconds &&
          !_hasReachedEnd) {
        _hasReachedEnd = true; // Set the flag to prevent further triggers
        print("Reached end of episode.");

        // Handle the end of the current episode and move to the next
        if (_playlist.length >= 1) {
          print("One or more episodes in queue, removing the first one");
          _playlist.removeAt(0);
        }

        // Check if there are more episodes to play
        if (_playlist.length == 0) {
          print("No more episodes in queue");
          state = state.copyWith(isPlayerShow: false, playlist: null);
        } else {
          print("Playing next episode");
          state = state.copyWith(playlist: _playlist.children);
          _hasReachedEnd = false; // Reset the flag when next episode starts
        }
      }

      // Reset the flag when not at the end, allowing for the next episode's end to be detected
      if (position.inSeconds < _player!.duration!.inSeconds) {
        _hasReachedEnd = false;
      }
    });

    // _player?.positionStream.listen(
    //   (position) {
    //     if (position.inSeconds >= _player!.duration!.inSeconds) {
    //       print(" reached end of episode.");
    //       if (_playlist.length >= 1) {
    //         print(" one or more episodes in queue, removing the first one");
    //         _playlist.removeAt(0);
    //       }

    //       if (_playlist.length == 0) {
    //         print(" no more episodes in queue");
    //         state = state.copyWith(isPlayerShow: false, playlist: null);
    //       } else {
    //         print(" playing next episode");
    //         state = state.copyWith(playlist: _playlist.children);
    //       }
    //     }
    //   },
    // );

    try {
      await _player?.setAudioSource(_playlist);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }

    _player!.play();
    state = state.copyWith(
      isPlayerShow: true,
      isPlaying: true,
      stream: _positionDataStream?.asBroadcastStream(),
      player: _player,
      currentPlaying: song,
      playlist: _playlist.children,
    );
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex == 0 || newIndex == 0) return;

    if (oldIndex < newIndex) newIndex--;
    _playlist.move(oldIndex, newIndex);
  }

  void removeFromQueue(int index) {
    _playlist.removeAt(index);
  }

  Future<void> skipToSpecificIndex(int index) async {
    // Augment playlist to have the selected index at the top
    // Push rest of the items including the current playing by one.
    // Play the item at the top.
    var itemAtIndex = _playlist.sequence[index];
    await _playlist.removeAt(index);
    await _playlist.insert(0, itemAtIndex);
    _player!.seek(Duration.zero, index: 0);
  }
}

class AudioState {
  final bool isPlaying;
  final bool isPlayerShow;
  final Stream<PositionData>? stream;
  final AudioPlayer? player;
  final Song? currentPlaying;
  List<AudioSource>? playlist;
  AudioState({
    required this.isPlaying,
    required this.isPlayerShow,
    required this.stream,
    required this.player,
    this.currentPlaying,
    this.playlist,
  });
  factory AudioState.initial() {
    return AudioState(
      isPlaying: false,
      isPlayerShow: false,
      stream: null,
      player: null,
      playlist: null,
    );
  }
  AudioState copyWith({
    bool? isPlayerShow,
    bool? isPlaying,
    Stream<PositionData>? stream,
    AudioPlayer? player,
    Song? currentPlaying,
    List<AudioSource>? playlist,
  }) {
    return AudioState(
      isPlayerShow: isPlayerShow ?? this.isPlayerShow,
      isPlaying: isPlaying ?? this.isPlaying,
      stream: stream ?? this.stream,
      player: player ?? this.player,
      currentPlaying: currentPlaying ?? this.currentPlaying,
      playlist: playlist ?? this.playlist,
    );
  }
}


// import 'dart:async';
// import 'package:audio_service/audio_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:podboi/DataModels/song.dart';
// import 'package:podboi/Services/database/database.dart';

// final audioController =
//     StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
//   return AudioStateNotifier(ref);
// });

// Future<MyAudioHandler> initAudioService(var ref) async {
//   var s = await AudioService.init(
//     builder: () => MyAudioHandler(ref),
//     config: AudioServiceConfig(
//       androidNotificationChannelId: 'com.zepplaud.podboi.audio',
//       androidNotificationChannelName: 'Podboi Audio Service',
//       androidNotificationOngoing: true,
//       androidStopForegroundOnPause: true,
//     ),
//   );
//   print(" audio service is inited");
//   return s;
// }

// class AudioStateNotifier extends StateNotifier<AudioState> {
//   final ref;
//   AudioStateNotifier(this.ref) : super(AudioState.initial()) {
//     initAudioService(this.ref).then((value) => _audioHandler = value);
//   }

//   late final MyAudioHandler _audioHandler;

//   Future<void> requestPlayingSong(Song song, EpisodeData? episodeData) async {
//     await _loadSong(song, episodeData);
//     if (episodeData != null) {
//       List<EpisodeData> p = state.playlist ?? [];
//       p.add(episodeData);
//       state = state.copyWith(playlist: p);
//     }
//   }

//   Future<void> requestAddingSongToPlaylist(
//       Song song, EpisodeData? episodeData) async {
//     await _audioHandler.prepareToAddInPlaylist(song);
//     if (episodeData != null) {
//       List<EpisodeData> p = state.playlist ?? [];
//       p.add(episodeData);
//       state = state.copyWith(playlist: p);
//     }
//   }

//   Future<void> _loadSong(Song song, EpisodeData? episodeData) async {
//     // final mediaItem = MediaItem(
//     //   id: '',
//     //   album: song.album,
//     //   title: song.name,
//     //   artUri: Uri.parse(song.icon),
//     //   extras: {'url': song.url},
//     // );
//     state = state.copyWith(
//       playerState: false,
//       isPlayerShow: true,
//       isPlaying: true,
//       episodeData: episodeData ?? null,
//     );

//     var _stream = await _audioHandler.prepareForPlaying(song);

//     _stream.listen((pst) {
//       print(" player state : $pst");
//       final processingState = pst.processingState;
//       if (processingState == ProcessingState.loading ||
//           processingState == ProcessingState.buffering) {
//         state = state.copyWith(playerState: false);
//       } else {
//         state = state.copyWith(playerState: true);
//       }
//     });
//     state = state.copyWith(
//       isPlaying: true,
//       isPlayerShow: true,
//       positionStream: AudioService.position,
//       audioHandler: _audioHandler,
//     );

//     try {
//       await _audioHandler.play();
//     } catch (e) {
//       print(" cannot play this file !");
//     }

//     state = state.copyWith(
//       isPlaying: true,
//       isPlayerShow: true,
//       positionStream: AudioService.position,
//       audioHandler: _audioHandler,
//     );
//   }

//   // Function to call from UI to resume playing.
//   void resume() async {
//     await _audioHandler.play();
//   }

//   //Function to cal from UI to pause playing.
//   void pause() async {
//     await _audioHandler.pause();
//   }

//   //Function to call from UI to stop playing.
//   void stop() async {
//     await _audioHandler.stop();
//     state = state.copyWith(
//       isPlayerShow: false,
//       isPlaying: false,
//       episodeData: null,
//     );
//   }

//   void callBackToStopFromNotification() {
//     print(" inside the callbalc");
//     state = state.copyWith(
//       isPlayerShow: false,
//       isPlaying: false,
//       episodeData: null,
//     );
//   }

//   //Function to call from UI to fast forward 10 seconds .
//   void fastForward() => _audioHandler.fastForward();

//   //Function to call from UI to reqind 10 seconds .
//   void rewind() => _audioHandler.rewind();

//   // Function to call from UI to seek to a position.
//   void seekTo(Duration position) => _audioHandler.seek(position);
// }

// class AudioState {
//   // final Stream<Duration> positionStream;
//   // final Stream<PlayerState> playerStateStream;
//   final bool isPlaying;
//   final bool isPlayerShow;
//   final AudioHandler audioHandler;
//   final Stream<Duration> positionStream;
//   final bool playerState;
//   final EpisodeData? episodeData;
//   final List<EpisodeData>? playlist;
//   final int? currentIndex;

//   AudioState({
//     required this.audioHandler,
//     required this.isPlaying,
//     required this.isPlayerShow,
//     required this.positionStream,
//     required this.playerState,
//     required this.episodeData,
//     required this.playlist,
//     required this.currentIndex,
//   });
//   factory AudioState.initial() {
//     return AudioState(
//       isPlaying: false,
//       audioHandler: MyAudioHandler(null),
//       isPlayerShow: false,
//       positionStream: AudioService.position,
//       playerState: false,
//       episodeData: null,
//       playlist: null,
//       currentIndex: null,
//     );
//   }
//   AudioState copyWith({
//     bool? isPlayerShow,
//     bool? isPlaying,
//     AudioHandler? audioHandler,
//     Stream<Duration>? positionStream,
//     bool? playerState,
//     EpisodeData? episodeData,
//     List<EpisodeData>? playlist,
//     int? currentIndex,
//   }) {
//     return AudioState(
//       audioHandler: audioHandler ?? this.audioHandler,
//       isPlayerShow: isPlayerShow ?? this.isPlayerShow,
//       isPlaying: isPlaying ?? this.isPlaying,
//       positionStream: positionStream ?? this.positionStream,
//       playerState: playerState ?? this.playerState,
//       episodeData: episodeData ?? this.episodeData,
//       playlist: playlist ?? this.playlist,
//       currentIndex: currentIndex ?? this.currentIndex,
//     );
//   }
// }

// class MyAudioHandler extends BaseAudioHandler {
//   final _player = AudioPlayer();

//   // Define the playlist
//   final _playlist = ConcatenatingAudioSource(
//     // Start loading next item just before reaching it
//     useLazyPreparation: true,
//     // Customise the shuffle algorithm
//     shuffleOrder: DefaultShuffleOrder(),
//     // Specify the playlist items
//     children: [],
//   );

//   final StateNotifierProviderRef? ref;

//   MyAudioHandler(this.ref) {
//     // So that our clients (the Flutter UI and the system notification) know
//     // what state to display, here we set up our audio handler to broadcast all
//     // playback state changes as they happen via playbackState...
//     _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

//     _player.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         _player.stop();
//         ref?.read(audioController.notifier).stop();
//       }
//     });
//   }

//   Future<Stream<PlayerState>> prepareForPlaying(Song song) async {
//     try {
//       final _m = MediaItem(
//         id: '',
//         album: song.album,
//         title: song.name,
//         duration: song.duration,
//         artUri: Uri.parse(song.icon),
//         extras: {'url': song.url},
//       );
//       mediaItem.add(_m);

//       _playlist.add(AudioSource.uri(Uri.parse(song.url)));
//       _player.setAudioSource(_playlist).then((value) => mediaItem.add(_m));
//     } catch (e) {
//       print(" error y'aaaaallll  ");
//     }

//     return _player.playerStateStream.asBroadcastStream();
//   }

//   Future<void> prepareToAddInPlaylist(Song song, {bool unshift = false}) async {
//     try {
//       final _m = MediaItem(
//         id: '',
//         album: song.album,
//         title: song.name,
//         duration: song.duration,
//         artUri: Uri.parse(song.icon),
//         extras: {'url': song.url},
//       );
//       mediaItem.add(_m);

//       _playlist.add(AudioSource.uri(Uri.parse(song.url)));
//     } catch (e) {
//       print(" error y'aaaaallll  ");
//     }
//   }

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> stop() {
//     print(" here to call the callback");
//     ref?.read(audioController.notifier).callBackToStopFromNotification();
//     // _playlist.clear();
//     return _player.stop();
//   }

//   @override
//   Future<void> seek(Duration d) => _player.seek(d);

//   @override
//   Future<void> rewind() async {
//     print(" this is called <- seek backward");

//     Duration curr = _player.position;
//     print(" curr is : ${curr.inSeconds}");
//     Duration newDur = curr.inSeconds > 10
//         ? Duration(seconds: curr.inSeconds - 10)
//         : Duration(seconds: 0);
//     _player.seek(newDur);

//     return super.rewind();
//   }

//   @override
//   Future<void> fastForward() async {
//     print(" this is called -> seek forward");

//     if (mediaItem.value != null && mediaItem.value!.duration != null) {
//       Duration curr = _player.position;
//       print(" curr is : ${curr.inSeconds}");
//       if (curr.inSeconds < mediaItem.value!.duration!.inSeconds - 10) {
//         Duration newDur = Duration(seconds: curr.inSeconds + 10);
//         _player.seek(newDur);
//       } else {
//         _player.stop();
//       }
//     }

//     return super.fastForward();
//   }

//   PlaybackState _transformEvent(PlaybackEvent event) {
//     return PlaybackState(
//       controls: [
//         MediaControl.rewind,
//         if (_player.playing) MediaControl.pause else MediaControl.play,
//         MediaControl.stop,
//         MediaControl.fastForward,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: const {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[_player.processingState]!,
//       playing: _player.playing,
//       updatePosition: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//       queueIndex: event.currentIndex,
//     );
//   }
// }
