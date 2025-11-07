// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioItemModelAdapter extends TypeAdapter<AudioItemModel> {
  @override
  final int typeId = 1;

  @override
  AudioItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioItemModel(
      path_: fields[0] as String,
      trackName_: fields[1] as String?,
      albumArt_: fields[2] as Uint8List?,
      durationInSeconds_: fields[3] as int?,
      artistsNames_: (fields[4] as List?)?.cast<String>(),
      modifiedDate_: fields[5] as String,
      isFavorite_: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AudioItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.path_)
      ..writeByte(1)
      ..write(obj.trackName_)
      ..writeByte(2)
      ..write(obj.albumArt_)
      ..writeByte(3)
      ..write(obj.durationInSeconds_)
      ..writeByte(4)
      ..write(obj.artistsNames_)
      ..writeByte(5)
      ..write(obj.modifiedDate_)
      ..writeByte(6)
      ..write(obj.isFavorite_);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
