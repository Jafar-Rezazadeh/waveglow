import 'package:flutter/foundation.dart';

class AudioItemEntity {
  final String path;

  final String? trackName;

  final Uint8List? albumArt;

  final int? durationInSeconds;

  final List<String>? artistsNames;

  /// [modifiedDate] is a Iso8601String
  final String modifiedDate;

  final bool isFavorite;

  final String dirId;

  AudioItemEntity({
    required this.path,
    required this.trackName,
    required this.albumArt,
    required this.durationInSeconds,
    required this.artistsNames,
    required this.modifiedDate,
    required this.isFavorite,
    required this.dirId,
  });

  AudioItemEntity copyWith({bool? isFavorite}) {
    return AudioItemEntity(
      path: path,
      trackName: trackName,
      albumArt: albumArt,
      durationInSeconds: durationInSeconds,
      artistsNames: artistsNames,
      modifiedDate: modifiedDate,
      isFavorite: isFavorite ?? this.isFavorite,
      dirId: dirId,
    );
  }
}
