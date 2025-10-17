import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/tracks_list/data/data-sources/impls/tracks_list_data_source_impl.dart';
import 'package:waveglow/features/tracks_list/domain/entities/tracks_list_directory_entity.dart';

class _MockFilePicker extends Mock implements FilePicker {}

class _MockDirectory extends Mock implements Directory {}

class _MockBox extends Mock implements Box<TracksListDirectoryEntity> {}

class _FakeFileSystemEntity extends Fake implements FileSystemEntity {
  final String tPath;

  _FakeFileSystemEntity({String? tPath}) : tPath = tPath ?? "";

  @override
  String get path => tPath;
}

class _FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockFilePicker mockFilePicker;
  late _MockBox mockBox;
  late _MockDirectory mockDirectory;
  late TracksListDataSourceImpl dataSourceImpl;

  setUpAll(() {
    registerFallbackValue(_FakeTracksListDirectoryEntity());
  });

  setUp(() {
    mockFilePicker = _MockFilePicker();
    mockDirectory = _MockDirectory();
    mockBox = _MockBox();
    dataSourceImpl = TracksListDataSourceImpl(
      filePicker: mockFilePicker,
      directory: mockDirectory,
      testBox: mockBox,
    );
  });

  group("pickDirectory -", () {
    test("should call expected functions to pick the folder path", () async {
      //arrange
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => null);

      //act
      await dataSourceImpl.pickDirectory();

      //assert
      verify(() => mockFilePicker.getDirectoryPath()).called(1);
    });

    test("should return null when directory not picked ", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => null);

      //act
      final result = await dataSourceImpl.pickDirectory();

      //assert
      expect(result, null);
    });

    test(
      "should set the full directoryPath and directoryName(first char upperCase) to result",
      () async {
        //arrange
        const directoryPath = "c:\\testFolder";
        when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => directoryPath);

        _setMetaReceiverMethodChannel();

        when(() => mockDirectory.list(recursive: false, followLinks: false)).thenAnswer(
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
      },
    );

    test("should call the expected directory function in case of getting audios inside ", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => "c:/test");

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
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => "c:/test");
      when(() => mockDirectory.list(recursive: false, followLinks: false)).thenAnswer(
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
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => "c:/test");

      when(() => mockDirectory.list(recursive: false, followLinks: false)).thenAnswer(
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

  group("saveDirectory -", () {
    test("should call hive.add when invoked", () async {
      //arrange
      when(() => mockBox.add(any())).thenAnswer((_) async => 0);

      //act
      await dataSourceImpl.saveDirectory(_FakeTracksListDirectoryEntity());

      //assert
      verify(() => mockBox.add(any())).called(1);
    });
  });

  group("getDirectories -", () {
    test("should call expected method of box to get directories", () async {
      //arrange
      when(() => mockBox.values).thenAnswer((_) => [_FakeTracksListDirectoryEntity()]);

      //act
      await dataSourceImpl.getDirectories();

      //assert
      verify(() => mockBox.values).called(1);
    });

    test("should return expected result when success", () async {
      //arrange
      when(() => mockBox.values).thenAnswer((_) => [_FakeTracksListDirectoryEntity()]);

      //act
      final result = await dataSourceImpl.getDirectories();

      //assert
      expect(result.length, 1);
    });
  });
}

_setMetaReceiverMethodChannel() {
  TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel("flutter_media_metadata"),
    (message) {
      if (message.method == "MetadataRetriever") {
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
          'filePath': 'c:\\test\\file1.mp3',
        });
      }
      return null;
    },
  );
}
