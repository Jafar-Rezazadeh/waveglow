import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockFilePicker extends Mock implements FilePicker {}

void main() {
  group("dependencies -", () {
    test("should pu the expected controller to get", () {
      //act
      TracksListBindings(filePicker: _MockFilePicker()).dependencies();

      //assert
      expect(Get.isRegistered<TracksListStateController>(), true);
    });
  });
}
