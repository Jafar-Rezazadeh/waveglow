import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/core_exports.dart';

abstract class MusicPlayerService {
  bool get isPlaying;
  Stream<bool> get isPlayingStream;
  PlaylistMode get playListMode;
  double get volume;
  AudioItemEntity? get currentTrack;
  Duration? get currentMusicPosition;
  Duration? get currentMusicDuration;
  bool get isShuffle;
  List<AudioItemEntity> get currentPlaylist;

  Future<void> openPlayList(List<AudioItemEntity> audios, {bool play});
  Future<void> playOrPause();
  Future<void> goPrevious();
  Future<void> goNext();
  Future<void> cyclePlayListMode();
  Future<void> setVolume(double value);
  Future<void> setPosition(double value);
  Future<void> toggleShuffle();
  Future<void> playAt(int index);
}
