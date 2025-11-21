import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

abstract class MusicPlayerRepository {
  Future<Either<Failure, void>> saveCurrentPlayList(MusicPlayerPlayListEntity params);
  Future<Either<Failure, MusicPlayerPlayListEntity>> getLastSavedPlaylist();
  Future<Either<Failure, void>> saveMediaControls(MusicPlayerSaveControlsParam params);
  Future<Either<Failure, MusicPlayerControlsEntity>> getControls();
}
