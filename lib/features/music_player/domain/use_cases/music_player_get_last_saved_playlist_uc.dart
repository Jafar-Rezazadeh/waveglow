import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerGetLastSavedPlaylistUC implements UseCase<MusicPlayerPlayListEntity, NoParams> {
  final MusicPlayerRepository _repository;

  MusicPlayerGetLastSavedPlaylistUC({required MusicPlayerRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, MusicPlayerPlayListEntity>> call(NoParams params) {
    return _repository.getLastSavedPlaylist();
  }
}
