import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:waveglow/shared/entities/audio_item_entity.dart';

part 'tracks_list_directory_entity.g.dart';

@HiveType(typeId: 0)
class TracksListDirectoryEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String directoryName;
  @HiveField(2)
  final String directoryPath;
  @HiveField(3)
  final List<AudioItemEntity> audios;

  TracksListDirectoryEntity({
    required this.directoryName,
    required this.directoryPath,
    required this.audios,
  }) : id = const Uuid().v4();
}
