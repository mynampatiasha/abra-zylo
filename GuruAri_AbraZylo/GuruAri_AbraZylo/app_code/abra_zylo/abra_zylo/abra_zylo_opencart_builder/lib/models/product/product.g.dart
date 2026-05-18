// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 11;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      productId: fields[2] as String?,
      thumb: fields[3] as String?,
      name: fields[4] as String?,
      description: fields[5] as String?,
      price: fields[6] as String?,
      special: fields[7] as dynamic,
      tax: fields[8] as String?,
      minimum: fields[9] as dynamic,
      rating: fields[10] as int?,
      path: fields[12] as String?,
      dominantColor: fields[13] as String?,
      hasOption: fields[14] as bool?,
      formattedSpecial: fields[15] as String?,
      wishlistStatus: fields[16] as bool?,
      ar: fields[17] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(15)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.thumb)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.special)
      ..writeByte(8)
      ..write(obj.tax)
      ..writeByte(9)
      ..write(obj.minimum)
      ..writeByte(10)
      ..write(obj.rating)
      ..writeByte(12)
      ..write(obj.path)
      ..writeByte(13)
      ..write(obj.dominantColor)
      ..writeByte(14)
      ..write(obj.hasOption)
      ..writeByte(15)
      ..write(obj.formattedSpecial)
      ..writeByte(16)
      ..write(obj.wishlistStatus)
      ..writeByte(17)
      ..write(obj.ar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['product_id'] as String?,
      thumb: json['thumb'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      special: json['special'],
      tax: json['tax'] as String?,
      minimum: json['minimum'],
      rating: json['rating'] as int?,
      path: json['path'] as String?,
      dominantColor: json['dominant_color'] as String?,
      hasOption: json['hasOption'] as bool?,
      formattedSpecial: json['formatted_special'] as String?,
      wishlistStatus: json['wishlist_status'] as bool?,
      ar: json['is_ar'] as bool?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.productId,
      'thumb': instance.thumb,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'special': instance.special,
      'tax': instance.tax,
      'minimum': instance.minimum,
      'rating': instance.rating,
      'path': instance.path,
      'dominant_color': instance.dominantColor,
      'hasOption': instance.hasOption,
      'formatted_special': instance.formattedSpecial,
      'wishlist_status': instance.wishlistStatus,
      'is_ar': instance.ar,
    };
