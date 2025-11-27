import 'package:dartz/dartz.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class GetTrackListDirectoriesUC implements UseCase<List<TracksListDirectoryEntity>, SortTypeEnum> {
  final TracksListRepository _repository;

  GetTrackListDirectoriesUC({required TracksListRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<TracksListDirectoryEntity>>> call([
    SortTypeEnum sortType = SortTypeEnum.byModifiedDate,
  ]) {
    return _repository.getDirectories(sortType);
  }
}
