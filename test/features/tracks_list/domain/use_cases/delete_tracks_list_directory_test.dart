import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListRepository extends Mock implements TracksListRepository {}

void main() {
  late DeleteTracksListDirectoryUC useCase;
  late _MockTracksListRepository mockTracksListRepository;

  setUp(() {
    mockTracksListRepository = _MockTracksListRepository();
    useCase = DeleteTracksListDirectoryUC(repository: mockTracksListRepository);
  });

  test("should call expected repository method when invoked", () async {
    //arrange
    when(() => mockTracksListRepository.deleteDir(any())).thenAnswer((_) async => right(null));

    //act
    await useCase.call("id");

    //assert
    verify(() => mockTracksListRepository.deleteDir("id")).called(1);
  });
}
