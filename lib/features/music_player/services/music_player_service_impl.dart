import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerServiceImpl extends GetxService implements MusicPlayerService {
  final MusicPlayerSaveCurrentPlayListUC _saveCurrentPlayListUC;
  final MusicPlayerGetLastSavedPlaylistUC _getLastSavedPlaylistUC;
  final MusicPlayerSaveControlsUC _saveControlsUC;
  final MusicPlayerGetSavedControlsUC _getSavedControlsUC;
  final Player _player;
  final Logger _logger;

  final _currentMedia = Rx<AudioItemEntity?>(null);
  final _currentPlaylist = Rx<MusicPlayerPlayListEntity?>(null);
  final _isPlaying = RxBool(false);
  final _playListMode = Rx<PlaylistMode>(PlaylistMode.loop);
  final _volume = RxDouble(100);
  final _currentPosition = Rx<Duration?>(null);
  final _currentDuration = Rx<Duration?>(null);
  final _isShuffle = false.obs;

  late final StreamSubscription<Playlist> _playListSubscription;
  late final StreamSubscription<bool> _playingSubscription;
  late final StreamSubscription<Duration> _durationSubscription;
  late final StreamSubscription<Duration> _positionSubscription;

  MusicPlayerServiceImpl({
    required Player player,
    required MusicPlayerSaveCurrentPlayListUC saveCurrentPlayListUC,
    required MusicPlayerGetLastSavedPlaylistUC getLastSavedPlaylistUC,
    required MusicPlayerSaveControlsUC saveControlsUC,
    required MusicPlayerGetSavedControlsUC getSavedControlsUC,
    required Logger logger,
  }) : _saveCurrentPlayListUC = saveCurrentPlayListUC,
       _getLastSavedPlaylistUC = getLastSavedPlaylistUC,
       _player = player,
       _logger = logger,
       _saveControlsUC = saveControlsUC,
       _getSavedControlsUC = getSavedControlsUC;

  @override
  bool get isPlaying => _isPlaying.value;

  @override
  Stream<bool> get isPlayingStream => _player.stream.playing;

  @override
  PlaylistMode get playListMode => _playListMode.value;

  @override
  double get volume => _volume.value;

  @override
  AudioItemEntity? get currentTrack => _currentMedia.value;

  @override
  Duration? get currentMusicPosition => _currentPosition.value;

  @override
  Duration? get currentMusicDuration => _currentDuration.value;

  @override
  MusicPlayerPlayListEntity? get currentPlaylist => _currentPlaylist.value;

  @override
  bool get isShuffle => _isShuffle.value;

  @override
  void onInit() {
    super.onInit();
    _initAsync();
  }

  Future<void> _initAsync() async {
    _listeners();
    initializeMediaControls();
    await getLastSavedPlaylist();
    if (_currentPlaylist.value != null) {
      await openPlayList(_currentPlaylist.value!);
    }
  }

  void _listeners() {
    _playListListener();
    _playingListener();
    _durationListener();

    //
    ever(_volume, (callback) {
      savePlayerControls();
    });
    ever(_playListMode, (callback) {
      savePlayerControls();
    });
  }

  void _playListListener() {
    _playListSubscription = _player.stream.playlist.listen((playlistState) {
      _setCurrentPlayingMusic(playlistState);
    });
  }

  void _setCurrentPlayingMusic(Playlist playlistState) {
    final shuffledMedia = playlistState.medias[playlistState.index];

    final originalIndex =
        _currentPlaylist.value?.audios.indexWhere(
          (m) => m.path == shuffledMedia.uri.replaceAll("/", "\\"),
        ) ??
        -1;

    if (originalIndex != -1) {
      _currentMedia.value = _currentPlaylist.value?.audios[originalIndex];
    }
  }

  void _playingListener() {
    _playingSubscription = _player.stream.playing.listen((isPlaying) async {
      _isPlaying.value = isPlaying;
    });
  }

  void _durationListener() {
    _durationSubscription = _player.stream.duration.listen((duration) {
      _currentDuration.value = duration;
    });
    _positionSubscription = _player.stream.position.listen((duration) {
      _currentPosition.value = duration;
    });
  }

  @visibleForTesting
  Future<void> getLastSavedPlaylist() async {
    final result = await _getLastSavedPlaylistUC.call(NoParams());

    result.fold(
      (failure) {
        _logger.e("${failure.message}\n${failure.stackTrace}");
      },
      (data) {
        _currentPlaylist.value = data;
      },
    );
  }

  @visibleForTesting
  Future<void> initializeMediaControls() async {
    final result = await _getSavedControlsUC.call(NoParams());

    result.fold(
      (failure) {
        _logger.e(failure.message);
      },
      (data) {
        _volume.value = data.volume;
        _playListMode.value = PlaylistMode.values[data.playlistModeIndex];
        _player.setVolume(_volume.value);
        _player.setPlaylistMode(_playListMode.value);
      },
    );
  }

  @visibleForTesting
  Future<void> savePlaylist(MusicPlayerPlayListEntity entity) async {
    final result = await _saveCurrentPlayListUC.call(entity);

    result.fold((failure) => _logger.e("${failure.message}\n${failure.stackTrace}"), (_) {});
  }

  @override
  Future<void> openPlayList(MusicPlayerPlayListEntity playList, {bool play = false}) async {
    _currentPlaylist.value = playList;
    await _player.open(Playlist(playList.audios.map((e) => Media(e.path)).toList()), play: play);
    await _setShuffleOff();
    await savePlaylist(playList);
  }

  Future<void> _setShuffleOff() async {
    _isShuffle.value = false;
    await _player.setShuffle(_isShuffle.value);
  }

  @override
  Future<void> playOrPause() async {
    if (_player.state.playlist.medias.isNotEmpty) {
      if (_player.state.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    }
  }

  @override
  Future<void> goPrevious() async {
    await _player.previous();
  }

  @override
  Future<void> goNext() async {
    await _player.next();
  }

  @override
  Future<void> cyclePlayListMode() async {
    int index = _playListMode.value.index;

    if (index < PlaylistMode.values.length - 1) {
      index++;
    } else {
      index = 0;
    }
    _playListMode.value = PlaylistMode.values[index];

    await _player.setPlaylistMode(_playListMode.value);
  }

  @override
  Future<void> setVolume(double value) async {
    value = value.clamp(0.0, 100.0);

    _volume.value = value;

    await _player.setVolume(_volume.value);
  }

  @override
  Future<void> setPosition(double value) async {
    await _player.seek(Duration(seconds: value.toInt()));
  }

  @override
  Future<void> toggleShuffle() async {
    _isShuffle.value = !_isShuffle.value;
    await _player.setShuffle(_isShuffle.value);
  }

  @override
  Future<void> playAt(int index) async {
    await _player.jump(index);
    await _player.play();
  }

  @visibleForTesting
  Future<void> savePlayerControls() async {
    final params = MusicPlayerSaveControlsParam(
      volume: _volume.value,
      playListModeIndex: _playListMode.value.index,
    );

    final result = await _saveControlsUC.call(params);

    result.fold((failure) => _logger.e(failure.message), (_) {});
  }

  @override
  void onClose() {
    _playListSubscription.cancel();
    _playingSubscription.cancel();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    super.onClose();
  }
}
