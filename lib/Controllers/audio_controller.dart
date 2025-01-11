import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Services/database/playback_cache_controller.dart';
import 'package:podboi/Services/database/podcast_episode_box_controller.dart';
import 'package:rxdart/rxdart.dart';

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier(ref);
});

class AudioStateNotifier extends StateNotifier<AudioState> {
  final ref;

  List<Song> _playlist = [];
  AudioPlayer? _player;
  // debounce throttle
  var throttle = false;
  var playbackCacheThrottle = false;

  AudioStateNotifier(this.ref) : super(InitialAudioState()) {
    getLastSavedPlaybackPosition().then((pos) {
      if (pos != null) {
        requestPlayingSong(
          pos.song,
          initialPosition: pos.duration,
          pauseOnLoad: true,
        );
      }
    });

    getLastSavedPlaybackQueue().then((queue) {
      if (queue != null) {
        _playlist = queue;
      }
    });
  }

  Future<CachedPlaybackState?> getLastSavedPlaybackPosition() async {
    var pos = await PlaybackCacheController.getLastSavedPlaybackPosition();

    print(
        " last saved playback position : ${pos?.duration} , ${pos?.song.name}");

    return pos;
  }

  Future<List<Song>?> getLastSavedPlaybackQueue() async {
    var queue = await PlaybackCacheController.getLastSavedPlaybackQueue();

    print(" last saved playback queue : ${queue?.length}");

    return queue;
  }

  // ** Function to call from UI to add a song to the queue (plays the song if queue is empty)
  Future<void> requestAddingToQueue(Song song) async {
    if (state is InitialAudioState && _playlist.isEmpty) {
      print(" directly playing stuff.");

      // get played duration of the next item
      var playedDuration = await PodcastEpisodeBoxController.getPlayedDuration(
          song.episodeData.guid, song.episodeData.podcastId);

      requestPlayingSong(song, initialPosition: playedDuration);
      return;
    }
    print(" adding to queue");
    _playlist.add(song);
    // save the queue to cache
    await PlaybackCacheController.storePlaybackQueue(_playlist);
  }

  Song? get getCurrentPlayingSong {
    if (state is LoadedAudioState) {
      return (state as LoadedAudioState).currentPlaying;
    } else if (state is LoadingAudioState) {
      return (state as LoadingAudioState).song;
    }

    return null;
  }

  //**  Function to call from UI to play a song
  Future<void> requestPlayingSong(Song song,
      {int? initialPosition, bool pauseOnLoad = false}) async {
    print(" new play request for : ${song.name}");
    print(" url is: ${song.url}");

    // Emit a loading state.
    state = LoadingAudioState(song: song, playlist: _playlist);

    _player ??= AudioPlayer();

    _player!.processingStateStream.listen((ProcessingState pState) async {
      if (pState == ProcessingState.completed && !throttle) {
        // Debounce the processing state callback.
        throttle = true;
        Future.delayed(Duration(milliseconds: 500), () {
          throttle = false;
        });

        var res = await PlaybackCacheController.clearSavedPlaybackPosition();
        print(" cleared saved playback position : $res");
        // If there are items in the queue, play the next item.
        if (_playlist.isNotEmpty) {
          print(" Playing next item on the queue");
          // remove the item from the queue and play it.
          var nextItem = _playlist.removeAt(0);
          print(" next item is : ${nextItem.name}");

          // get played duration of the next item
          var playedDuration =
              await PodcastEpisodeBoxController.getPlayedDuration(
                  nextItem.episodeData.guid, nextItem.episodeData.podcastId);

          requestPlayingSong(nextItem, initialPosition: playedDuration);
          // save the queue to cache
          await PlaybackCacheController.storePlaybackQueue(_playlist);
        }
        print(" no more items in the queue to play");
        await PlaybackCacheController.clearSavedPlaybackQueue();
      }
    });

    Duration? epDur;

    try {
      bool isInitPosToConsider = false;

      if (_player?.position.inSeconds != null &&
          _player?.position.inSeconds != 0 &&
          initialPosition != null &&
          initialPosition != 0 &&
          (initialPosition < (_player?.position.inSeconds ?? 0)) &&
          (_player?.position.inSeconds != null &&
              (initialPosition / _player!.position.inSeconds) < 0.99)) {
        isInitPosToConsider = true;
      }

      epDur = await _player?.setAudioSource(
        AudioSource.uri(
          Uri.parse(song.url),
          tag: MediaItem(
            id: song.url,
            album: song.album,
            title: song.name,
            artUri: Uri.parse(song.icon),
            duration: Duration(seconds: song.duration ?? 0),
          ),
        ),
        initialPosition: isInitPosToConsider
            ? Duration(seconds: initialPosition ?? 0)
            : null,
      );

      _player!.play();

      if (pauseOnLoad) {
        _player!.pause();
      }

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

      _player?.positionStream.asBroadcastStream().listen((positionData) async {
        if (getCurrentPlayingSong == null) return;

        Song song = getCurrentPlayingSong!;

        if (!playbackCacheThrottle) {
          playbackCacheThrottle = true;
          Future.delayed(Duration(seconds: 5)).then((value) {
            playbackCacheThrottle = false;
          });

          await PlaybackCacheController.storePlaybackPosition(
            positionData.inSeconds,
            song,
          );

          await PodcastEpisodeBoxController.storePlayedDuration(
            song.episodeData.guid,
            positionData.inSeconds,
            song.episodeData.podcastId,
          );
        }
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

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
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

    // save the queue to cache
    await PlaybackCacheController.storePlaybackQueue(_playlist);
  }

  Future<void> removeFromQueue(int index) async {
    _playlist.removeAt(index);
    // save the queue to cache
    await PlaybackCacheController.storePlaybackQueue(_playlist);
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

    // get played duration of the next item
    var playedDuration = await PodcastEpisodeBoxController.getPlayedDuration(
      itemAtIndex.episodeData.guid,
      itemAtIndex.episodeData.podcastId,
    );

    requestPlayingSong(itemAtIndex, initialPosition: playedDuration);

    // save the queue to cache
    await PlaybackCacheController.storePlaybackQueue(_playlist);
  }
}

abstract class AudioState {}

class InitialAudioState extends AudioState {}

class LoadingAudioState extends AudioState {
  final Song song;
  final List<Song> playlist;
  LoadingAudioState({required this.song, required this.playlist});
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
