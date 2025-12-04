import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class VisualizerFrequencyBandsModel extends VisualizerFrequencyBandsEntity {
  VisualizerFrequencyBandsModel({
    required super.subBass,
    required super.bass,
    required super.lowMid,
    required super.mid,
    required super.highMid,
    required super.presence,
    required super.brilliance,
    required super.loudness,
  });

  factory VisualizerFrequencyBandsModel.fromMap(Map<dynamic, dynamic> map) {
    return VisualizerFrequencyBandsModel(
      subBass: map["Sub-bass"],
      bass: map["Bass"],
      lowMid: map["Low-mid"],
      mid: map["Mid"],
      highMid: map["High-mid"],
      presence: map["Presence"],
      brilliance: map["Brilliance"],
      loudness: map["Loudness"],
    );
  }
}
