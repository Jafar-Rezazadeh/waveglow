import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:media_kit/media_kit.dart';

abstract class MusicPlayerService {
  // TODO: consider loading the last played music on app start

  Metadata? get currentMusicMetaData;
  bool get isPlaying;
  Stream<bool> get isPlayingStream;
  Future<void> open(List<Media> media);
  Future<void> playOrPause();
}
