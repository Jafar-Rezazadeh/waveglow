import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/domain/repositories/music_player_repository.dart';

class MusicPlayerSaveControlsUC implements UseCase<void, MusicPlayerSaveControlsParam> {
  final MusicPlayerRepository _repository;

  MusicPlayerSaveControlsUC({required MusicPlayerRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(MusicPlayerSaveControlsParam params) {
    return _repository.saveMediaControls(params);
  }
}

class MusicPlayerSaveControlsParam {
  final double volume;
  final int playListModeIndex;

  MusicPlayerSaveControlsParam({required this.volume, required this.playListModeIndex});
}
