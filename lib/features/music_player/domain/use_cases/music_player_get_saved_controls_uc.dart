import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerGetSavedControlsUC implements UseCase<MusicPlayerControlsEntity, NoParams> {
  final MusicPlayerRepository _repository;

  MusicPlayerGetSavedControlsUC({required MusicPlayerRepository repository})
    : _repository = repository;
  @override
  Future<Either<Failure, MusicPlayerControlsEntity>> call(NoParams _) {
    return _repository.getControls();
  }
}
