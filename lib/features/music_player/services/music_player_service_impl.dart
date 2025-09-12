import 'dart:async';
import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart' as media_meta_data;
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

  @override
  media_meta_data.Metadata? get currentMusicMetaData => _metaData.value;

  @override
  bool get isPlaying => _isPlaying.value;

  @override
  Stream<bool> get isPlayingStream => _player.stream.playing;

  @override
  void onInit() {
    super.onInit();
    _playListListener();
    _playingListener();

    open([Media('F:/projects/Flutter/CrossPlatform/waveglow/test_music.mp3')]);
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
    await _player.playOrPause();
  }
}
