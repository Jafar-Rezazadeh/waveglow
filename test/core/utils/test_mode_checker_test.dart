import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/core/utils/test_mode_checker.dart';

void main() {
  group("isTestMode -", () {
    test("should return true when in test mode ", () {
      //arrange

      //act
      final result = TestModeChecker.isTestMode();

      //assert
      expect(result, true);
    });
  });
}
