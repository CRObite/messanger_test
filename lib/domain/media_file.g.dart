// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaFileAdapter extends TypeAdapter<MediaFile> {
  @override
  final int typeId = 2;

  @override
  MediaFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaFile(
      fields[0] as String,
      fields[1] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaFile obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.fileData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
