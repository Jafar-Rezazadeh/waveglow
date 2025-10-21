// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracks_list_directory_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TracksListDirectoryEntityAdapter
    extends TypeAdapter<TracksListDirectoryEntity> {
  @override
  final int typeId = 0;

  @override
  TracksListDirectoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TracksListDirectoryEntity(
      directoryName: fields[0] as String,
      directoryPath: fields[1] as String,
      audios: (fields[2] as List).cast<AudioItemEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, TracksListDirectoryEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.directoryName)
      ..writeByte(1)
      ..write(obj.directoryPath)
      ..writeByte(2)
      ..write(obj.audios);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TracksListDirectoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
