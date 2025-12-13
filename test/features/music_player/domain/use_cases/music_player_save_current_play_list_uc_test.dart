import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockMusicPlayerRepository extends Mock implements MusicPlayerRepository {}

class _FakeMusicPlayerPlayListEntity extends Fake implements MusicPlayerPlayListEntity {}

void main() {
  late _MockMusicPlayerRepository mockMusicPlayerRepository;
  late MusicPlayerSaveCurrentPlayListUC useCase;

  setUpAll(() {
    registerFallbackValue(_FakeMusicPlayerPlayListEntity());
  });

  setUp(() {
    mockMusicPlayerRepository = _MockMusicPlayerRepository();
    useCase = MusicPlayerSaveCurrentPlayListUC(repository: mockMusicPlayerRepository);
  });

  test("should call expected method of repository", () async {
    //arrange
    when(
      () => mockMusicPlayerRepository.saveCurrentPlayList(any()),
    ).thenAnswer((_) async => right(null));

    //act
    await useCase.call(_FakeMusicPlayerPlayListEntity());

    //assert
    verify(() => mockMusicPlayerRepository.saveCurrentPlayList(any())).called(1);
  });
}
