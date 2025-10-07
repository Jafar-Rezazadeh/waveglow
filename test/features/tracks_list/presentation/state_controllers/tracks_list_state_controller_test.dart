import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockPickTracksListDirectoryUC extends Mock implements PickTracksListDirectoryUC {}

class _MockCustomDialogs extends Mock implements CustomDialogs {}

class _FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {}

class _FakeFailure extends Fake implements Failure {}

void main() {
  late _MockPickTracksListDirectoryUC mockPickTracksListDirectoryUC;
  late _MockCustomDialogs mockCustomDialogs;
  late TracksListStateController controller;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(_FakeFailure());
  });

  setUp(() {
    mockPickTracksListDirectoryUC = _MockPickTracksListDirectoryUC();
    mockCustomDialogs = _MockCustomDialogs();
    controller = TracksListStateController(
      customDialogs: mockCustomDialogs,
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

      when(
        () => mockCustomDialogs.showFailure(any()),
      ).thenAnswer((_) async {});

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
}
