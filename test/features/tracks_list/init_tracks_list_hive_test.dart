import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/init_tracks_list_hive.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockHiveInterface extends Mock implements HiveInterface {}

class _FakeBox extends Fake implements Box<TracksListDirectoryModel> {}

void main() {
  late _MockHiveInterface mockHiveInterface;

  setUp(() {
    mockHiveInterface = _MockHiveInterface();
  });

  test("should call expected hive open Box when invoked", () async {
    //arrange
    when(
      () => mockHiveInterface.openBox<TracksListDirectoryModel>(HiveBoxesName.tracksList),
    ).thenAnswer((_) async => _FakeBox());

    //act
    await initTracksListHive(mockHiveInterface);

    //assert
    verify(
      () => mockHiveInterface.openBox<TracksListDirectoryModel>(HiveBoxesName.tracksList),
    ).called(1);
  });
}
