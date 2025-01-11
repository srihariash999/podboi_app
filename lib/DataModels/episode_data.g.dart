// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EpisodeDataAdapter extends TypeAdapter<EpisodeData> {
  @override
  final int typeId = 3;

  @override
  EpisodeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EpisodeData(
      id: fields[0] as int,
      guid: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      podcastId: fields[12] as int,
      link: fields[4] as String?,
      publicationDate: fields[5] as DateTime?,
      contentUrl: fields[6] as String?,
      imageUrl: fields[7] as String?,
      author: fields[8] as String?,
      season: fields[9] as int?,
      episodeNumber: fields[10] as int?,
      duration: fields[11] as int?,
      podcastName: fields[13] as String?,
      playedDuration: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EpisodeData obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.guid)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.link)
      ..writeByte(5)
      ..write(obj.publicationDate)
      ..writeByte(6)
      ..write(obj.contentUrl)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.author)
      ..writeByte(9)
      ..write(obj.season)
      ..writeByte(10)
      ..write(obj.episodeNumber)
      ..writeByte(11)
      ..write(obj.duration)
      ..writeByte(12)
      ..write(obj.podcastId)
      ..writeByte(13)
      ..write(obj.podcastName)
      ..writeByte(14)
      ..write(obj.playedDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
