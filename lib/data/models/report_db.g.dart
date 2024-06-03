// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportDbAdapter extends TypeAdapter<ReportDb> {
  @override
  final int typeId = 3;

  @override
  ReportDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportDb(
      id: fields[0] as int?,
      report: fields[1] as String,
      review: fields[2] as int,
      revised: fields[3] as bool,
      duration: fields[4] as int,
      startTime: fields[5] as String,
      supportUser: fields[6] as int,
      clientName: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReportDb obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.report)
      ..writeByte(2)
      ..write(obj.review)
      ..writeByte(3)
      ..write(obj.revised)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.supportUser)
      ..writeByte(7)
      ..write(obj.clientName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
