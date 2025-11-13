import 'package:waveglow/shared/entities/audio_item_entity.dart';

class TracksListDirectoryEntity {
  final String id;

  final String directoryName;

  final String directoryPath;

  final List<AudioItemEntity> audios;

  TracksListDirectoryEntity({
    required this.id,
    required this.directoryName,
    required this.directoryPath,
    required this.audios,
  });
}
