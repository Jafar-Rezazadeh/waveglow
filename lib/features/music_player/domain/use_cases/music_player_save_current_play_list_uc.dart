import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerSaveCurrentPlayListUC implements UseCase<void, MusicPlayerPlayListEntity> {
  final MusicPlayerRepository _repository;

  MusicPlayerSaveCurrentPlayListUC({required MusicPlayerRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(MusicPlayerPlayListEntity params) {
    return _repository.saveCurrentPlayList(params);
  }
}
