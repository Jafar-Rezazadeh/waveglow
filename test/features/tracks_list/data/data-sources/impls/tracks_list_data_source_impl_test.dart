import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockFilePicker extends Mock implements FilePicker {}

class _MockDirectory extends Mock implements Directory {}

class _MockBox extends Mock implements Box<TracksListDirectoryModel> {}

class _FakeFileSystemEntity extends Fake implements FileSystemEntity {
  final String tPath;

  _FakeFileSystemEntity({String? tPath}) : tPath = tPath ?? "";

  @override
  String get path => tPath;
}

class _FakeTracksListDirectoryModel extends Fake implements TracksListDirectoryModel {
  final String idT;
  final List<AudioItemModel>? audioT;

  _FakeTracksListDirectoryModel({this.idT = "id", this.audioT});

  @override
  String get id => idT;

  @override
  String get directoryPath => "c:\\test";

  @override
  List<AudioItemModel> get audios => audioT ?? [];
}

class _FakeAudioItemModel extends Fake implements AudioItemModel {
  final DateTime? modifiedDateT;
  final String? trackNameT;
  final bool isFavoriteT;
  final String pathT;

  _FakeAudioItemModel({
    this.modifiedDateT,
    this.trackNameT,
    this.isFavoriteT = false,
    this.pathT = "",
  });
  @override
  String? get trackName => trackNameT;

  @override
  String get modifiedDate => modifiedDateT?.toIso8601String() ?? "";

  @override
  bool get isFavorite => isFavoriteT;

  @override
  String get path => pathT;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockFilePicker mockFilePicker;
  late _MockBox mockBox;
  late _MockDirectory mockDirectory;
  late TracksListDataSourceImpl dataSourceImpl;

  setUpAll(() {
    registerFallbackValue(_FakeTracksListDirectoryModel());
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
      await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

      //assert
      verify(() => mockFilePicker.getDirectoryPath()).called(1);
    });

    test("should return null when directory not picked ", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => null);

      //act
      final result = await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

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
        final result = await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

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
      await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

