// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'additional_fee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdditionalFeeAdapter extends TypeAdapter<AdditionalFee> {
  @override
  final int typeId = 2;

  @override
  AdditionalFee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdditionalFee(
      boarderId: fields[0] as int,
      feeName: fields[1] as String,
      amount: fields[2] as double,
      feeDate: fields[3] as DateTime,
      createdAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AdditionalFee obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.boarderId)
      ..writeByte(1)
      ..write(obj.feeName)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.feeDate)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdditionalFeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
