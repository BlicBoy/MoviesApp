// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataLoginAdapter extends TypeAdapter<DataLogin> {
  @override
  final int typeId = 1;

  @override
  DataLogin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataLogin(
      idUserLogged: fields[0] as int?,
      usernameLogged: fields[1] as String?,
      nameUserLogged: fields[2] as String?,
      photoUserLogged: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataLogin obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.idUserLogged)
      ..writeByte(1)
      ..write(obj.usernameLogged)
      ..writeByte(2)
      ..write(obj.nameUserLogged)
      ..writeByte(3)
      ..write(obj.photoUserLogged);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataLoginAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
