import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListGetFavoriteSongsStreamUC
    implements UseCase<Stream<List<AudioItemEntity>>, NoParams> {
  final TracksListRepository _repository;

  TracksListGetFavoriteSongsStreamUC({required TracksListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Stream<List<AudioItemEntity>>>> call(NoParams params) {
    return _repository.getFavoriteSongsStream();
  }
}
