import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Database/listening_history_box_controller.dart';
import 'package:podboi/Database/playback_cache_controller.dart';
import 'package:podboi/Database/podcast_episode_box_controller.dart';
import 'package:podboi/Controllers/settings_controller.dart';
import 'package:rxdart/rxdart.dart';

final audioController =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
  return AudioStateNotifier(ref);
});

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer player;

  MyAudioHandler({required this.player}) {
    Rx.combineLatest2<PlaybackEvent, bool, PlaybackState>(
      player.playbackEventStream,
      player.playingStream,
      (event, playing) => _transformEvent(event, playing),
    ).pipe(playbackState);
  }

  void setMediaItem(MediaItem item) {
    mediaItem.add(item);
  }

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> stop() => player.stop();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToQueueItem(int i) => player.seek(Duration.zero, index: i);

  @override
  Future<void> click([MediaButton button = MediaButton.media]) async {
    switch (button) {
      case MediaButton.media:
        if (player.playing) {
          await pause();
        } else {
          await play();
        }
        break;
      case MediaButton.next:
        await seek(Duration(seconds: player.position.inSeconds + 30));
        await play();
        break;
      case MediaButton.previous:
        await seek(Duration(seconds: player.position.inSeconds - 30));
        await play();
        break;
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event, bool playing) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      playing: playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: event.currentIndex,
    );
  }
}

class AudioStateNotifier extends StateNotifier<AudioState> {
  final ref;

  List<Song> _playlist = [];
  late AudioPlayer _player;

  late MyAudioHandler _audioHandler;

  final ListeningHistoryBoxController _listeningHistoryBoxController =
      ListeningHistoryBoxController();

  final PlaybackCacheController _playbackCacheController =
      PlaybackCacheController();

  final PodcastEpisodeBoxController podcastEpisodeBoxController =
      PodcastEpisodeBoxController();

  // debounce throttle
  var throttle = false;
  var playbackCacheThrottle = false;

  AudioStateNotifier(this.ref) : super(InitialAudioState(playlist: [])) {
    _player = AudioPlayer();

    AudioService.init(
      builder: () => MyAudioHandler(player: _player),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.zepplaud.podboi',
        androidNotificationChannelName: 'Music playback',
      ),
    ).then((service) {
      _audioHandler = service;
    });

    getLastSavedPlaybackQueue().then((queue) {
      if (queue != null) {
        _playlist = queue;
      }
    });

