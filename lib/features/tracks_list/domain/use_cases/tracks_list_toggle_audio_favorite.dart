import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListToggleAudioFavoriteUC implements UseCase<bool, AudioItemEntity> {
  final TracksListRepository _repository;

  TracksListToggleAudioFavoriteUC({required TracksListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(AudioItemEntity item) {
    return _repository.toggleAudioFavorite(item);
  }
}
