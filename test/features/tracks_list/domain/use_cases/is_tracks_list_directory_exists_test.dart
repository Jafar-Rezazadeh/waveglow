import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListRepository extends Mock implements TracksListRepository {}

void main() {
  late IsTracksListDirectoryExistsUC useCase;
  late _MockTracksListRepository mockTracksListRepository;

  setUp(() {
    mockTracksListRepository = _MockTracksListRepository();
    useCase = IsTracksListDirectoryExistsUC(repository: mockTracksListRepository);
  });

  test("should call expected method of the repository when invoked", () async {
    //arrange
    when(
      () => mockTracksListRepository.isDirectoryExists(any()),
    ).thenAnswer((_) async => right(true));

    //act
    await useCase.call("dirPath");

    //assert
    verify(() => mockTracksListRepository.isDirectoryExists(any())).called(1);
  });
}
