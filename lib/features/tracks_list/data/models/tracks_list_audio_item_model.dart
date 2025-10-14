// ignore: implementation_imports
import 'package:waveglow/features/tracks_list/domain/entities/tracks_list_audio_item_entity.dart';

class TracksListAudioItemModel extends TracksListAudioItemEntity {
  TracksListAudioItemModel({
    required super.trackName,
    required super.path,
    required super.albumArt,
    required super.duration,
    required super.artistsNames,
  });
}
