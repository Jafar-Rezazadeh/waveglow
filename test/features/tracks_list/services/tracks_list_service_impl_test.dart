import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListGetFavoriteSongsUC extends Mock implements TracksListGetFavoriteSongsUC {}

void main() {
  late _MockTracksListGetFavoriteSongsUC mockTracksListGetFavoriteSongsUC;
  late TracksListServiceImpl serviceImpl;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockTracksListGetFavoriteSongsUC = _MockTracksListGetFavoriteSongsUC();
    serviceImpl = TracksListServiceImpl(getFavoriteSongsUC: mockTracksListGetFavoriteSongsUC);
  });

  group("getFavoriteSongs -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockTracksListGetFavoriteSongsUC.call(any())).thenAnswer((_) async => right([]));

      //act
      await serviceImpl.getFavoriteSongs();

      //assert
      verify(() => mockTracksListGetFavoriteSongsUC.call(any())).called(1);
    });
  });
}
