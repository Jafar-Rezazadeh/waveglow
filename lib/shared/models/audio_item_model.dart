import 'package:waveglow/shared/entities/audio_item_entity.dart';

class AudioItemModel extends AudioItemEntity {
  AudioItemModel({
    required super.trackName,
    required super.path,
    required super.albumArt,
    required super.duration,
    required super.artistsNames,
  });
}
