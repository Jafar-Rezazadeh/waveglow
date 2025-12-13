import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListRepository extends Mock implements TracksListRepository {}

class _FakeAudioItemEntity extends Fake implements AudioItemEntity {}

void main() {
  late _MockTracksListRepository mockTracksListRepository;
  late TracksListToggleAudioFavoriteUC useCase;

  setUpAll(() {
    registerFallbackValue(_FakeAudioItemEntity());
  });

  setUp(() {
    mockTracksListRepository = _MockTracksListRepository();
    useCase = TracksListToggleAudioFavoriteUC(repository: mockTracksListRepository);
  });

  test("should call expected method when invoked", () async {
    //arrange
    when(
      () => mockTracksListRepository.toggleAudioFavorite(any()),
    ).thenAnswer((_) async => right(true));

    //act
    await useCase.call(_FakeAudioItemEntity());

    //assert
    verify(() => mockTracksListRepository.toggleAudioFavorite(any())).called(1);
  });
}
