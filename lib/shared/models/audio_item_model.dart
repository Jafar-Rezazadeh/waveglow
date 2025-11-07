import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:waveglow/core/core_exports.dart';

part 'audio_item_model.g.dart';

@HiveType(typeId: 1)
class AudioItemModel extends AudioItemEntity {
  @HiveField(0)
  final String path_;

  @HiveField(1)
  final String? trackName_;

  @HiveField(2)
  final Uint8List? albumArt_;

  @HiveField(3)
  final int? durationInSeconds_;

  @HiveField(4)
  final List<String>? artistsNames_;

  @HiveField(5)
  /// [modifiedDate] is a Iso8601String
  final String modifiedDate_;

  @HiveField(6)
  final bool isFavorite_;

  AudioItemModel({
    required this.path_,
    required this.trackName_,
    required this.albumArt_,
    required this.durationInSeconds_,
    required this.artistsNames_,
    required this.modifiedDate_,
    required this.isFavorite_,
  }) : super(
         path: path_,
         trackName: trackName_,
         albumArt: albumArt_,
         durationInSeconds: durationInSeconds_,
         artistsNames: artistsNames_,
         modifiedDate: modifiedDate_,
         isFavorite: isFavorite_,
       );

  factory AudioItemModel.fromEntity(AudioItemEntity entity) {
    return AudioItemModel(
      path_: entity.path,
      trackName_: entity.trackName,
      albumArt_: entity.albumArt,
      durationInSeconds_: entity.durationInSeconds,
      artistsNames_: entity.artistsNames,
      modifiedDate_: entity.modifiedDate,
      isFavorite_: entity.isFavorite,
    );
  }
}
