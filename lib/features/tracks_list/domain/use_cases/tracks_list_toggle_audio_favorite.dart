import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListToggleAudioFavoriteUC
    implements UseCase<bool, TracksListToggleAudioFavoriteParams> {
  final TracksListRepository _repository;

  TracksListToggleAudioFavoriteUC({required TracksListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(TracksListToggleAudioFavoriteParams params) {
    return _repository.toggleAudioFavorite(params);
  }
}

class TracksListToggleAudioFavoriteParams {
  final String dirId;
  final String audioPath;

  TracksListToggleAudioFavoriteParams({required this.dirId, required this.audioPath});
}
