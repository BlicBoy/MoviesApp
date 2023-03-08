// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoviesAdapter extends TypeAdapter<Movies> {
  @override
  final int typeId = 0;

  @override
  Movies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movies(
      id: fields[0] as int?,
      originalTitle: fields[1] as String?,
      overview: fields[2] as String?,
      image: fields[3] as String?,
      backdropPath: fields[4] as String?,
      homePage: fields[5] as String?,
      release_date: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Movies obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalTitle)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.backdropPath)
      ..writeByte(5)
      ..write(obj.homePage)
      ..writeByte(6)
      ..write(obj.release_date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoviesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
