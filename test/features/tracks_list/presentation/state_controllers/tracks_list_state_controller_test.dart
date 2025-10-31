import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockPickTracksListDirectoryUC extends Mock implements PickTracksListDirectoryUC {}

class _MockMusicPlayerService extends Mock implements MusicPlayerService {}

class _MockCustomDialogs extends Mock implements CustomDialogs {}

class _MockSaveTracksListDirectoryUC extends Mock implements SaveTracksListDirectoryUC {}

class _MockDeleteTracksListDirectoryUC extends Mock implements DeleteTracksListDirectoryUC {}

class _MockGetTrackListDirectoriesUC extends Mock implements GetTrackListDirectoriesUC {}

class _MockIsTracksListDirectoryExistsUC extends Mock implements IsTracksListDirectoryExistsUC {}

class _FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {
  @override
  String get id => "id1";

  @override
  String get directoryPath => "dirPath";
}

class _FakeTracksListDirectoryTemplate extends Fake implements TracksListDirectoryTemplate {
  @override
  TracksListDirectoryEntity get dirEntity => _FakeTracksListDirectoryEntity();
}

class _FakeFailure extends Fake implements Failure {}

class _FakeAudioItemEntity extends Fake implements AudioItemEntity {}

void main() {
  late _MockPickTracksListDirectoryUC mockPickTracksListDirectoryUC;
  late _MockMusicPlayerService mockMusicPlayerService;
  late _MockCustomDialogs mockCustomDialogs;
  late _MockSaveTracksListDirectoryUC mockSaveTracksListDirectoryUC;
  late _MockGetTrackListDirectoriesUC mockGetTrackListDirectoriesUC;
  late _MockDeleteTracksListDirectoryUC mockDeleteTracksListDirectoryUC;
  late _MockIsTracksListDirectoryExistsUC mockIsTracksListDirectoryExistsUC;
  late TracksListStateController controller;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(_FakeFailure());
    registerFallbackValue(<AudioItemEntity>[]);
    registerFallbackValue(_FakeTracksListDirectoryEntity());
    registerFallbackValue(SortType.byModifiedDate);
  });

  setUp(() {
    Get.testMode = true;
    mockPickTracksListDirectoryUC = _MockPickTracksListDirectoryUC();
    mockCustomDialogs = _MockCustomDialogs();
    mockMusicPlayerService = _MockMusicPlayerService();
    mockSaveTracksListDirectoryUC = _MockSaveTracksListDirectoryUC();
    mockGetTrackListDirectoriesUC = _MockGetTrackListDirectoriesUC();
    mockDeleteTracksListDirectoryUC = _MockDeleteTracksListDirectoryUC();
    mockIsTracksListDirectoryExistsUC = _MockIsTracksListDirectoryExistsUC();
    controller = TracksListStateController(
      customDialogs: mockCustomDialogs,
      musicPlayerService: mockMusicPlayerService,
      pickTracksListDirectoryUC: mockPickTracksListDirectoryUC,
      saveDirectoryUC: mockSaveTracksListDirectoryUC,
      getDirectoriesUC: mockGetTrackListDirectoriesUC,
      deleteDirectoryUC: mockDeleteTracksListDirectoryUC,
      isDirectoryExistsUC: mockIsTracksListDirectoryExistsUC,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group("initData -", () {
    test("should call expected useCases via method when init", () {
      //arrange
      when(() => mockGetTrackListDirectoriesUC.call(any())).thenAnswer((_) async => right([]));

      //act
      controller.initData();

      //assert
      verify(() => mockGetTrackListDirectoriesUC.call(any())).called(1);
    });
  });

  group("pickDirectory -", () {
    test("should call expected useCase", () async {
      //arrange
      when(
        () => mockPickTracksListDirectoryUC.call(any()),
      ).thenAnswer((_) async => right(_FakeTracksListDirectoryEntity()));

      when(() => mockSaveTracksListDirectoryUC.call(any())).thenAnswer((_) async => right(null));

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

      when(() => mockSaveTracksListDirectoryUC.call(any())).thenAnswer((_) async => right(null));

      //act
      await controller.pickDirectory();

      //assert
      expect(controller.allDirectories, isNotEmpty);
    });

    test(
      "should call expected uceCase to save picked directory when success with a directory",
      () async {
        //arrange
        when(
          () => mockPickTracksListDirectoryUC.call(any()),
        ).thenAnswer((_) async => right(_FakeTracksListDirectoryEntity()));

        when(() => mockSaveTracksListDirectoryUC.call(any())).thenAnswer((_) async => right(null));

        //act
        await controller.pickDirectory();

        //assert
        verify(() => mockSaveTracksListDirectoryUC.call(any())).called(1);
      },
    );
  });

  group("deleteDirectory -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockDeleteTracksListDirectoryUC.call(any())).thenAnswer((_) async => right(null));

      //act
      await controller.removeDirectory(_FakeTracksListDirectoryTemplate());

      //assert
      verify(() => mockDeleteTracksListDirectoryUC.call(any())).called(1);
    });

    test("should call customDialogs.showFailure when result is a failure", () async {
      //arrange
      when(
        () => mockDeleteTracksListDirectoryUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.removeDirectory(_FakeTracksListDirectoryTemplate());

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test(
      "should should remove the given directory from directories when result is success",
      () async {
        //arrange
        when(
          () => mockDeleteTracksListDirectoryUC.call(any()),
        ).thenAnswer((_) async => right(null));

        final directory = _FakeTracksListDirectoryTemplate();

        controller.setAllDirectories = [directory];

        //act
        await controller.removeDirectory(directory);

        //assert
        expect(controller.allDirectories, isEmpty);
      },
    );
  });

  group("playTrack -", () {
    test(
      "should call musicService.openPlaylist when given dir is different from current",
      () async {
        //arrange
        controller.setCurrentDirKey = "1";
        when(
          () => mockMusicPlayerService.openPlayList(any(), play: false),
        ).thenAnswer((_) async {});
        when(() => mockMusicPlayerService.currentPlaylist).thenAnswer((_) => []);

        //act
        await controller.playTrack(_FakeAudioItemEntity(), "0");

        //assert
        verify(() => mockMusicPlayerService.openPlayList(any(), play: false)).called(1);
      },
    );

    test(
      "should get all songs of directory and call musicService.openPlaylist when musicPlayer playlist is empty",
      () async {
        //arrange
        controller.setCurrentDirKey = "1";
        when(
          () => mockMusicPlayerService.openPlayList(any(), play: false),
        ).thenAnswer((_) async {});
        when(() => mockMusicPlayerService.currentPlaylist).thenAnswer((_) => []);

        //act
        await controller.playTrack(_FakeAudioItemEntity(), controller.currentPlayingMusicDirId!);

        //assert
        verify(() => mockMusicPlayerService.openPlayList(any(), play: false)).called(1);
      },
    );

    test(
      "should Not call musicService.openPlaylist when given dir == currentDir and musicPlayer.currentPlaylist is not empty",
      () async {
        //arrange
        controller.setCurrentDirKey = "1";
        when(
          () => mockMusicPlayerService.openPlayList(any(), play: false),
        ).thenAnswer((_) async {});
        when(
          () => mockMusicPlayerService.currentPlaylist,
        ).thenAnswer((_) => [_FakeAudioItemEntity()]);

        //act
        await controller.playTrack(_FakeAudioItemEntity(), controller.currentPlayingMusicDirId!);

        //assert
        verifyNever(() => mockMusicPlayerService.openPlayList(any(), play: false));
      },
    );

    test("should call musicService.playAt when given item is found on currentPlaylist", () async {
      //arrange
      final item = _FakeAudioItemEntity();
      controller.setCurrentDirKey = "1";
      when(() => mockMusicPlayerService.openPlayList(any(), play: false)).thenAnswer((_) async {});
      when(() => mockMusicPlayerService.currentPlaylist).thenAnswer((_) => [item]);
      when(() => mockMusicPlayerService.playAt(any())).thenAnswer((_) async {});

      //act
      await controller.playTrack(item, controller.currentPlayingMusicDirId!);

      //assert
      verify(() => mockMusicPlayerService.playAt(any())).called(1);
    });

    test("should NOT call musicService.playAt when given item is Not on currentPlaylist", () async {
      //arrange
      controller.setCurrentDirKey = "1";
      when(() => mockMusicPlayerService.openPlayList(any(), play: false)).thenAnswer((_) async {});
      when(() => mockMusicPlayerService.currentPlaylist).thenAnswer((_) => []);
      when(() => mockMusicPlayerService.playAt(any())).thenAnswer((_) async {});

      //act
      await controller.playTrack(_FakeAudioItemEntity(), controller.currentPlayingMusicDirId!);

      //assert
      verifyNever(() => mockMusicPlayerService.playAt(any()));
    });
  });

  group("saveDirectory -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockSaveTracksListDirectoryUC.call(any())).thenAnswer((_) async => right(null));

      //act
      await controller.saveDirectory(_FakeTracksListDirectoryEntity());

      //assert
      verify(() => mockSaveTracksListDirectoryUC.call(any())).called(1);
    });

    test("should call $CustomDialogs.showFailure when result is a failure", () async {
      //arrange
      when(
        () => mockSaveTracksListDirectoryUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));

      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.saveDirectory(_FakeTracksListDirectoryEntity());

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });
  });

  group("getDirectories -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockGetTrackListDirectoriesUC.call(any())).thenAnswer((_) async => right([]));

      //act
      await controller.getDirectories();

      //assert
      verify(() => mockGetTrackListDirectoriesUC.call(any())).called(1);
    });

    test("should call $CustomDialogs.showFailure when result is a failure", () async {
      //arrange
      when(
        () => mockGetTrackListDirectoriesUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));

      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.getDirectories();

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test(
      "should call expected useCase to check does that directory exists or not when success",
      () async {
        //arrange
        when(() => mockGetTrackListDirectoriesUC.call(any())).thenAnswer(
          (_) async => right([_FakeTracksListDirectoryEntity(), _FakeTracksListDirectoryEntity()]),
        );
        when(
          () => mockIsTracksListDirectoryExistsUC.call(any()),
        ).thenAnswer((_) async => right(true));

        //act
        await controller.getDirectories();

        //assert
        verify(() => mockIsTracksListDirectoryExistsUC.call(any())).called(2);
      },
    );

    test("should add the result to controller variable when success", () async {
      //arrange
      when(() => mockGetTrackListDirectoriesUC.call(any())).thenAnswer(
        (_) async => right([_FakeTracksListDirectoryEntity(), _FakeTracksListDirectoryEntity()]),
      );
      when(
        () => mockIsTracksListDirectoryExistsUC.call(any()),
      ).thenAnswer((_) async => right(true));

      //act
      await controller.getDirectories();

      //assert
      expect(controller.allDirectories.length, 2);
    });
  });

  group("isExistedDirectories -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(
        () => mockIsTracksListDirectoryExistsUC.call(any()),
      ).thenAnswer((_) async => right(true));

      //act
      await controller.isExistedDirectories("dirPath");

      //assert
      verify(() => mockIsTracksListDirectoryExistsUC.call(any())).called(1);
    });

    test("should return false when result is left (failure)", () async {
      //arrange
      when(
        () => mockIsTracksListDirectoryExistsUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));

      //act
      final result = await controller.isExistedDirectories("dirPath");

      //assert
      expect(result, false);
    });

    test("should return expected result when success", () async {
      //arrange
      when(
        () => mockIsTracksListDirectoryExistsUC.call(any()),
      ).thenAnswer((_) async => right(true));

      //act
      final result = await controller.isExistedDirectories("dirPath");

      //assert
      expect(result, true);
    });
  });
}
