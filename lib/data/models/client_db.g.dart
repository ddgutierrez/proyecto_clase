// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientDbAdapter extends TypeAdapter<ClientDb> {
  @override
  final int typeId = 1;

  @override
  ClientDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientDb(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientDb obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
