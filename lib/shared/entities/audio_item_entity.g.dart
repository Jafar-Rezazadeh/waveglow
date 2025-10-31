// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioItemEntityAdapter extends TypeAdapter<AudioItemEntity> {
  @override
  final int typeId = 1;

  @override
  AudioItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioItemEntity(
      path: fields[0] as String,
      trackName: fields[1] as String?,
      albumArt: fields[2] as Uint8List?,
      durationInSeconds: fields[3] as int?,
      artistsNames: (fields[4] as List?)?.cast<String>(),
      modifiedDate: fields[5] as String,
      isFavorite: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AudioItemEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.trackName)
      ..writeByte(2)
      ..write(obj.albumArt)
      ..writeByte(3)
      ..write(obj.durationInSeconds)
      ..writeByte(4)
      ..write(obj.artistsNames)
      ..writeByte(5)
      ..write(obj.modifiedDate)
      ..writeByte(6)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
