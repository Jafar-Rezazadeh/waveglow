import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/tracks_list/domain/entities/tracks_list_directory_entity.dart';
import 'package:waveglow/features/tracks_list/init_tracks_list_hive.dart';
import 'package:waveglow/features/tracks_list/tracks_list_constants.dart';

class _MockHiveInterface extends Mock implements HiveInterface {}

class _FakeBox extends Fake implements Box<TracksListDirectoryEntity> {}

void main() {
  late _MockHiveInterface mockHiveInterface;

  setUp(() {
    mockHiveInterface = _MockHiveInterface();
  });

  test("should call expected hive open Box when invoked", () async {
    //arrange
    when(
      () => mockHiveInterface.openBox<TracksListDirectoryEntity>(
        TracksListConstants.tracksListDirectoryBoxName,
      ),
    ).thenAnswer((_) async => _FakeBox());

    //act
    await initTracksListHive(mockHiveInterface);

    //assert
    verify(
      () => mockHiveInterface.openBox<TracksListDirectoryEntity>(
        TracksListConstants.tracksListDirectoryBoxName,
      ),
    ).called(1);
  });
}
