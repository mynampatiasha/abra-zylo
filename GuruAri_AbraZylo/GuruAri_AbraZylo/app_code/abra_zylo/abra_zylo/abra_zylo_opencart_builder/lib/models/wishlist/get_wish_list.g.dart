// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_wish_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GetWishlistAdapter extends TypeAdapter<GetWishlist> {
  @override
  final int typeId = 34;

  @override
  GetWishlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetWishlist(
      wishlistData: (fields[1] as List?)?.cast<WishlistDatum>(),
    )
      ..eTag = fields[100] as String?
      ..fault = fields[201] as int?
      ..message = fields[202] as String?
      ..error = fields[203] as int?
      ..redirect = fields[204] as String?
      ..newsletter = fields[205] as dynamic
      ..cartTotal = fields[206] as dynamic;
  }

  @override
  void write(BinaryWriter writer, GetWishlist obj) {
    writer
      ..writeByte(8)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(1)
      ..write(obj.wishlistData)
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
      other is GetWishlistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetWishlist _$GetWishlistFromJson(Map<String, dynamic> json) => GetWishlist(
      wishlistData: (json['wishlistData'] as List<dynamic>?)
          ?.map((e) => WishlistDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total']
      ..eTag = json['etag'] as String?;

Map<String, dynamic> _$GetWishlistToJson(GetWishlist instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'etag': instance.eTag,
      'wishlistData': instance.wishlistData,
    };
