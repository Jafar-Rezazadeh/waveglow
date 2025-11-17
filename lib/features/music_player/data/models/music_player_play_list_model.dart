import 'package:hive/hive.dart';
import 'package:waveglow/core/contracts/model.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

part 'music_player_play_list_model.g.dart';

@HiveType(typeId: 2)
class MusicPlayerPlayListModel implements Model<MusicPlayerPlayListEntity> {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<AudioItemModel> audios;

  MusicPlayerPlayListModel({required this.id, required this.audios});

  factory MusicPlayerPlayListModel.fromEntity(MusicPlayerPlayListEntity entity) {
    return MusicPlayerPlayListModel(
      id: entity.id,
      audios: entity.audios.map((e) => AudioItemModel.fromEntity(e)).toList(),
    );
  }

  @override
  MusicPlayerPlayListEntity toEntity() {
    return MusicPlayerPlayListEntity(id: id, audios: audios.map((e) => e.toEntity()).toList());
  }
}
