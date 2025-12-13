import 'package:dartz/dartz.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class PickTracksListDirectoryUC implements UseCase<TracksListDirectoryEntity?, SortTypeEnum> {
  final TracksListRepository _repository;

  PickTracksListDirectoryUC({required TracksListRepository repository}) : _repository = repository;
  @override
  Future<Either<Failure, TracksListDirectoryEntity?>> call([
    SortTypeEnum sortType = SortTypeEnum.byModifiedDate,
  ]) {
    return _repository.pickDirectory(sortType);
  }
}
