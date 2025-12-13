import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';
import 'package:waveglow/shared/entities/audio_item_entity.dart';

class _MockTracksListGetFavoriteSongsUC extends Mock implements TracksListGetFavoriteSongsUC {}

class _MockTracksListToggleAudioFavoriteUC extends Mock
    implements TracksListToggleAudioFavoriteUC {}

class _MockTracksListGetFavoriteSongsStreamUC extends Mock
    implements TracksListGetFavoriteSongsStreamUC {}

class _FakeAudioItemEntity extends Fake implements AudioItemEntity {}

void main() {
  late _MockTracksListGetFavoriteSongsUC mockTracksListGetFavoriteSongsUC;
  late _MockTracksListGetFavoriteSongsStreamUC mockGetFavoriteSongsStreamUC;
  late _MockTracksListToggleAudioFavoriteUC mockToggleAudioFavoriteUC;
  late TracksListServiceImpl serviceImpl;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(_FakeAudioItemEntity());
  });

  setUp(() {
    mockTracksListGetFavoriteSongsUC = _MockTracksListGetFavoriteSongsUC();
    mockGetFavoriteSongsStreamUC = _MockTracksListGetFavoriteSongsStreamUC();
    mockToggleAudioFavoriteUC = _MockTracksListToggleAudioFavoriteUC();
    serviceImpl = TracksListServiceImpl(
      getFavoriteSongsUC: mockTracksListGetFavoriteSongsUC,
      getFavoriteSongsStreamUC: mockGetFavoriteSongsStreamUC,
      toggleAudioFavoriteUC: mockToggleAudioFavoriteUC,
    );
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

  group("getFavoriteSongsStream -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(
        () => mockGetFavoriteSongsStreamUC.call(any()),
      ).thenAnswer((_) async => right(Stream.empty()));

      //act
      await serviceImpl.getFavoriteSongsStream();

      //assert
      verify(() => mockGetFavoriteSongsStreamUC.call(any())).called(1);
    });
  });

  group("toggleAudioFavorite -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockToggleAudioFavoriteUC.call(any())).thenAnswer((_) async => right(true));

      //act
      await serviceImpl.toggleAudioFavorite(_FakeAudioItemEntity());

      //assert
      verify(() => mockToggleAudioFavoriteUC.call(any())).called(1);
    });
  });
}
