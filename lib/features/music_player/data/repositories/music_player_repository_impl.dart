import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerRepositoryImpl implements MusicPlayerRepository {
  final FailureFactory _failureFactory;
  final MusicPlayerDataSource _musicPlayerDataSource;

  MusicPlayerRepositoryImpl({
    required FailureFactory failureFactory,
    required MusicPlayerDataSource musicPlayerDataSource,
  }) : _failureFactory = failureFactory,
       _musicPlayerDataSource = musicPlayerDataSource;

  @override
  Future<Either<Failure, void>> saveCurrentPlayList(MusicPlayerPlayListEntity entity) async {
    try {
      final result = await _musicPlayerDataSource.saveCurrentPlayList(
        MusicPlayerPlayListModel.fromEntity(entity),
      );

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, MusicPlayerPlayListEntity>> getLastSavedPlaylist() async {
    try {
      final result = await _musicPlayerDataSource.getLastSavedPlaylist();

      return right(result.toEntity());
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }
}
