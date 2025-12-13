import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockMusicPlayerRepository extends Mock implements MusicPlayerRepository {}

class _FakeMusicPlayerControlsEntity extends Fake implements MusicPlayerControlsEntity {}

void main() {
  late _MockMusicPlayerRepository mockMusicPlayerRepository;
  late MusicPlayerGetSavedControlsUC useCase;

  setUp(() {
    mockMusicPlayerRepository = _MockMusicPlayerRepository();
    useCase = MusicPlayerGetSavedControlsUC(repository: mockMusicPlayerRepository);
  });

  test("should call expected method of repository when invoked", () async {
    //arrange
    when(
      () => mockMusicPlayerRepository.getControls(),
    ).thenAnswer((_) async => right(_FakeMusicPlayerControlsEntity()));

    //act
    await useCase.call(NoParams());

    //assert
    verify(() => mockMusicPlayerRepository.getControls()).called(1);
  });
}
