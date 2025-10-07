// ignore: implementation_imports
import 'package:flutter_media_metadata/src/models/metadata.dart';
import 'package:waveglow/features/tracks_list/domain/entities/tracks_list_audio_item_entity.dart';

class TracksListAudioItemModel extends TracksListAudioItemEntity {
  TracksListAudioItemModel({
    required super.trackName,
    required super.trackArtistNames,
    required super.isFavorite,
    required super.trackDuration,
    required super.albumArt,
    required super.path,
  });

  factory TracksListAudioItemModel.fromMetaData(Metadata metaData, String path) {
    return TracksListAudioItemModel(
      trackName: metaData.trackName,
      trackArtistNames: metaData.trackArtistNames,
      isFavorite: false,
      trackDuration:
          metaData.trackDuration != null ? Duration(milliseconds: metaData.trackDuration!) : null,
      albumArt: metaData.albumArt,
      path: path,
    );
  }
}
