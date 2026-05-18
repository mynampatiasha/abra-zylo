// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_datum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressDatumAdapter extends TypeAdapter<AddressDatum> {
  @override
  final int typeId = 40;

  @override
  AddressDatum read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressDatum(
      addressId: fields[1] as String?,
      value: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddressDatum obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.addressId)
      ..writeByte(2)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressDatumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDatum _$AddressDatumFromJson(Map<String, dynamic> json) => AddressDatum(
      addressId: json['address_id'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$AddressDatumToJson(AddressDatum instance) =>
    <String, dynamic>{
      'address_id': instance.addressId,
      'value': instance.value,
    };
