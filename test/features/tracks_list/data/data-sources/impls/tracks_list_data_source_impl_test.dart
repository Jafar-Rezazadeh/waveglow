import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/tracks_list/data/data-sources/impls/tracks_list_data_source_impl.dart';

class _MockFilePicker extends Mock implements FilePicker {}

class _MockDirectory extends Mock implements Directory {}

class _FakeFileSystemEntity extends Fake implements FileSystemEntity {
  final String tPath;

  _FakeFileSystemEntity({String? tPath}) : tPath = tPath ?? "";

  @override
  String get path => tPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockFilePicker mockFilePicker;
  late _MockDirectory mockDirectory;
  late TracksListDataSourceImpl dataSourceImpl;

  setUp(() {
    mockFilePicker = _MockFilePicker();
    mockDirectory = _MockDirectory();
    dataSourceImpl = TracksListDataSourceImpl(
      filePicker: mockFilePicker,
      directory: mockDirectory,
    );
  });

  group("pickDirectory -", () {
    test("should call expected functions to pick the folder path", () async {
      //arrange
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => null);

      //act
      await dataSourceImpl.pickDirectory();

      //assert
      verify(() => mockFilePicker.getDirectoryPath()).called(1);
    });

    test("should return null when directory not picked ", () async {
      //arrange
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => null);

      //act
      final result = await dataSourceImpl.pickDirectory();

      //assert
      expect(result, null);
    });

    test("should set the full directoryPath and directoryName(first char upperCase) to result",
        () async {
      //arrange
      const directoryPath = "c:\\testFolder";
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => directoryPath);

      when(
        () => mockDirectory.list(recursive: false, followLinks: false),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          _FakeFileSystemEntity(tPath: "c:\\test\\file1.mp3"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file2.wav"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file3.aac"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file4.m4a"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file5.flac"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file6.ogg"),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory();

      //assert
      expect(result?.directoryPath, directoryPath);
      expect(result?.directoryName, "Testfolder");
    });

    test("should call the expected directory function in case of getting audios inside ", () async {
      //arrange
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => "c:/test");

      when(
        () => mockDirectory.list(recursive: false, followLinks: false),
      ).thenAnswer((_) => Stream.fromIterable([_FakeFileSystemEntity()]));

      //act
      await dataSourceImpl.pickDirectory();

      //assert
      verify(() => mockDirectory.list(recursive: false, followLinks: false)).called(1);
    });

    test("should get any audio file which has expected extension and set it to result ", () async {
      //arrange

      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => "c:/test");
      when(
        () => mockDirectory.list(recursive: false, followLinks: false),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          _FakeFileSystemEntity(tPath: "c:\\test\\file1.mp3"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file2.wav"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file3.aac"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file4.m4a"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file5.flac"),
          _FakeFileSystemEntity(tPath: "c:\\test\\file6.ogg"),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory();

      //assert
      expect(result?.audios.length, 6);
    });

    test("should get the only audio files not other type of files", () async {
      //arrange
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => "c:/test");

      when(
        () => mockDirectory.list(recursive: false, followLinks: false),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          _FakeFileSystemEntity(tPath: "c:/test/file1.mp3"),
          _FakeFileSystemEntity(tPath: "c:/test/file2.wav"),
          _FakeFileSystemEntity(tPath: "c:/test/file3.pdf"),
          _FakeFileSystemEntity(tPath: "c:/test/file4.mp4"),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory();

      //assert
      expect(result?.audios.length, 2);
      expect(result?.audios.any((e) => e.path.endsWith(".pdf")), isFalse);
      expect(result?.audios.any((e) => e.path.endsWith(".mp4")), isFalse);
    });
  });
}
