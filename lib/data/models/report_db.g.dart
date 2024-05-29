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
      report: fields[0] as String,
      review: fields[1] as int,
      revised: fields[2] as bool,
      duration: fields[3] as int,
      startTime: fields[4] as String,
      supportUser: fields[5] as int,
      clientName: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReportDb obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.report)
      ..writeByte(1)
      ..write(obj.review)
      ..writeByte(2)
      ..write(obj.revised)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.supportUser)
      ..writeByte(6)
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
