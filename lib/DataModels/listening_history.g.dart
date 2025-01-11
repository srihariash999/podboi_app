// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listening_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListeningHistoryDataAdapter extends TypeAdapter<ListeningHistoryData> {
  @override
  final int typeId = 5;

  @override
  ListeningHistoryData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListeningHistoryData(
      listenedOn: fields[0] as String,
      episodeData: fields[1] as EpisodeData,
    );
  }

  @override
  void write(BinaryWriter writer, ListeningHistoryData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.listenedOn)
      ..writeByte(1)
      ..write(obj.episodeData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListeningHistoryDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
