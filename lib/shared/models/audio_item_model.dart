import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:waveglow/core/contracts/model.dart';
import 'package:waveglow/core/core_exports.dart';

part 'audio_item_model.g.dart';

@HiveType(typeId: 1)
class AudioItemModel implements Model<AudioItemEntity> {
  @HiveField(0)
  final String path;

  @HiveField(1)
  final String? trackName;

  @HiveField(2)
  final Uint8List? albumArt;

  @HiveField(3)
  final int? durationInSeconds;

  @HiveField(4)
  final List<String>? artistsNames;

  @HiveField(5)
  /// [modifiedDate] is a Iso8601String
  final String modifiedDate;

  @HiveField(6)
  final bool isFavorite;

  AudioItemModel({
    required this.path,
    required this.trackName,
    required this.albumArt,
    required this.durationInSeconds,
    required this.artistsNames,
    required this.modifiedDate,
    required this.isFavorite,
  });

  factory AudioItemModel.fromEntity(AudioItemEntity entity) {
    return AudioItemModel(
      path: entity.path,
      trackName: entity.trackName,
      albumArt: entity.albumArt,
      durationInSeconds: entity.durationInSeconds,
      artistsNames: entity.artistsNames,
      modifiedDate: entity.modifiedDate,
      isFavorite: entity.isFavorite,
    );
  }

  @override
  AudioItemEntity toEntity() {
    return AudioItemEntity(
      path: path,
      trackName: trackName,
      albumArt: albumArt,
      durationInSeconds: durationInSeconds,
      artistsNames: artistsNames,
      modifiedDate: modifiedDate,
      isFavorite: isFavorite,
    );
  }

  AudioItemModel copyWith({bool? isFavorite}) {
    return AudioItemModel(
      path: path,
      trackName: trackName,
      albumArt: albumArt,
      durationInSeconds: durationInSeconds,
      artistsNames: artistsNames,
      modifiedDate: modifiedDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
