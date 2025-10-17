import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class GetTrackListDirectoriesUC implements UseCase<List<TracksListDirectoryEntity>, NoParams> {
  final TracksListRepository _repository;

  GetTrackListDirectoriesUC({required TracksListRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<TracksListDirectoryEntity>>> call(NoParams params) {
    return _repository.getDirectories();
  }
}
