import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListGetFavoriteSongsUC implements UseCase<List<AudioItemEntity>, NoParams> {
  final TracksListRepository _repository;

  TracksListGetFavoriteSongsUC({required TracksListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<AudioItemEntity>>> call(NoParams params) {
    return _repository.getFavoriteSongs();
  }
}