    getLastSavedPlaybackPosition().then((pos) {
      if (pos != null) {
        requestPlayingSong(
          pos.song,
          initialPosition: pos.duration,
          pauseOnLoad: true,
        );
      }
    });
  }

  Future<CachedPlaybackState?> getLastSavedPlaybackPosition() async {
    var pos = await _playbackCacheController.getLastSavedPlaybackPosition();

    // print(
    //     " last saved playback position : ${pos?.duration} , ${pos?.song.name}");

    return pos;
  }

  Future<List<Song>?> getLastSavedPlaybackQueue() async {
    var queue = await _playbackCacheController.getLastSavedPlaybackQueue();

    // print(" last saved playback queue : ${queue?.length}");

    return queue;
  }

  void emitUpdatedPlaylistLoadedState(
      LoadedAudioState st, List<Song> newPlaylist) {
    var newState = LoadedAudioState(
      positionStream: st.positionStream,
      player: st.player,
      processingStateStream: st.processingStateStream,
      playlist: newPlaylist,
      episodeDuration: st.episodeDuration,
      currentPlaying: st.currentPlaying,
    );
    state = newState;
  }

  // ** Function to call from UI to add a song to the queue (plays the song if queue is empty)
  Future<void> requestAddingToQueue(Song song) async {
    if (state is InitialAudioState && _playlist.isEmpty) {
      print(" directly playing stuff.");

      // get played duration of the next item
      var playedDuration = await podcastEpisodeBoxController.getPlayedDuration(
          song.episodeData.guid, song.episodeData.podcastId);

      requestPlayingSong(song, initialPosition: playedDuration);
      return;
    }
    print(" adding to queue");
    _playlist.add(song);
    // save the queue to cache
    await _playbackCacheController.storePlaybackQueue(_playlist);

    if (state is LoadedAudioState) {
      emitUpdatedPlaylistLoadedState(state as LoadedAudioState, _playlist);
    }
  }

  Song? get getCurrentPlayingSong {
    if (state is LoadedAudioState) {
      return (state as LoadedAudioState).currentPlaying;
    } else if (state is LoadingAudioState) {
      return (state as LoadingAudioState).song;
    } else if (state is ErrorAudioState) {
      if ((state as ErrorAudioState).song != null) {
        return (state as ErrorAudioState).song;
      }
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

    _player.processingStateStream.listen((ProcessingState pState) async {
      if (pState == ProcessingState.completed && !throttle) {
        // Debounce the processing state callback.
        throttle = true;
        Future.delayed(Duration(milliseconds: 500), () {
          throttle = false;
        });

        var res = await _playbackCacheController.clearSavedPlaybackPosition();
        print(" cleared saved playback position : $res");
        // If there are items in the queue, play the next item.
        if (_playlist.isNotEmpty) {
          print(" Playing next item on the queue");
          // remove the item from the queue and play it.
          var nextItem = _playlist.removeAt(0);
          print(" next item is : ${nextItem.name}");

          // get played duration of the next item
          var playedDuration =
              await podcastEpisodeBoxController.getPlayedDuration(
                  nextItem.episodeData.guid, nextItem.episodeData.podcastId);

          requestPlayingSong(nextItem, initialPosition: playedDuration);
          // save the queue to cache
          await _playbackCacheController.storePlaybackQueue(_playlist);

          if (state is LoadedAudioState) {
            emitUpdatedPlaylistLoadedState(
                state as LoadedAudioState, _playlist);
          }
        }
        print(" no more items in the queue to play");
        await _playbackCacheController.clearSavedPlaybackQueue();
      }
    });

    Duration? epDur;

    try {
      MediaItem mi = MediaItem(
        id: song.url,
        album: song.album,
        title: song.name,
        artUri: Uri.parse(song.icon),
        duration: Duration(seconds: song.duration ?? 0),
      );
      epDur = await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(song.url),
          tag: mi,
        ),
        initialPosition: Duration(seconds: initialPosition ?? 0),
      );

      _audioHandler.setMediaItem(mi);
      // _player.play();
      _audioHandler.play();

      if (pauseOnLoad) {
        // _player.pause();
        _audioHandler.pause();
      }

      var posStream =
          Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

      // Listen to errors during playback.
      _player.playbackEventStream.listen((PlaybackEvent event) {},
          onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
        state = ErrorAudioState(
          errorMessage: e.toString(),
          playlist: _playlist,
          song: song,
        );
      });

      _player.positionStream.asBroadcastStream().listen((positionData) async {
        if (getCurrentPlayingSong == null) return;

        Song song = getCurrentPlayingSong!;

        if (!playbackCacheThrottle) {
          playbackCacheThrottle = true;
          Future.delayed(Duration(seconds: 5)).then((value) {
            playbackCacheThrottle = false;
          });

          await _playbackCacheController.storePlaybackPosition(
            positionData.inSeconds,
            song,
          );

          await _listeningHistoryBoxController.saveEpisodeToHistory(
            ListeningHistoryData(
              listenedOn: DateTime.now().toString(),
              episodeData: song.episodeData,
            ),
          );

          await podcastEpisodeBoxController.storePlayedDuration(
            song.episodeData.guid,
            positionData.inSeconds,
            song.episodeData.podcastId,
          );
        }
      });

      state = LoadedAudioState(
        positionStream: posStream.asBroadcastStream(),
        player: _player,
        processingStateStream: _player.processingStateStream,
        playlist: _playlist,
        episodeDuration: epDur!,
        currentPlaying: song,
      );
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
      state = ErrorAudioState(
        errorMessage: e.toString(),
        playlist: _playlist,
        song: song,
      );
    }
  }

  Future<void> pause() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;
    await _audioHandler.pause();
  }

  Future<void> play() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;
    await _audioHandler.play();
  }

  Future<void> seek(Duration position) async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;
    await _audioHandler.seek(position);
  }

  Future<void> fastForward() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;

    var currentPos = _player.position.inSeconds;
    final forwardSeconds =
        int.parse(ref.read(settingsController).forwardDuration.toString());

    await _audioHandler.seek(Duration(seconds: currentPos + forwardSeconds));
  }

  Future<void> rewind() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;

    var currentPos = _player.position.inSeconds;
    final rewindSeconds =
        int.parse(ref.read(settingsController).rewindDuration.toString());

    await _audioHandler.seek(Duration(
        seconds:
            (currentPos - rewindSeconds) < 0 ? 0 : currentPos - rewindSeconds));
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
    await _playbackCacheController.storePlaybackQueue(_playlist);

    if (state is LoadedAudioState) {
      emitUpdatedPlaylistLoadedState(state as LoadedAudioState, _playlist);
    }
  }

  Future<void> removeFromQueue(int index) async {
    _playlist.removeAt(index);
    // save the queue to cache
    await _playbackCacheController.storePlaybackQueue(_playlist);

    if (state is LoadedAudioState) {
      emitUpdatedPlaylistLoadedState(state as LoadedAudioState, _playlist);
    }
  }

  Future<void> skipToSpecificIndex(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    // print(" length of playlist befoire skip : ${_playlist.length}");
    var itemAtIndex = _playlist.removeAt(index);
    if (state is LoadedAudioState) {
      // await _player.pause();
      await _audioHandler.pause();
      _playlist.insert(0, (state as LoadedAudioState).currentPlaying);
    } else if (state is LoadingAudioState) {
      // await _player.pause();
      await _audioHandler.pause();
      _playlist.insert(0, (state as LoadingAudioState).song);
    }
    // print(" length of playlist after skip : ${_playlist.length}");

    // get played duration of the next item
    var playedDuration = await podcastEpisodeBoxController.getPlayedDuration(
      itemAtIndex.episodeData.guid,
      itemAtIndex.episodeData.podcastId,
    );

    requestPlayingSong(itemAtIndex, initialPosition: playedDuration);

    // save the queue to cache
    await _playbackCacheController.storePlaybackQueue(_playlist);

    if (state is LoadedAudioState) {
      emitUpdatedPlaylistLoadedState(state as LoadedAudioState, _playlist);
    }
  }

  Future<void> stop() async {
    await _audioHandler.stop();
  }
}

abstract class AudioState {
  final List<Song> playlist;

  AudioState({required this.playlist});
}

class InitialAudioState extends AudioState {
  InitialAudioState({required super.playlist});
}

class LoadingAudioState extends AudioState {
  final Song song;
  final List<Song> playlist;
  LoadingAudioState({required this.song, required this.playlist})
      : super(
          playlist: playlist,
        );
}

class ErrorAudioState extends AudioState {
  String errorMessage;
  Song? song;

  ErrorAudioState(
      {required this.errorMessage, required super.playlist, this.song});
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
  }) : super(playlist: playlist);
}
