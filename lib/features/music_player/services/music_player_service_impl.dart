import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/services/music_player_service.dart';

class MusicPlayerServiceImpl extends GetxService implements MusicPlayerService {
  final Player _player;

  MusicPlayerServiceImpl({
    required Player player,
  }) : _player = player;

  @override
  Future<void> open(Media media) async {
    await _player.open(media, play: false);
  }

  @override
  Future<void> playOrPause() async {
    await _player.playOrPause();
  }
}
