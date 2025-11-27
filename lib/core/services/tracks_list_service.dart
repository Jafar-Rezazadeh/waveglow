import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';

abstract class TracksListService {
  Future<Either<Failure, List<AudioItemEntity>>> getFavoriteSongs();
  Future<Either<Failure, Stream<List<AudioItemEntity>>>> getFavoriteSongsStream();
  Future<Either<Failure, void>> toggleAudioFavorite(AudioItemEntity item);
}
