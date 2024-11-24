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
  List<Song> _playlist = [];
  // debounce throttle
  var throttle = false;

  AudioStateNotifier(this.ref) : super(InitialAudioState()) {}

  // ** Function to call from UI to add a song to the queue (plays the song if queue is empty)
  Future<void> requestAddingToQueue(Song song) async {
    if (state is InitialAudioState && _playlist.isEmpty) {
      print(" directly playing stuff.");
      requestPlayingSong(song);
      return;
    }
    print(" adding to queue");
    _playlist.add(song);
  }

  //**  Function to call from UI to play a song
  Future<void> requestPlayingSong(Song song) async {
    print(" new play request for : ${song.name}");
    // Emit a loading state.
    state = LoadingAudioState(song: song);

    _player ??= AudioPlayer();

    _player!.processingStateStream.listen((ProcessingState pState) {
      print(" new pstate : $pState");
      if (pState == ProcessingState.completed && !throttle) {
        throttle = true;
        Future.delayed(Duration(milliseconds: 500), () {
          throttle = false;
        });
        if (_playlist.isNotEmpty) {
          print(" Playing next item on the queue");
          // play the next item in the queue and remove it from the queue.
          var nextItem = _playlist.removeAt(0);
          print(" next item is : ${nextItem.name}");
          requestPlayingSong(nextItem);
        }
        print(" no more items in the queue to play");
      }
    });

    Duration? epDur;

    try {
      epDur = await _player?.setAudioSource(
        AudioSource.uri(
          Uri.parse(song.url),
          tag: MediaItem(
            id: song.url,
            album: song.album,
            title: song.name,
            artUri: Uri.parse(song.icon),
            duration: song.duration,
          ),
        ),
      );

      _player!.play();

      var posStream =
          Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player!.positionStream,
        _player!.bufferedPositionStream,
        _player!.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

      // Listen to errors during playback.
      _player!.playbackEventStream.listen((PlaybackEvent event) {},
          onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      });

      state = LoadedAudioState(
        positionStream: posStream.asBroadcastStream(),
        player: _player!,
        processingStateStream: _player!.processingStateStream,
        playlist: _playlist,
        episodeDuration: epDur!,
        currentPlaying: song,
      );
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
      state = ErrorAudioState(errorMessage: e.toString());
    }
  }

  Future<void> fastForward() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;

    var currentPos = _player?.position.inSeconds;

    if (currentPos == null) return;

    await _player?.seek(Duration(seconds: currentPos + 30));
  }

  Future<void> rewind() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;

    var currentPos = _player?.position.inSeconds;

    if (currentPos == null) return;

    await _player
        ?.seek(Duration(seconds: (currentPos - 30) < 0 ? 0 : currentPos - 30));
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex == newIndex || throttle) return;

    Future.delayed(Duration(milliseconds: 200), () {
      throttle = false;
    });

    // move the item to new index, shift the rest of the items accordingly
    if (oldIndex < newIndex) {
      newIndex--;
      _playlist.insert(newIndex, _playlist.removeAt(oldIndex));
    } else {
      _playlist.insert(newIndex, _playlist.removeAt(oldIndex));
    }
  }

  void removeFromQueue(int index) {
    _playlist.removeAt(index);
  }

  Future<void> skipToSpecificIndex(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    print(" length of playlist befoire skip : ${_playlist.length}");
    var itemAtIndex = _playlist.removeAt(index);
    if (state is LoadedAudioState) {
      await _player?.pause();
      _playlist.insert(0, (state as LoadedAudioState).currentPlaying);
    } else if (state is LoadingAudioState) {
      await _player?.pause();
      _playlist.insert(0, (state as LoadingAudioState).song);
    }
    print(" length of playlist after skip : ${_playlist.length}");
    requestPlayingSong(itemAtIndex);
  }
}

abstract class AudioState {}

class InitialAudioState extends AudioState {}

class LoadingAudioState extends AudioState {
  final Song song;
  LoadingAudioState({required this.song});
}

class ErrorAudioState extends AudioState {
  String errorMessage;

  ErrorAudioState({required this.errorMessage});
}

class LoadedAudioState extends AudioState {
  Stream<PositionData> positionStream;
  AudioPlayer player;
  Stream<ProcessingState> processingStateStream;
  List<Song> playlist;
  Duration episodeDuration;
  Song currentPlaying;

  LoadedAudioState({
    required this.positionStream,
    required this.player,
    required this.processingStateStream,
    required this.playlist,
    required this.episodeDuration,
    required this.currentPlaying,
  });
}
