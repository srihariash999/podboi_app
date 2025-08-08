// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_episode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedEpisodeAdapter extends TypeAdapter<DownloadedEpisode> {
  @override
  final int typeId = 6;

  @override
  DownloadedEpisode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedEpisode(
      episode: fields[0] as EpisodeData,
      downloadedOn: fields[1] as String,
      filePath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedEpisode obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.episode)
      ..writeByte(1)
      ..write(obj.downloadedOn)
      ..writeByte(2)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedEpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
