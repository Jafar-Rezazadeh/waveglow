// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracks_list_directory_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TracksListDirectoryModelAdapter
    extends TypeAdapter<TracksListDirectoryModel> {
  @override
  final int typeId = 0;

  @override
  TracksListDirectoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TracksListDirectoryModel(
      idM: fields[0] as String,
      directoryNameM: fields[1] as String,
      directoryPathM: fields[2] as String,
      audiosM: (fields[3] as List).cast<AudioItemEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, TracksListDirectoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.idM)
      ..writeByte(1)
      ..write(obj.directoryNameM)
      ..writeByte(2)
      ..write(obj.directoryPathM)
      ..writeByte(3)
      ..write(obj.audiosM);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TracksListDirectoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
