import 'dart:typed_data';

class TracksListAudioItemEntity {
  final String? trackName;
  final List<String>? trackArtistNames;
  final bool isFavorite;
  final Duration? trackDuration;
  final Uint8List? albumArt;
  final String path;

  TracksListAudioItemEntity({
    required this.trackName,
    required this.trackArtistNames,
    required this.isFavorite,
    required this.trackDuration,
    required this.albumArt,
    required this.path,
  });
}
