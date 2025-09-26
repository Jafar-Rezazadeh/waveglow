import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:media_kit/media_kit.dart';

abstract class MusicPlayerService {
  // TODO: consider loading the last played music on app start

  Metadata? get currentMusicMetaData;
  bool get isPlaying;
  Stream<bool> get isPlayingStream;
  PlaylistMode get playListMode;
  double get volume;
  Media? get currentMedia;
  Duration? get currentMusicPosition;
  Duration? get currentMusicDuration;

  Future<void> open(List<Media> media);
  Future<void> playOrPause();
  Future<void> goPrevious();
  Future<void> goNext();
  Future<void> cyclePlayListMode();
  Future<void> setVolume(double value);
}
