import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/features/home/home_exports.dart';

void main() {
  group("fromMap -", () {
    test("should convert the map to $VisualizerBandsModel with expected values ", () async {
      //arrange
      final map = {
        "Sub-bass": 0.35,
        "Bass": 0.58,
        "Low-mid": 0.42,
        "Mid": 0.30,
        "High-mid": 0.27,
        "Presence": 0.19,
        "Brilliance": 0.14,
        "Loudness": 0.41
      };

      //act
      final result = VisualizerBandsModel.fromMap(map);

      //assert
      expect(result.subBass, map["Sub-bass"]);
      expect(result.bass, map["Bass"]);
      expect(result.lowMid, map["Low-mid"]);
      expect(result.mid, map["Mid"]);
      expect(result.highMid, map["High-mid"]);
      expect(result.presence, map["Presence"]);
      expect(result.brilliance, map["Brilliance"]);
      expect(result.loudness, map["Loudness"]);
    });
  });
}
