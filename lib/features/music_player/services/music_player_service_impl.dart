import 'dart:async';

import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/core_exports.dart';

class MusicPlayerServiceImpl extends GetxService implements MusicPlayerService {
  final Player _player;
  MusicPlayerServiceImpl({required Player player}) : _player = player;

  final _currentMedia = Rx<AudioItemEntity?>(null);
  final _currentPlaylist = Rx<List<AudioItemEntity>>([]);
  final _isPlaying = RxBool(false);
  final _playListModel = Rx<PlaylistMode>(PlaylistMode.loop);
  final _volume = RxDouble(100);
  final _currentPosition = Rx<Duration?>(null);
  final _currentDuration = Rx<Duration?>(null);
  final _isShuffle = false.obs;

  @override
  bool get isPlaying => _isPlaying.value;

  @override
  Stream<bool> get isPlayingStream => _player.stream.playing;

  @override
  PlaylistMode get playListMode => _playListModel.value;

  @override
  double get volume => _volume.value;

  @override
  AudioItemEntity? get currentTrack => _currentMedia.value;

  @override
  Duration? get currentMusicPosition => _currentPosition.value;

  @override
  Duration? get currentMusicDuration => _currentDuration.value;

  @override
  List<AudioItemEntity> get currentPlaylist => _currentPlaylist.value;

  @override
  bool get isShuffle => _isShuffle.value;

  @override
  void onInit() {
    super.onInit();
    _listeners();
    _initData();
  }

  Future<void> _initData() async {}

  void _listeners() {
    _playListListener();
    _playingListener();
    _currentTrackListener();
    _rxListeners();
  }

  void _playListListener() {
    _player.stream.playlist.listen((playlistState) {
      final currentIndex = playlistState.index;

      _currentMedia.value = _currentPlaylist.value[currentIndex];
    });
  }

  void _playingListener() {
    _player.stream.playing.listen((isPlaying) async {
      _isPlaying.value = isPlaying;
    });
  }

  void _currentTrackListener() {
    _player.stream.duration.listen((duration) {
      _currentDuration.value = duration;
    });
    _player.stream.position.listen((duration) {
      _currentPosition.value = duration;
    });
  }

  _rxListeners() {
    ever(_currentMedia, (callback) {});
  }

  @override
  Future<void> openPlayList(List<AudioItemEntity> tracks, {bool play = false}) async {
    _currentPlaylist.value = tracks;
    _player.open(Playlist(_currentPlaylist.value.map((e) => Media(e.path)).toList()), play: play);
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
    int index = _playListModel.value.index;

    if (index < PlaylistMode.values.length - 1) {
      index++;
    } else {
      index = 0;
    }
    _playListModel.value = PlaylistMode.values[index];

    await _player.setPlaylistMode(_playListModel.value);
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
}
