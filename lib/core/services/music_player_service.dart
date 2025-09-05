import 'package:media_kit/media_kit.dart';

abstract class MusicPlayerService {
  // TODO: consider loading the last played music on app start
  // TODO: make this class an abstract and implement a feature called main
  Future<void> open(Media media);
  Future<void> playOrPause();
}
