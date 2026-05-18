// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryDataAdapter extends TypeAdapter<CategoryData> {
  @override
  final int typeId = 31;

  @override
  CategoryData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryData(
      thumb: fields[1] as String?,
      description: fields[2] as String?,
      categories: (fields[3] as List?)?.cast<Category>(),
      products: (fields[4] as List?)?.cast<Product>(),
      productTotal: fields[5] as String?,
      sorts: (fields[6] as List?)?.cast<Sort>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryData obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.thumb)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.categories)
      ..writeByte(4)
      ..write(obj.products)
      ..writeByte(5)
      ..write(obj.productTotal)
      ..writeByte(6)
      ..write(obj.sorts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) => CategoryData(
      thumb: json['thumb'] as String?,
      description: json['description'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      productTotal: json['product_total'] as String?,
      sorts: (json['sorts'] as List<dynamic>?)
          ?.map((e) => Sort.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'thumb': instance.thumb,
      'description': instance.description,
      'categories': instance.categories,
      'products': instance.products,
      'product_total': instance.productTotal,
      'sorts': instance.sorts,
    };
