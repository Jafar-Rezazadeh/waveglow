import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockMusicPlayerRepository extends Mock implements MusicPlayerRepository {}

class _FakeMusicPlayerPlayListEntity extends Fake implements MusicPlayerPlayListEntity {}

void main() {
  late _MockMusicPlayerRepository mockRepository;
  late MusicPlayerGetLastSavedPlaylistUC musicPlayerGetLastSavedPlaylistUC;

  setUp(() {
    mockRepository = _MockMusicPlayerRepository();
    musicPlayerGetLastSavedPlaylistUC = MusicPlayerGetLastSavedPlaylistUC(
      repository: mockRepository,
    );
  });

  test("should call expected result when invoked", () async {
    //arrange
    when(
      () => mockRepository.getLastSavedPlaylist(),
    ).thenAnswer((_) async => right(_FakeMusicPlayerPlayListEntity()));

    //act
    await musicPlayerGetLastSavedPlaylistUC.call(NoParams());

    //assert
    verify(() => mockRepository.getLastSavedPlaylist()).called(1);
  });
}
