import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
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
      ).thenAnswer((_) async => "c:/testFolder");

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

    test("should set the full directoryPath and directoryName to result", () async {
      //arrange
      const directoryPath = "c:/testFolder";
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => directoryPath);

      //act
      final result = await dataSourceImpl.pickDirectory();

      //assert
      expect(result?.directoryPath, directoryPath);
      expect(result?.directoryName, "testFolder");
    });

    test("should call the expected directory function in case of getting audios inside ", () async {
      //arrange
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => "c:/test");

      when(
        () => mockDirectory.list(recursive: true, followLinks: false),
      ).thenAnswer((_) => Stream.fromIterable([_FakeFileSystemEntity()]));

      //act
      await dataSourceImpl.pickDirectory();

      //assert
      verify(() => mockDirectory.list(recursive: true, followLinks: false)).called(1);
    });

    test(
        "should get any audio file which has expected extension and get its metaData and set it to result ",
        () async {
      //arrange
      _mockMetaDataReceiverMethodChannel();

      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => "c:/test");
      when(
        () => mockDirectory.list(recursive: true, followLinks: false),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          _FakeFileSystemEntity(tPath: "c:/test/file1.mp3"),
          _FakeFileSystemEntity(tPath: "c:/test/file2.wav"),
          _FakeFileSystemEntity(tPath: "c:/test/file3.aac"),
          _FakeFileSystemEntity(tPath: "c:/test/file4.m4a"),
          _FakeFileSystemEntity(tPath: "c:/test/file5.flac"),
          _FakeFileSystemEntity(tPath: "c:/test/file6.ogg"),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory();

      //assert
      expect(result?.audios.length, 6);
    });

    test("should only get the audio files not of selected directory not other type of files",
        () async {
      //arrange
      _mockMetaDataReceiverMethodChannel();

      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => "c:/test");

      when(
        () => mockDirectory.list(recursive: true, followLinks: false),
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

void _mockMetaDataReceiverMethodChannel() {
  TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel("flutter_media_metadata"),
    (methodCall) {
      if (methodCall.method == "MetadataRetriever") {
        // The plugin expects a map shaped like:
        // {
        //   'metadata': { 'trackName': ..., 'trackArtistNames': 'A/B', 'trackDuration': '123' , ...},
        //   'genre': ...,
        //   'albumArt': null,
        //   'filePath': ...,
        // }
        return Future.value({
          'metadata': {
            'trackName': 'Test Track',
            // plugin splits trackArtistNames by '/'
            'trackArtistNames': 'Artist1/Artist2',
            'trackDuration': '180000', // in ms as string
            'mimeType': 'audio/mpeg',
          },
          'genre': 'Pop',
          'albumArt': null,
          'filePath': 'c:/test/file1.mp3',
        });
      }
      return null;
    },
  );
}
