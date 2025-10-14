import 'package:waveglow/shared/entities/audio_item_entity.dart';

class TracksListDirectoryEntity {
  final String directoryName;
  final String directoryPath;
  final List<AudioItemEntity> audios;

  TracksListDirectoryEntity({
    required this.directoryName,
    required this.directoryPath,
    required this.audios,
  });
}
