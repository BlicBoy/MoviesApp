// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responseId.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResponseIdAdapter extends TypeAdapter<ResponseId> {
  @override
  final int typeId = 2;

  @override
  ResponseId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponseId(
      sessionId: fields[0] as String,
      success: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ResponseId obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.success);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
