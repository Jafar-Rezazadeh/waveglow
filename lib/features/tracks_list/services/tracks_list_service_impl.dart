import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListServiceImpl implements TracksListService {
  final TracksListGetFavoriteSongsUC _getFavoriteSongsUC;
  final TracksListGetFavoriteSongsStreamUC _getFavoriteSongsStreamUC;

  TracksListServiceImpl({
    required TracksListGetFavoriteSongsUC getFavoriteSongsUC,
    required TracksListGetFavoriteSongsStreamUC getFavoriteSongsStreamUC,
  }) : _getFavoriteSongsUC = getFavoriteSongsUC,
       _getFavoriteSongsStreamUC = getFavoriteSongsStreamUC;

  @override
  Future<Either<Failure, List<AudioItemEntity>>> getFavoriteSongs() {
    return _getFavoriteSongsUC.call(NoParams());
  }

  @override
  Future<Either<Failure, Stream<List<AudioItemEntity>>>> getFavoriteSongsStream() {
    return _getFavoriteSongsStreamUC.call(NoParams());
  }
}
