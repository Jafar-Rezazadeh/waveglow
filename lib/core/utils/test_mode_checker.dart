import 'dart:io';

class TestModeChecker {
  static bool isTestMode() {
    if (Platform.environment.containsKey("FLUTTER_TEST") &&
        Platform.environment["FLUTTER_TEST"] == "true") {
      return true;
    } else {
      return false;
    }
  }
}
