import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podboi/DataModels/cached_playback_state.dart';
import 'package:podboi/DataModels/listening_history.dart';
import 'package:podboi/DataModels/position_data.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Database/download_box_controller.dart';
import 'package:podboi/Controllers/download_controller.dart';
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
  Future<void> setSpeed(double speed) => player.setSpeed(speed);

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
  late final AudioPlayer _player;

  late final Future<MyAudioHandler> _audioHandler;
  StreamSubscription<ProcessingState>? _processingSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;

  // Source changes must not overlap. A tap on another episode while a stream
  // is loading used to leave multiple listeners and competing source loads.
  Future<void> _sourceOperation = Future.value();

  final ListeningHistoryBoxController _listeningHistoryBoxController =
      ListeningHistoryBoxController();

  final DownloadBoxController _downloadBoxController = DownloadBoxController();

  final PlaybackCacheController _playbackCacheController =
      PlaybackCacheController();

  final PodcastEpisodeBoxController podcastEpisodeBoxController =
      PodcastEpisodeBoxController();

  DateTime? _lastCheckpoint;
  bool _isChangingSource = false;
  bool _isHandlingCompletion = false;
  bool _isStopping = false;
  bool _isClearingStoppedPlayback = false;
  bool _isDisposed = false;
  bool _hasExplicitPlaybackRequest = false;
  String? _completedEpisodeKey;

  AudioStateNotifier(this.ref) : super(InitialAudioState(playlist: [])) {
    _player = AudioPlayer();
    _audioHandler = AudioService.init(
      builder: () => MyAudioHandler(player: _player),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.zepplaud.podboi',
        androidNotificationChannelName: 'Music playback',
      ),
    );

    _processingSubscription = _player.processingStateStream.listen((state) {
      unawaited(_onProcessingState(state));
    });
    _positionSubscription = _player.positionStream.listen((position) {
      unawaited(_checkpointPosition(position));
    });
    _playbackEventSubscription = _player.playbackEventStream.listen(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        _reportPlaybackError(error);
      },
    );

    unawaited(_restorePlaybackState());
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    final current = getCurrentPlayingSong;
    final position = _player.position;
    _isDisposed = true;
    unawaited(_shutdown(current, position));
    super.dispose();
  }

  Future<void> _shutdown(Song? current, Duration position) async {
    await Future.wait([
      _processingSubscription?.cancel() ?? Future<void>.value(),
      _positionSubscription?.cancel() ?? Future<void>.value(),
      _playbackEventSubscription?.cancel() ?? Future<void>.value(),
    ]);
    if (current != null) {
      await _persistPosition(current, position);
    }
    await _player.dispose();
  }

  Future<void> _restorePlaybackState() async {
    try {
      // Restore the queue before restoring the current episode so a completed
      // restored episode advances exactly as it did before the app closed.
      final queue = await getLastSavedPlaybackQueue();
      if (queue != null) {
        _playlist = List<Song>.from(queue);
      }

      final savedPosition = await getLastSavedPlaybackPosition();
      // Do not let a late cache read replace an episode selected by the user
      // during startup.
      if (!_isDisposed &&
          !_hasExplicitPlaybackRequest &&
          savedPosition != null) {
        await _enqueueSourceChange(
          () => _loadSong(
            savedPosition.song,
            initialPosition: savedPosition.duration,
            pauseOnLoad: true,
          ),
        );
      }
    } catch (error) {
      // A corrupt cache must not prevent the player from being usable.
      print('Unable to restore saved playback: $error');
    }
  }

  Future<void> _onProcessingState(ProcessingState processingState) async {
    if (_isDisposed || _isChangingSource) {
      return;
    }
    if (processingState == ProcessingState.idle) {
      await _clearStoppedPlayback();
      return;
    }
    if (processingState != ProcessingState.completed ||
        _isStopping ||
        _isHandlingCompletion) {
      return;
    }

    final current = getCurrentPlayingSong;
    if (current == null) return;
    final episodeKey = _episodeKey(current);
    if (_completedEpisodeKey == episodeKey) return;

    _isHandlingCompletion = true;
    _completedEpisodeKey = episodeKey;
    try {
      await _handleCompletion(current);
    } catch (error) {
      _reportPlaybackError(error, song: current);
    } finally {
      _isHandlingCompletion = false;
    }
  }

  Future<void> _handleCompletion(Song current) async {
    await podcastEpisodeBoxController.markEpisodeAsPlayed(
      current.episodeData.guid,
      current.episodeData.podcastId,
    );
    await _playbackCacheController.clearSavedPlaybackPosition();

    if (ref.read(settingsController).autoDelete) {
      final downloaded =
          await _downloadBoxController.getDownload(current.episodeData.guid);
      if (downloaded != null) {
        await ref
            .read(downloadController.notifier)
            .deleteEpisode(current.episodeData.guid);
      }
    }

    if (_playlist.isEmpty) {
      await _playbackCacheController.clearSavedPlaybackQueue();
      if (!_isDisposed) {
        state = InitialAudioState(playlist: const []);
      }
      return;
    }

    final next = _playlist.removeAt(0);
    await _playbackCacheController.storePlaybackQueue(_playlist);
    final position = await podcastEpisodeBoxController.getPlayedDuration(
      next.episodeData.guid,
      next.episodeData.podcastId,
    );
    await requestPlayingSong(next, initialPosition: position);
  }

  Future<void> _clearStoppedPlayback() async {
    if (_isDisposed ||
        _isClearingStoppedPlayback ||
        (state is! LoadingAudioState && state is! LoadedAudioState)) {
      return;
    }

    _isClearingStoppedPlayback = true;
    try {
      // A stop is an explicit end of the playback session, not a pause. Do
      // not resurrect this item after a relaunch and remove the mini player.
      await Future.wait([
        _playbackCacheController.clearSavedPlaybackPosition(),
        _playbackCacheController.clearSavedPlaybackQueue(),
      ]);
      _playlist.clear();
      if (!_isDisposed) {
        state = InitialAudioState(playlist: const []);
      }
    } finally {
      _isClearingStoppedPlayback = false;
    }
  }

  Future<void> _checkpointPosition(Duration position) async {
    if (_isDisposed) return;
    final current = getCurrentPlayingSong;
    if (current == null || !_player.playing) return;
    final now = DateTime.now();
    if (_lastCheckpoint != null &&
        now.difference(_lastCheckpoint!) < const Duration(seconds: 15)) {
      return;
    }
    await _persistPosition(current, position);
    _lastCheckpoint = now;
  }

  Future<void> _persistPosition(Song song, [Duration? position]) async {
    final currentPosition = position ?? _player.position;
    try {
      await Future.wait([
        _playbackCacheController.storePlaybackPosition(
          currentPosition.inSeconds,
          song,
        ),
        _listeningHistoryBoxController.saveEpisodeToHistory(
          ListeningHistoryData(
            listenedOn: DateTime.now().toIso8601String(),
            episodeData: song.episodeData,
          ),
        ),
        podcastEpisodeBoxController.storePlayedDuration(
          song.episodeData.guid,
          currentPosition.inSeconds,
          song.episodeData.podcastId,
        ),
      ]);
    } catch (error) {
      // Persistence failures should never interrupt active playback.
      print('Unable to persist playback position: $error');
    }
  }

  Future<void> _persistCurrentPosition() async {
    final current = getCurrentPlayingSong;
    if (current != null) await _persistPosition(current);
  }

  Future<void> _enqueueSourceChange(Future<void> Function() operation) {
    if (_isDisposed) return Future<void>.value();
    final next = _sourceOperation.then<void>(
      (_) => operation(),
      onError: (_, __) => operation(),
    );
    // Keep the queue alive after a failed URL/load while still returning that
    // error to the caller that initiated it.
    _sourceOperation = next.then<void>(
      (_) {},
      onError: (_, __) {},
    );
    return next;
  }

  String _episodeKey(Song song) =>
      '${song.episodeData.podcastId}:${song.episodeData.guid}';

  void _reportPlaybackError(Object error, {Song? song}) {
    if (_isDisposed || _isChangingSource) return;
    final current = song ?? getCurrentPlayingSong;
    if (current == null) return;
    print('Audio playback error: $error');
    state = ErrorAudioState(
      errorMessage: error.toString(),
      playlist: _playlist,
      song: current,
    );
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
      final playedDuration = await podcastEpisodeBoxController
          .getPlayedDuration(song.episodeData.guid, song.episodeData.podcastId);
      await requestPlayingSong(song, initialPosition: playedDuration);
      return;
    }
    _playlist.add(song);
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

  /// Loads a new episode through the single source-change queue. This makes
  /// rapid episode taps deterministic and prevents stale loads from replacing
  /// the episode the user selected last.
  Future<void> requestPlayingSong(Song song,
      {int? initialPosition, bool pauseOnLoad = false}) {
    _hasExplicitPlaybackRequest = true;
    return _enqueueSourceChange(
      () => _loadSong(
        song,
        initialPosition: initialPosition,
        pauseOnLoad: pauseOnLoad,
      ),
    );
  }

  Future<void> _loadSong(Song song,
      {int? initialPosition, bool pauseOnLoad = false}) async {
    if (_isDisposed) return;
    await _persistCurrentPosition();
    _isChangingSource = true;
    _completedEpisodeKey = null;
    state = LoadingAudioState(song: song, playlist: _playlist);

    try {
      final handler = await _audioHandler;
      // Pause the previous source before replacing it. This avoids a short
      // overlap on slow network source changes and works for foreground and
      // lock-screen initiated requests alike.
      if (_player.playing) {
        await handler.pause();
      }

      final mediaItem = MediaItem(
        id: song.url,
        album: song.album,
        title: song.name,
        artUri: Uri.tryParse(song.icon),
        duration: Duration(seconds: song.duration ?? 0),
      );
      final downloadedEpisode =
          await _downloadBoxController.getDownload(song.episodeData.guid);

      final Duration? episodeDuration;
      if (downloadedEpisode != null &&
          await File(downloadedEpisode.filePath).exists()) {
        episodeDuration = await _player.setAudioSource(
          AudioSource.file(
            downloadedEpisode.filePath,
            tag: mediaItem,
          ),
        );
      } else {
        episodeDuration = await _player.setAudioSource(
          AudioSource.uri(
            Uri.parse(song.url),
            tag: mediaItem,
          ),
        );
      }

      // Seeking during setAudioSource is fragile for some HTTP servers and an
      // out-of-date cached position can be beyond a newly edited enclosure.
      // Load first, then perform one bounded seek before starting playback.
      final requestedPosition = Duration(seconds: initialPosition ?? 0);
      final maxPosition = episodeDuration == null ||
              episodeDuration <= const Duration(seconds: 1)
          ? requestedPosition
          : episodeDuration - const Duration(seconds: 1);
      final resumePosition =
          requestedPosition > maxPosition ? maxPosition : requestedPosition;
      if (resumePosition > Duration.zero) {
        await _player.seek(resumePosition);
      }

      handler.setMediaItem(mediaItem);

      // A restored source must be explicitly paused *after* it is attached.
      // Some platform player implementations preserve their previous playing
      // flag across setAudioSource, which otherwise causes an unwanted start.
      if (pauseOnLoad) {
        await handler.pause();
      } else {
        // Do not await play(): just_audio can keep this future pending for the
        // lifetime of the episode. The UI must transition out of loading as
        // soon as the source is ready, not when playback finishes.
        unawaited(_startPlayback(handler, song));
      }

      var posStream =
          Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

      state = LoadedAudioState(
        positionStream: posStream.asBroadcastStream(),
        player: _player,
        processingStateStream: _player.processingStateStream,
        playlist: _playlist,
        episodeDuration: episodeDuration ?? Duration.zero,
        currentPlaying: song,
      );
      _isChangingSource = false;
    } catch (e, stackTrace) {
      print("Error loading audio source: $e");
      print(stackTrace);
      state = ErrorAudioState(
        errorMessage: e.toString(),
        playlist: _playlist,
        song: song,
      );
    } finally {
      _isChangingSource = false;
    }
  }

  Future<void> _startPlayback(MyAudioHandler handler, Song song) async {
    try {
      await handler.play();
    } catch (error) {
      _reportPlaybackError(error, song: song);
    }
  }

  Future<void> pause() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;
    await (await _audioHandler).pause();
    await _persistCurrentPosition();
  }

  Future<void> play() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;
    await (await _audioHandler).play();
  }

  Future<void> seek(Duration position) async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;
    await _seekWithinEpisode(position);
  }

  Future<void> fastForward() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;

    final forwardSeconds = ref.read(settingsController).forwardDuration;
    await _seekWithinEpisode(
      _player.position + Duration(seconds: forwardSeconds),
    );
  }

  Future<void> rewind() async {
    if (state is! LoadedAudioState && state is! LoadingAudioState) return;

    final rewindSeconds = ref.read(settingsController).rewindDuration;
    await _seekWithinEpisode(
      _player.position - Duration(seconds: rewindSeconds),
    );
  }

  Future<void> _seekWithinEpisode(Duration target) async {
    final duration = _player.duration;
    final lowerBound = target.isNegative ? Duration.zero : target;
    final bounded =
        duration != null && lowerBound > duration ? duration : lowerBound;
    // Seeking the single authoritative player directly avoids an unnecessary
    // command round-trip through the background handler. The handler observes
    // the same player stream, so notification/lock-screen state stays synced.
    await _player.seek(bounded);
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < 0 ||
        oldIndex >= _playlist.length ||
        newIndex < 0 ||
        newIndex > _playlist.length ||
        oldIndex == newIndex) {
      return;
    }

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
    if (index < 0 || index >= _playlist.length) return;
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
      await (await _audioHandler).pause();
      _playlist.insert(0, (state as LoadedAudioState).currentPlaying);
    } else if (state is LoadingAudioState) {
      // await _player.pause();
      await (await _audioHandler).pause();
      _playlist.insert(0, (state as LoadingAudioState).song);
    }
    // print(" length of playlist after skip : ${_playlist.length}");

    // get played duration of the next item
    var playedDuration = await podcastEpisodeBoxController.getPlayedDuration(
      itemAtIndex.episodeData.guid,
      itemAtIndex.episodeData.podcastId,
    );

    await requestPlayingSong(itemAtIndex, initialPosition: playedDuration);

    // save the queue to cache
    await _playbackCacheController.storePlaybackQueue(_playlist);

    if (state is LoadedAudioState) {
      emitUpdatedPlaylistLoadedState(state as LoadedAudioState, _playlist);
    }
  }

  Future<void> stop() async {
    _isStopping = true;
    try {
      await (await _audioHandler).stop();
      await _clearStoppedPlayback();
    } finally {
      _isStopping = false;
    }
  }

  Future<void> setSpeed(double speed) async {
    if (speed < 0.5 || speed > 3.0) return;
    await (await _audioHandler).setSpeed(speed);
  }

  /// Called by the app shell when it loses foreground priority. This avoids
  /// relying solely on periodic checkpoints when Android/iOS reclaims a
  /// process.
  Future<void> checkpoint() => _persistCurrentPosition();
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
