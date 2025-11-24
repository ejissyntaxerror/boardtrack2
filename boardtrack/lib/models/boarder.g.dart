// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boarder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoarderAdapter extends TypeAdapter<Boarder> {
  @override
  final int typeId = 0;

  @override
  Boarder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Boarder(
      name: fields[0] as String,
      roomNumber: fields[1] as String,
      monthlyRent: fields[2] as double,
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Boarder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.roomNumber)
      ..writeByte(2)
      ..write(obj.monthlyRent)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoarderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
