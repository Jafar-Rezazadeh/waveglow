import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListRepository extends Mock implements TracksListRepository {}

class _FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {}

void main() {
  late _MockTracksListRepository mockTracksListRepository;
  late SaveTracksListDirectoryUC useCase;

  setUpAll(() {
    registerFallbackValue(_FakeTracksListDirectoryEntity());
  });

  setUp(() {
    mockTracksListRepository = _MockTracksListRepository();
    useCase = SaveTracksListDirectoryUC(repository: mockTracksListRepository);
  });

  test("should invoke expected method of the repository ", () async {
    //arrange
    when(() => mockTracksListRepository.saveDirectory(any())).thenAnswer((_) async => right(null));

    //act
    await useCase.call(_FakeTracksListDirectoryEntity());

    //assert
    verify(() => mockTracksListRepository.saveDirectory(any())).called(1);
  });
}
