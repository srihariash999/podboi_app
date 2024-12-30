// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionDataAdapter extends TypeAdapter<SubscriptionData> {
  @override
  final int typeId = 4;

  @override
  SubscriptionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionData(
      id: fields[0] as int,
      podcastName: fields[1] as String,
      podcastId: fields[2] as int?,
      feedUrl: fields[3] as String,
      artworkUrl: fields[4] as String,
      dateAdded: fields[5] as DateTime,
      lastEpisodeDate: fields[6] as DateTime?,
      trackCount: fields[7] as int?,
      releaseDate: fields[8] as DateTime?,
      country: fields[9] as String?,
      genre: fields[10] as String?,
      contentAdvisory: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.podcastName)
      ..writeByte(2)
      ..write(obj.podcastId)
      ..writeByte(3)
      ..write(obj.feedUrl)
      ..writeByte(4)
      ..write(obj.artworkUrl)
      ..writeByte(5)
      ..write(obj.dateAdded)
      ..writeByte(6)
      ..write(obj.lastEpisodeDate)
      ..writeByte(7)
      ..write(obj.trackCount)
      ..writeByte(8)
      ..write(obj.releaseDate)
      ..writeByte(9)
      ..write(obj.country)
      ..writeByte(10)
      ..write(obj.genre)
      ..writeByte(11)
      ..write(obj.contentAdvisory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
