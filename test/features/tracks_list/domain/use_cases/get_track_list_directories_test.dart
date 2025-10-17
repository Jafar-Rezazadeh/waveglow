import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListRepository extends Mock implements TracksListRepository {}

void main() {
  late _MockTracksListRepository mockRepository;
  late GetTrackListDirectoriesUC useCase;

  setUp(() {
    mockRepository = _MockTracksListRepository();
    useCase = GetTrackListDirectoriesUC(repository: mockRepository);
  });

  test("should call expected repository method when invoked", () async {
    //arrange
    when(() => mockRepository.getDirectories()).thenAnswer((_) async => right([]));

    //act
    await useCase.call(NoParams());

    //assert
    verify(() => mockRepository.getDirectories()).called(1);
  });
}
