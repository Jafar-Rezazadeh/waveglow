import 'package:dartz/dartz.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class GetTrackListDirectoriesUC implements UseCase<List<TracksListDirectoryEntity>, SortType> {
  final TracksListRepository _repository;

  GetTrackListDirectoriesUC({required TracksListRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<TracksListDirectoryEntity>>> call([
    SortType sortType = SortType.byModifiedDate,
  ]) {
    return _repository.getDirectories(sortType);
  }
}
