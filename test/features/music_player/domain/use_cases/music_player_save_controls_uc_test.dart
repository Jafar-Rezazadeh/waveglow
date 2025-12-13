import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockMusicPlayerRepository extends Mock implements MusicPlayerRepository {}

class _FakeMusicPlayerSaveControlsParam extends Fake implements MusicPlayerSaveControlsParam {}

void main() {
  late _MockMusicPlayerRepository mockMusicPlayerRepository;
  late MusicPlayerSaveControlsUC useCase;

  setUpAll(() {
    registerFallbackValue(_FakeMusicPlayerSaveControlsParam());
  });

  setUp(() {
    mockMusicPlayerRepository = _MockMusicPlayerRepository();
    useCase = MusicPlayerSaveControlsUC(repository: mockMusicPlayerRepository);
  });

  test("should call expected method of repository when invoked", () async {
    //arrange
    when(
      () => mockMusicPlayerRepository.saveMediaControls(any()),
    ).thenAnswer((_) async => right(null));

    //act
    await useCase.call(_FakeMusicPlayerSaveControlsParam());

    //assert
    verify(() => mockMusicPlayerRepository.saveMediaControls(any())).called(1);
  });
}
