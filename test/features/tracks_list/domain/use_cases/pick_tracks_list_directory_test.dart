import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class MockTracksListRepository extends Mock implements TracksListRepository {}

class FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {}

void main() {
  late MockTracksListRepository mockTracksListRepository;
  late PickTracksListDirectoryUC useCase;

  setUpAll(() {
    registerFallbackValue(SortTypeEnum.byModifiedDate);
  });

  setUp(() {
    mockTracksListRepository = MockTracksListRepository();
    useCase = PickTracksListDirectoryUC(repository: mockTracksListRepository);
  });

  test("should call expected method on the repository when invoked", () async {
    //arrange
    when(
      () => mockTracksListRepository.pickDirectory(any()),
    ).thenAnswer((_) async => right(FakeTracksListDirectoryEntity()));

    //act
    await useCase.call();

    //assert
    verify(() => mockTracksListRepository.pickDirectory(any())).called(1);
  });
}
