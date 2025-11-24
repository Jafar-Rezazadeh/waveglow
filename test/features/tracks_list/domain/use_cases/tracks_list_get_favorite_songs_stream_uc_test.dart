import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListRepository extends Mock implements TracksListRepository {}

void main() {
  late _MockTracksListRepository mockTracksListRepository;
  late TracksListGetFavoriteSongsStreamUC favoriteSongsStreamUC;

  setUp(() {
    mockTracksListRepository = _MockTracksListRepository();
    favoriteSongsStreamUC = TracksListGetFavoriteSongsStreamUC(
      repository: mockTracksListRepository,
    );
  });

  test("should call expected repository method when invoked", () async {
    //arrange
    when(
      () => mockTracksListRepository.getFavoriteSongsStream(),
    ).thenAnswer((_) async => right(Stream.empty()));

    //act
    await favoriteSongsStreamUC.call(NoParams());

    //assert
    verify(() => mockTracksListRepository.getFavoriteSongsStream()).called(1);
  });
}
