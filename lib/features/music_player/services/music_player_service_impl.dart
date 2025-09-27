import 'dart:async';
import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart'
    as media_meta_data;
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/services/music_player_service.dart';

class MusicPlayerServiceImpl extends GetxService implements MusicPlayerService {
  final Player _player;
  MusicPlayerServiceImpl({
    required Player player,
  }) : _player = player;

  final _metaData = Rx<media_meta_data.Metadata?>(null);
  final _currentMedia = Rx<Media?>(null);
  final _currentPlaylist = Rx<Playlist>(const Playlist([]));
  final _isPlaying = RxBool(false);
  final _playListModel = Rx<PlaylistMode>(PlaylistMode.loop);
  final _volume = RxDouble(100);
  final _currentPosition = Rx<Duration?>(null);
  final _currentDuration = Rx<Duration?>(null);

  @override
  media_meta_data.Metadata? get currentMusicMetaData => _metaData.value;

  @override
  bool get isPlaying => _isPlaying.value;

  @override
  Stream<bool> get isPlayingStream => _player.stream.playing;

  @override
  PlaylistMode get playListMode => _playListModel.value;

  @override
  double get volume => _volume.value;

  @override
  Media? get currentMedia => _currentMedia.value;

  @override
  Duration? get currentMusicPosition => _currentPosition.value;

  @override
  Duration? get currentMusicDuration => _currentDuration.value;

  @override
  void onInit() {
    super.onInit();
    _listeners();
    _initData();
  }

  Future<void> _initData() async {
    await open([Media('E:/projects/flutter/product/waveglow/test_music.mp3')]);
  }

  void _listeners() {
    _playListListener();
    _playingListener();
    _currentTrackListener();
    _rxListeners();
  }

  void _playListListener() {
    _player.stream.playlist.listen((playlistState) {
      final currentIndex = playlistState.index;
      _currentMedia.value = _currentPlaylist.value.medias[currentIndex];
    });
  }

  void _playingListener() {
    _player.stream.playing.listen(
      (isPlaying) async {
        _isPlaying.value = isPlaying;
        if (isPlaying) {
          await _getMetaData();
        }
      },
    );
  }

  void _currentTrackListener() {
    _player.stream.duration.listen(
      (duration) {
        _currentDuration.value = duration;
      },
    );
    _player.stream.position.listen(
      (duration) {
        _currentPosition.value = duration;
      },
    );
  }

  _rxListeners() {
    ever(
      _currentMedia,
      (callback) {
        _getMetaData();
      },
    );
  }

  _getMetaData() async {
    if (_currentMedia.value != null) {
      _metaData.value = await media_meta_data.MetadataRetriever.fromFile(
        File(_currentMedia.value!.uri),
      );
    } else {
      _metaData.value = null;
    }
  }

  @override
  Future<void> open(List<Media> media) async {
    _currentPlaylist.value = Playlist(media);
    _player.open(_currentPlaylist.value, play: false);
  }

  @override
  Future<void> playOrPause() async {
    if (_player.state.playlist.medias.isNotEmpty) {
      await _player.playOrPause();
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
}
