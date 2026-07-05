// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaEntryAdapter extends TypeAdapter<MediaEntry> {
  @override
  final int typeId = 0;

  @override
  MediaEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaEntry(
      id: fields[0] as String,
      title: fields[1] as String,
      sourceId: fields[2] as String,
      url: fields[3] as String,
      coverUrl: fields[4] as String?,
      artist: fields[5] as String?,
      tags: (fields[6] as List).cast<String>(),
      duration: fields[7] as String?,
      description: fields[8] as String?,
      fileSize: fields[9] as int?,
      audioUrl: fields[10] as String?,
      language: fields[11] as String?,
      isDownloaded: fields[12] as bool,
      dateAdded: fields[13] as DateTime?,
      videoUrl: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaEntry obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.sourceId)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.coverUrl)
      ..writeByte(5)
      ..write(obj.artist)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.fileSize)
      ..writeByte(10)
      ..write(obj.audioUrl)
      ..writeByte(11)
      ..write(obj.language)
      ..writeByte(12)
      ..write(obj.isDownloaded)
      ..writeByte(13)
      ..write(obj.dateAdded)
      ..writeByte(14)
      ..write(obj.videoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
