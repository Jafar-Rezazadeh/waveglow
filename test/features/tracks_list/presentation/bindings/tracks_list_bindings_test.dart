import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/services/music_player_service.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockFilePicker extends Mock implements FilePicker {}

class _MockMusicPlayerService extends Mock implements MusicPlayerService {}

class _MockBox extends Mock implements Box<TracksListDirectoryEntity> {}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<MusicPlayerService>(_MockMusicPlayerService());
  });

  tearDown(() {
    Get.reset();
  });

  group("dependencies -", () {
    test("should pu the expected controller to get", () {
      //act
      TracksListBindings(filePicker: _MockFilePicker(), testBox: _MockBox()).dependencies();

      //assert
      expect(Get.isRegistered<TracksListStateController>(), true);
    });
  });
}
