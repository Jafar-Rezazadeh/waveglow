import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListSyncAudiosUC implements UseCase<void, NoParams> {
  final TracksListRepository _repository;

  TracksListSyncAudiosUC({required TracksListRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.syncAudios();
  }
}
