import 'package:flutter/foundation.dart';

class AudioItemEntity {
  final String path;
  final String? trackName;
  final Uint8List? albumArt;
  final Duration? duration;
  final List<String>? artistsNames;

  AudioItemEntity({
    required this.path,
    required this.trackName,
    required this.albumArt,
    required this.duration,
    required this.artistsNames,
  });
}
