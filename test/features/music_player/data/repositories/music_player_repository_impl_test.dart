import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockMusicPlayerDataSource extends Mock implements MusicPlayerDataSource {}

class _MockFailureFactory extends Mock implements FailureFactory {}

class _FakeMusicPlayerPlayListEntity extends Fake implements MusicPlayerPlayListEntity {}

class _FakeFailure extends Fake implements Failure {}

void main() {
  late _MockMusicPlayerDataSource mockMusicPlayerDataSource;
  late _MockFailureFactory mockFailureFactory;
  late MusicPlayerRepositoryImpl repositoryImpl;

  setUpAll(() {
    registerFallbackValue(_FakeMusicPlayerPlayListEntity());
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    mockMusicPlayerDataSource = _MockMusicPlayerDataSource();
    mockFailureFactory = _MockFailureFactory();
    repositoryImpl = MusicPlayerRepositoryImpl(
      failureFactory: mockFailureFactory,
      musicPlayerDataSource: mockMusicPlayerDataSource,
    );
  });

  group("saveCurrentPlayList -", () {
    test("should call expected method of dataSource when invoked", () async {
      //arrange
      when(() => mockMusicPlayerDataSource.saveCurrentPlayList(any())).thenAnswer((_) async {});

      //act
      await repositoryImpl.saveCurrentPlayList(_FakeMusicPlayerPlayListEntity());

      //assert
      verify(() => mockMusicPlayerDataSource.saveCurrentPlayList(any())).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(
          () => mockMusicPlayerDataSource.saveCurrentPlayList(any()),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.saveCurrentPlayList(_FakeMusicPlayerPlayListEntity());
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockMusicPlayerDataSource.saveCurrentPlayList(any())).thenAnswer((_) async {});

      //act
      final result = await repositoryImpl.saveCurrentPlayList(_FakeMusicPlayerPlayListEntity());

      //assert
      expect(result.isRight(), true);
    });
  });
}
