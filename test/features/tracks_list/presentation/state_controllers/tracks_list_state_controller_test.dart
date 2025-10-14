import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockPickTracksListDirectoryUC extends Mock implements PickTracksListDirectoryUC {}

class _MockMusicPlayerService extends Mock implements MusicPlayerService {}

class _MockCustomDialogs extends Mock implements CustomDialogs {}

class _FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {}

class _FakeFailure extends Fake implements Failure {}

class _FakeAudioItemEntity extends Fake implements AudioItemEntity {}

void main() {
  late _MockPickTracksListDirectoryUC mockPickTracksListDirectoryUC;
  late _MockMusicPlayerService mockMusicPlayerService;
  late _MockCustomDialogs mockCustomDialogs;
  late TracksListStateController controller;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(_FakeFailure());
    registerFallbackValue(<AudioItemEntity>[]);
  });

  setUp(() {
    mockPickTracksListDirectoryUC = _MockPickTracksListDirectoryUC();
    mockCustomDialogs = _MockCustomDialogs();
    mockMusicPlayerService = _MockMusicPlayerService();
    controller = TracksListStateController(
      customDialogs: mockCustomDialogs,
      musicPlayerService: mockMusicPlayerService,
      pickTracksListDirectoryUC: mockPickTracksListDirectoryUC,
    );
  });

  group("pickDirectory -", () {
    test("should call expected useCase", () async {
      //arrange
      when(
        () => mockPickTracksListDirectoryUC.call(any()),
      ).thenAnswer((_) async => right(_FakeTracksListDirectoryEntity()));

      //act
      await controller.pickDirectory();

      //assert
      verify(() => mockPickTracksListDirectoryUC.call(any())).called(1);
    });

    test("should call $CustomDialogs.showFailure result is a failure", () async {
      //arrange
      when(
        () => mockPickTracksListDirectoryUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));

      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.pickDirectory();

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test("should set result to allDirectories when success", () async {
      //arrange
      when(
        () => mockPickTracksListDirectoryUC.call(any()),
      ).thenAnswer((_) async => right(_FakeTracksListDirectoryEntity()));

      //act
      await controller.pickDirectory();

      //assert
      expect(controller.allDirectories, isNotEmpty);
    });
  });

  group("deleteDirectory -", () {
    test("should should remove the given directory from directories ", () {
      //arrange
      final directory = _FakeTracksListDirectoryEntity();
      controller.setAllDirectories = [directory];

      //act
      controller.removeDirectory(directory);

      //assert
      expect(controller.allDirectories, isEmpty);
    });
  });

  group("playTrack -", () {
    test("should call the expected service method ", () async {
      //arrange
      when(() => mockMusicPlayerService.open(any(), play: true)).thenAnswer((_) async {});

      //act
      await controller.playTrack(_FakeAudioItemEntity());

      //assert
      verify(() => mockMusicPlayerService.open(any(), play: true)).called(1);
    });
  });
}
