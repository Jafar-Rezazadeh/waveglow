import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListServiceImpl implements TracksListService {
  final TracksListGetFavoriteSongsUC _getFavoriteSongsUC;
  final TracksListGetFavoriteSongsStreamUC _getFavoriteSongsStreamUC;
  final TracksListToggleAudioFavoriteUC _toggleAudioFavoriteUC;

  TracksListServiceImpl({
    required TracksListGetFavoriteSongsUC getFavoriteSongsUC,
    required TracksListGetFavoriteSongsStreamUC getFavoriteSongsStreamUC,
    required TracksListToggleAudioFavoriteUC toggleAudioFavoriteUC,
  }) : _getFavoriteSongsUC = getFavoriteSongsUC,
       _getFavoriteSongsStreamUC = getFavoriteSongsStreamUC,
       _toggleAudioFavoriteUC = toggleAudioFavoriteUC;

  @override
  Future<Either<Failure, List<AudioItemEntity>>> getFavoriteSongs() {
    return _getFavoriteSongsUC.call(NoParams());
  }

  @override
  Future<Either<Failure, Stream<List<AudioItemEntity>>>> getFavoriteSongsStream() {
    return _getFavoriteSongsStreamUC.call(NoParams());
  }

  @override
  Future<Either<Failure, void>> toggleAudioFavorite(AudioItemEntity item) {
    return _toggleAudioFavoriteUC.call(item);
  }
}
