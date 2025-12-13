import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListRepository extends Mock implements TracksListRepository {}

void main() {
  late _MockTracksListRepository mockTracksListRepository;
  late TracksListSyncAudiosUC useCase;

  setUp(() {
    mockTracksListRepository = _MockTracksListRepository();
    useCase = TracksListSyncAudiosUC(repository: mockTracksListRepository);
  });

  test("should call expected method of repository when invoked", () async {
    //arrange
    when(() => mockTracksListRepository.syncAudios()).thenAnswer((_) async => right(null));

    //act
    await useCase.call(NoParams());

    //assert
    verify(() => mockTracksListRepository.syncAudios()).called(1);
  });
}
