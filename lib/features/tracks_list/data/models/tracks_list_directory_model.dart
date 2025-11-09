import 'package:hive/hive.dart';
import 'package:waveglow/core/contracts/model.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

part 'tracks_list_directory_model.g.dart';

@HiveType(typeId: 0)
class TracksListDirectoryModel implements Model<TracksListDirectoryEntity> {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String directoryName;

  @HiveField(2)
  final String directoryPath;

  @HiveField(3)
  final List<AudioItemModel> audios;

  TracksListDirectoryModel({
    required this.id,
    required this.directoryName,
    required this.directoryPath,
    required this.audios,
  });

  factory TracksListDirectoryModel.fromEntity(TracksListDirectoryEntity entity) {
    return TracksListDirectoryModel(
      id: entity.id,
      directoryName: entity.directoryName,
      directoryPath: entity.directoryPath,
      audios: entity.audios.map((e) => AudioItemModel.fromEntity(e)).toList(),
    );
  }

  @override
  TracksListDirectoryEntity toEntity() {
    return TracksListDirectoryEntity(
      id: id,
      directoryName: directoryName,
      directoryPath: directoryPath,
      audios: audios.map((e) => e.toEntity()).toList(),
    );
  }
}
