// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GetAddressAdapter extends TypeAdapter<GetAddress> {
  @override
  final int typeId = 39;

  @override
  GetAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetAddress(
      eTag: fields[100] as String?,
      addressData: (fields[1] as List?)?.cast<AddressDatum>(),
      defaultAddress: fields[2] as String?,
    )
      ..fault = fields[201] as int?
      ..message = fields[202] as String?
      ..error = fields[203] as int?
      ..redirect = fields[204] as String?
      ..newsletter = fields[205] as dynamic
      ..cartTotal = fields[206] as dynamic;
  }

  @override
  void write(BinaryWriter writer, GetAddress obj) {
    writer
      ..writeByte(9)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(1)
      ..write(obj.addressData)
      ..writeByte(2)
      ..write(obj.defaultAddress)
      ..writeByte(201)
      ..write(obj.fault)
      ..writeByte(202)
      ..write(obj.message)
      ..writeByte(203)
      ..write(obj.error)
      ..writeByte(204)
      ..write(obj.redirect)
      ..writeByte(205)
      ..write(obj.newsletter)
      ..writeByte(206)
      ..write(obj.cartTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAddress _$GetAddressFromJson(Map<String, dynamic> json) => GetAddress(
      eTag: json['etag'] as String?,
      addressData: (json['addressData'] as List<dynamic>?)
          ?.map((e) => AddressDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultAddress: json['default'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$GetAddressToJson(GetAddress instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'etag': instance.eTag,
      'addressData': instance.addressData,
      'default': instance.defaultAddress,
    };
