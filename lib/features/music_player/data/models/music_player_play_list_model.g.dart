// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_player_play_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicPlayerPlayListModelAdapter
    extends TypeAdapter<MusicPlayerPlayListModel> {
  @override
  final int typeId = 2;

  @override
  MusicPlayerPlayListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicPlayerPlayListModel(
      id: fields[0] as String,
      audios: (fields[1] as List).cast<AudioItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MusicPlayerPlayListModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.audios);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicPlayerPlayListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
