import 'package:hive/hive.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

part 'tracks_list_directory_model.g.dart';

@HiveType(typeId: 0)
class TracksListDirectoryModel extends TracksListDirectoryEntity {
  @HiveField(0)
  final String idM;

  @HiveField(1)
  final String directoryNameM;

  @HiveField(2)
  final String directoryPathM;

  @HiveField(3)
  final List<AudioItemModel> audiosM;

  TracksListDirectoryModel({
    required this.idM,
    required this.directoryNameM,
    required this.directoryPathM,
    required this.audiosM,
  }) : super(
         id: idM,
         directoryName: directoryNameM,
         audios: audiosM,
         directoryPath: directoryPathM,
       );

  factory TracksListDirectoryModel.fromEntity(TracksListDirectoryEntity entity) {
    return TracksListDirectoryModel(
      idM: entity.id,
      directoryNameM: entity.directoryName,
      directoryPathM: entity.directoryPath,
      audiosM: entity.audios.map((e) => AudioItemModel.fromEntity(e)).toList(),
    );
  }
}
