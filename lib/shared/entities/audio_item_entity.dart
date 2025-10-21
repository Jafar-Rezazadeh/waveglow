import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'audio_item_entity.g.dart';

@HiveType(typeId: 1)
class AudioItemEntity {
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

  AudioItemEntity({
    required this.path,
    required this.trackName,
    required this.albumArt,
    required this.durationInSeconds,
    required this.artistsNames,
  });
}
