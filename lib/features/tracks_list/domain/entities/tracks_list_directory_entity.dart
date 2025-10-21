import 'package:hive/hive.dart';
import 'package:waveglow/shared/entities/audio_item_entity.dart';

part 'tracks_list_directory_entity.g.dart';

@HiveType(typeId: 0)
class TracksListDirectoryEntity {
  @HiveField(0)
  final String directoryName;
  @HiveField(1)
  final String directoryPath;
  @HiveField(2)
  final List<AudioItemEntity> audios;

  TracksListDirectoryEntity({
    required this.directoryName,
    required this.directoryPath,
    required this.audios,
  });
}