      //assert
      verify(() => mockDirectory.list(recursive: false, followLinks: false)).called(1);
    });

    test("should only get $File types not other stuffs from picked directory", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => "c:/test");
      when(() => mockDirectory.list(recursive: false, followLinks: false)).thenAnswer(
        (_) => Stream.fromIterable([
          File("c:\\test\\file1.mp3"),
          File("c:\\test\\file2.wav"),
          _FakeFileSystemEntity(),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

      //assert
      expect(result?.audios.length, 2);
    });

    test("should get any audio file which has expected extension and set it to result ", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => "c:/test");
      when(() => mockDirectory.list(recursive: false, followLinks: false)).thenAnswer(
        (_) => Stream.fromIterable([
          File("c:\\test\\file1.mp3"),
          File("c:\\test\\file2.wav"),
          File("c:\\test\\file3.aac"),
          File("c:\\test\\file4.m4a"),
          File("c:\\test\\file5.flac"),
          File("c:\\test\\file6.ogg"),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

      //assert
      expect(result?.audios.length, 6);
    });

    test("should get the only audio files not other type of files", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => "c:/test");

      when(() => mockDirectory.list(recursive: false, followLinks: false)).thenAnswer(
        (_) => Stream.fromIterable([
          File("c:/test/file1.mp3"),
          File("c:/test/file2.wav"),
          File("c:/test/file3.pdf"),
          File("c:/test/file4.mp4"),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

      //assert
      expect(result?.audios.length, 2);
      expect(result?.audios.any((e) => e.path.endsWith(".pdf")), isFalse);
      expect(result?.audios.any((e) => e.path.endsWith(".mp4")), isFalse);
    });

    test(
      "should sort the files bases on modified date when given $SortType.byModifiedDate",
      () async {
        //arrange
        _setMetaReceiverMethodChannel();

        final dir = await Directory.current.createTemp('file_sort_test_');

        final file1 = await File('${dir.path}/file1.mp3').writeAsBytes([0]);
        final file2 = await File('${dir.path}/file2.mp3').writeAsBytes([0]);
        final file3 = await File('${dir.path}/file3.mp3').writeAsBytes([0]);

        // set fake modified times
        final oldDate = DateTime(2000, 1, 1);
        final midDate = DateTime(2010, 1, 1);
        final newDate = DateTime(2020, 1, 1);

        await file1.setLastModified(oldDate);
        await file2.setLastModified(newDate);
        await file3.setLastModified(midDate);

        when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => dir.path);
        when(
          () => mockDirectory.list(recursive: false, followLinks: false),
        ).thenAnswer((_) => Stream.fromIterable([file1, file2, file3]));

        //act
        final result = await dataSourceImpl.pickDirectory(SortType.byModifiedDate);

        //assert
        expect(result?.audios.first.modifiedDate, newDate.toIso8601String());

        // cleanUp
        await dir.delete(recursive: true);
      },
    );

    test("should sort the files bases on it names when given $SortType.byTitle", () async {
      //arrange
      _setMetaReceiverMethodChannel();

      when(() => mockFilePicker.getDirectoryPath()).thenAnswer((_) async => "c:/test/");
      when(() => mockDirectory.list(recursive: false, followLinks: false)).thenAnswer(
        (_) => Stream.fromIterable([
          File("c:/test/file3.mp3"),
          File("c:/test/file1.mp3"),
          File("c:/test/file2.mp3"),
        ]),
      );

      //act
      final result = await dataSourceImpl.pickDirectory(SortType.byTitle);

      //assert
      expect(result?.audios.first.trackName, "file1.mp3");
    });
  });

  group("saveDirectory -", () {
    test("should call hive.add when invoked", () async {
      //arrange
      when(() => mockBox.add(any())).thenAnswer((_) async => 0);

      //act
      await dataSourceImpl.saveDirectory(_FakeTracksListDirectoryModel());

      //assert
      verify(() => mockBox.add(any())).called(1);
    });
  });

  group("getDirectories -", () {
    test("should call expected method of box to get directories", () async {
      //arrange
      when(() => mockBox.values).thenAnswer((_) => [_FakeTracksListDirectoryModel()]);

      //act
      await dataSourceImpl.getDirectories(SortType.byModifiedDate);

      //assert
      verify(() => mockBox.values).called(1);
    });

    test("should return expected result when success", () async {
      //arrange
      when(() => mockBox.values).thenAnswer((_) => [_FakeTracksListDirectoryModel()]);

      //act
      final result = await dataSourceImpl.getDirectories(SortType.byModifiedDate);

      //assert
      expect(result.length, 1);
    });

    test("should sort the audio based on given $SortType", () async {
      //arrange
      when(() => mockBox.values).thenAnswer(
        (_) => [
          _FakeTracksListDirectoryModel(
            audioT: [
              _FakeAudioItemModel(
                modifiedDateT: DateTime(2030),
                trackNameT: "file4",
                isFavoriteT: false,
              ),
              _FakeAudioItemModel(
                modifiedDateT: DateTime(2000),
                trackNameT: "file1",
                isFavoriteT: false,
              ),
              _FakeAudioItemModel(
                modifiedDateT: DateTime(2050),
                trackNameT: "file2",
                isFavoriteT: true,
              ),
              _FakeAudioItemModel(
                modifiedDateT: DateTime(2010),
                trackNameT: "file3",
                isFavoriteT: false,
              ),
            ],
          ),
        ],
      );

      //act
      final resultByModified = await dataSourceImpl.getDirectories(SortType.byModifiedDate);
      final resultByTitle = await dataSourceImpl.getDirectories(SortType.byTitle);
      final resultByFavorite = await dataSourceImpl.getDirectories(SortType.byFavorite);

      //assert
      expect(DateTime.parse(resultByModified.first.audios.first.modifiedDate), DateTime(2050));
      expect(resultByTitle.first.audios.first.trackName, "file1");
      expect(resultByFavorite.first.audios.first.trackName, "file2");
    });
  });

  group("deleteDir -", () {
    test(
      "should call expected method to find the expected key of item based on given id when invoked ",
      () async {
        //arrange
        when(() => mockBox.keys).thenAnswer((_) => [0, 1, 2, 3, 4]);

        //act
        await dataSourceImpl.deleteDir("id");

        //assert
        verify(() => mockBox.keys).called(1);
        verify(() => mockBox.get(any())).called(greaterThan(1));
      },
    );

    test("should call expected method delete item when key is find by given id ", () async {
      //arrange
      const id = "id1";
      when(() => mockBox.keys).thenAnswer((_) => [0, 1, 2, 3, 4]);
      when(() => mockBox.get(any())).thenAnswer((_) => _FakeTracksListDirectoryModel(idT: id));
      when(() => mockBox.delete(any())).thenAnswer((_) async {});
      //act
      await dataSourceImpl.deleteDir(id);

      //assert
      verify(() => mockBox.delete(any())).called(1);
    });

    test("should NOT call expected method when key is NOT find", () async {
      //arrange
      const id = "id1";
      when(() => mockBox.keys).thenAnswer((_) => [0, 1, 2, 3, 4]);
      when(() => mockBox.get(any())).thenAnswer((_) => null);
      when(() => mockBox.delete(any())).thenAnswer((_) async {});
      //act
      await dataSourceImpl.deleteDir(id);

      //assert
      verifyNever(() => mockBox.delete(any()));
    });
  });

  group("isDirectoryExists -", () {
    test("should expected method and return expected result when invoked", () async {
      //arrange
      when(() => mockDirectory.exists()).thenAnswer((_) async => true);

      //act
      await dataSourceImpl.isDirectoryExists("dirPath");

      //assert
      verify(() => mockDirectory.exists()).called(1);
    });
  });

  group("syncAudios -", () {
    test("should call expected box to get saved directories when invoked", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockBox.values).thenAnswer((_) => [_FakeTracksListDirectoryModel(audioT: [])]);
      when(() => mockDirectory.exists()).thenAnswer((_) async => true);
      when(() => mockDirectory.listSync()).thenAnswer((_) => [File("test1")]);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
      when(() => mockBox.keys).thenAnswer((_) => []);

      //act
      await dataSourceImpl.syncAudios();

      //assert
      verify(() => mockBox.values).called(1);
    });

    test("should get each directory audio files when folder exists", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockBox.values).thenAnswer((_) => [_FakeTracksListDirectoryModel()]);
      when(() => mockDirectory.exists()).thenAnswer((_) async => true);
      when(() => mockDirectory.listSync()).thenAnswer((_) => [File("path")]);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
      when(() => mockBox.keys).thenAnswer((_) => []);

      //act
      await dataSourceImpl.syncAudios();

      //assert
      verify(() => mockDirectory.listSync()).called(1);
    });

    test("should return when directory not exists", () async {
      //arrange
      _setMetaReceiverMethodChannel();
      when(() => mockBox.values).thenAnswer((_) => [_FakeTracksListDirectoryModel(audioT: [])]);
      when(() => mockDirectory.exists()).thenAnswer((_) async => false);

      //act
      await dataSourceImpl.syncAudios();

      //assert
      verifyNever(() => mockDirectory.listSync());
    });

    test("should sync new audio files to saved directory when system has new files", () async {
      //arrange
      final newFile1 = File("test1.mp3");
      final newFile2 = File("test2.mp3");
      final existedFilePath = "test.mp3";
      _setMetaReceiverMethodChannel();
      when(() => mockBox.values).thenAnswer(
        (_) => [
          _FakeTracksListDirectoryModel(audioT: [_FakeAudioItemModel(pathT: existedFilePath)]),
        ],
      );
      when(() => mockDirectory.exists()).thenAnswer((_) async => true);
      when(
        () => mockDirectory.listSync(),
      ).thenAnswer((_) => [File(existedFilePath), newFile1, newFile2]);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
      when(() => mockBox.keys).thenAnswer((_) => []);

      //act
      await dataSourceImpl.syncAudios();

      //assert
      verify(
        () => mockBox.put(
          any(),
          any(
            that: isA<_FakeTracksListDirectoryModel>().having(
              (dir) {
                final allFilePaths = dir.audios.map((e) => e.path);

                return allFilePaths.contains(newFile1.path) &&
                    allFilePaths.contains(newFile2.path) &&
                    allFilePaths.contains(existedFilePath);
              },
              "has new audio",
              true,
            ),
          ),
        ),
      ).called(1);
    });

    test("should not call expected functionality when no new file was in the system", () async {
      //arrange
      final existedFile = File("test.mp3");

      _setMetaReceiverMethodChannel();
      when(() => mockBox.values).thenAnswer(
        (_) => [
          _FakeTracksListDirectoryModel(audioT: [_FakeAudioItemModel(pathT: "test.mp3")]),
        ],
      );
      when(() => mockDirectory.exists()).thenAnswer((_) async => true);
      when(() => mockDirectory.listSync()).thenAnswer((_) => [existedFile]);

      //act
      await dataSourceImpl.syncAudios();

      //assert
      verifyNever(() => mockBox.put(any(), any()));
    });

    test(
      "should call expected box functionality to  delete audio files that are not exists in the system any more",
      () async {
        //arrange
        final existedFilePath = "test.mp3";
        final notExistedFile1 = "test1.mp3";
        final notExistedFile2 = "test2.mp3";
        _setMetaReceiverMethodChannel();
        when(() => mockBox.values).thenAnswer(
          (_) => [
            _FakeTracksListDirectoryModel(
              audioT: [
                _FakeAudioItemModel(pathT: existedFilePath),
                _FakeAudioItemModel(pathT: notExistedFile1),
                _FakeAudioItemModel(pathT: notExistedFile2),
              ],
            ),
          ],
        );
        when(() => mockDirectory.exists()).thenAnswer((_) async => true);
        when(() => mockDirectory.listSync()).thenAnswer((_) => [File(existedFilePath)]);
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
        when(() => mockBox.keys).thenAnswer((_) => []);

        //act
        await dataSourceImpl.syncAudios();

        //assert
        verify(
          () => mockBox.put(
            any(),
            any(
              that: isA<_FakeTracksListDirectoryModel>().having(
                (dir) {
                  return dir.audios.any((e) => e.path == existedFilePath) && dir.audios.length == 1;
                },
                "has new audio",
                true,
              ),
            ),
          ),
        ).called(1);
      },
    );

    test("should Not call box.put when there is not any removed file from system", () async {
      //arrange
      final existedFilePath = "test.mp3";
      final existedFile1 = "test1.mp3";
      final existedFile2 = "test2.mp3";
      _setMetaReceiverMethodChannel();
      when(() => mockBox.values).thenAnswer(
        (_) => [
          _FakeTracksListDirectoryModel(
            audioT: [
              _FakeAudioItemModel(pathT: existedFilePath),
              _FakeAudioItemModel(pathT: existedFile1),
              _FakeAudioItemModel(pathT: existedFile2),
            ],
          ),
        ],
      );
      when(() => mockDirectory.exists()).thenAnswer((_) async => true);
      when(
        () => mockDirectory.listSync(),
      ).thenAnswer((_) => [File(existedFilePath), File(existedFile1), File(existedFile2)]);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      //act
      await dataSourceImpl.syncAudios();

      //assert
      verifyNever(() => mockBox.put(any(), any()));
    });
  });
}

void _setMetaReceiverMethodChannel() {
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
