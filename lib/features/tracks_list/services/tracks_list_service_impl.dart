import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListServiceImpl implements TracksListService {
  final TracksListGetFavoriteSongsUC _getFavoriteSongsUC;

  TracksListServiceImpl({required TracksListGetFavoriteSongsUC getFavoriteSongsUC})
    : _getFavoriteSongsUC = getFavoriteSongsUC;

  @override
  Future<Either<Failure, List<AudioItemEntity>>> getFavoriteSongs() {
    return _getFavoriteSongsUC.call(NoParams());
  }
}
