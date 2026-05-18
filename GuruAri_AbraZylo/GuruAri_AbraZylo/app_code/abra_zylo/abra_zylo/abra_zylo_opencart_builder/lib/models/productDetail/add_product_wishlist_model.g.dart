// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_wishlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddProductToWishListModelAdapter
    extends TypeAdapter<AddProductToWishListModel> {
  @override
  final int typeId = 24;

  @override
  AddProductToWishListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddProductToWishListModel(
      message: fields[1] as String?,
      error: fields[2] as int?,
      wishliststatus: fields[3] as bool?,
      wishListTotal: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddProductToWishListModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.error)
      ..writeByte(3)
      ..write(obj.wishliststatus)
      ..writeByte(4)
      ..write(obj.wishListTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddProductToWishListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProductToWishListModel _$AddProductToWishListModelFromJson(
        Map<String, dynamic> json) =>
    AddProductToWishListModel(
      message: json['message'] as String?,
      error: json['error'] as int?,
      wishliststatus: json['wishlist_status'] as bool?,
      wishListTotal: json['total'] as String?,
    );

Map<String, dynamic> _$AddProductToWishListModelToJson(
        AddProductToWishListModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'error': instance.error,
      'wishlist_status': instance.wishliststatus,
      'total': instance.wishListTotal,
    };
