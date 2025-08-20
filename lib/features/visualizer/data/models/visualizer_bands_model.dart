import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class VisualizerBandsModel extends VisualizerBandsEntity {
  VisualizerBandsModel({
    required super.subBass,
    required super.bass,
    required super.lowMid,
    required super.mid,
    required super.highMid,
    required super.presence,
    required super.brilliance,
    required super.loudness,
  });

  factory VisualizerBandsModel.fromMap(Map<dynamic, dynamic> map) {
    return VisualizerBandsModel(
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
