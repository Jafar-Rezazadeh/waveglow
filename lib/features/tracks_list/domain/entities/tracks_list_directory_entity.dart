import 'package:waveglow/features/tracks_list/domain/entities/tracks_list_audio_item_entity.dart';

class TracksListDirectoryEntity {
  final String directoryName;
  final String directoryPath;
  final List<TracksListAudioItemEntity> audios;

  TracksListDirectoryEntity({
    required this.directoryName,
    required this.directoryPath,
    required this.audios,
  });
}
