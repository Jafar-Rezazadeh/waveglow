import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/music_player/domain/entities/music_player_play_list_entity.dart';

abstract class MusicPlayerRepository {
  Future<Either<Failure, void>> saveCurrentPlayList(MusicPlayerPlayListEntity params);
  Future<Either<Failure, MusicPlayerPlayListEntity>> getLastSavedPlaylist();
}
