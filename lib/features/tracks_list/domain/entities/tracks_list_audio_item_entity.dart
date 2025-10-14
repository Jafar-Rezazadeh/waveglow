import 'package:flutter/foundation.dart';

// TODO: make the entity a shared global entity and use it in the musicPlayer
class TracksListAudioItemEntity {
  final String path;
  final String? trackName;
  final Uint8List? albumArt;
  final Duration? duration;
  final List<String>? artistsNames;

  TracksListAudioItemEntity({
    required this.path,
    required this.trackName,
    required this.albumArt,
    required this.duration,
    required this.artistsNames,
  });
}
