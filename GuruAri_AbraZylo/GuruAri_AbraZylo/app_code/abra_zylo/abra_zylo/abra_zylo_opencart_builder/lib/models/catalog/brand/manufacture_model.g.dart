// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manufacture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManufactureModelAdapter extends TypeAdapter<ManufactureModel> {
  @override
  final int typeId = 43;

  @override
  ManufactureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ManufactureModel(
      manufacturers: fields[2] as Manufacturers?,
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
  void write(BinaryWriter writer, ManufactureModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(2)
      ..write(obj.manufacturers)
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
      other is ManufactureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ManufacturersAdapter extends TypeAdapter<Manufacturers> {
  @override
  final int typeId = 44;

  @override
  Manufacturers read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Manufacturers(
      headingTitle: fields[3] as String?,
      textEmpty: fields[4] as String?,
      textQuantity: fields[5] as String?,
      textManufacturer: fields[6] as String?,
      textModel: fields[7] as String?,
      textPrice: fields[8] as String?,
      textTax: fields[9] as String?,
      textPoints: fields[10] as String?,
      textCompare: fields[11] as String?,
      textSort: fields[12] as String?,
      textLimit: fields[13] as String?,
      buttonCart: fields[14] as String?,
      buttonWishlist: fields[27] as String?,
      buttonCompare: fields[15] as String?,
      buttonContinue: fields[16] as String?,
      buttonList: fields[17] as String?,
      buttonGrid: fields[18] as String?,
      products: (fields[19] as List?)?.cast<Product>(),
      sorts: (fields[20] as List?)?.cast<Sorts>(),
      productTotal: fields[21] as String?,
      limits: (fields[22] as List?)?.cast<Limits>(),
      results: fields[23] as String?,
      sort: fields[24] as String?,
      order: fields[25] as String?,
      limit: fields[26] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Manufacturers obj) {
    writer
      ..writeByte(25)
      ..writeByte(3)
      ..write(obj.headingTitle)
      ..writeByte(4)
      ..write(obj.textEmpty)
      ..writeByte(5)
      ..write(obj.textQuantity)
      ..writeByte(6)
      ..write(obj.textManufacturer)
      ..writeByte(7)
      ..write(obj.textModel)
      ..writeByte(8)
      ..write(obj.textPrice)
      ..writeByte(9)
      ..write(obj.textTax)
      ..writeByte(10)
      ..write(obj.textPoints)
      ..writeByte(11)
      ..write(obj.textCompare)
      ..writeByte(12)
      ..write(obj.textSort)
      ..writeByte(13)
      ..write(obj.textLimit)
      ..writeByte(14)
      ..write(obj.buttonCart)
      ..writeByte(27)
      ..write(obj.buttonWishlist)
      ..writeByte(15)
      ..write(obj.buttonCompare)
      ..writeByte(16)
      ..write(obj.buttonContinue)
      ..writeByte(17)
      ..write(obj.buttonList)
      ..writeByte(18)
      ..write(obj.buttonGrid)
      ..writeByte(19)
      ..write(obj.products)
      ..writeByte(20)
      ..write(obj.sorts)
      ..writeByte(21)
      ..write(obj.productTotal)
      ..writeByte(22)
      ..write(obj.limits)
      ..writeByte(23)
      ..write(obj.results)
      ..writeByte(24)
      ..write(obj.sort)
      ..writeByte(25)
      ..write(obj.order)
      ..writeByte(26)
      ..write(obj.limit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManufacturersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortsAdapter extends TypeAdapter<Sorts> {
  @override
  final int typeId = 45;

  @override
  Sorts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sorts();
  }

  @override
  void write(BinaryWriter writer, Sorts obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LimitsAdapter extends TypeAdapter<Limits> {
  @override
  final int typeId = 46;

  @override
  Limits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Limits();
  }

  @override
  void write(BinaryWriter writer, Limits obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LimitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManufactureModel _$ManufactureModelFromJson(Map<String, dynamic> json) =>
    ManufactureModel(
      manufacturers: json['manufacturers'] == null
          ? null
          : Manufacturers.fromJson(
              json['manufacturers'] as Map<String, dynamic>),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total']
      ..eTag = json['etag'] as String?;

Map<String, dynamic> _$ManufactureModelToJson(ManufactureModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'etag': instance.eTag,
      'manufacturers': instance.manufacturers,
    };

Manufacturers _$ManufacturersFromJson(Map<String, dynamic> json) =>
    Manufacturers(
      headingTitle: json['heading_title'] as String?,
      textEmpty: json['text_empty'] as String?,
      textQuantity: json['text_quantity'] as String?,
      textManufacturer: json['text_manufacturer'] as String?,
      textModel: json['text_model'] as String?,
      textPrice: json['text_price'] as String?,
      textTax: json['text_tax'] as String?,
      textPoints: json['text_points'] as String?,
      textCompare: json['text_compare'] as String?,
      textSort: json['text_sort'] as String?,
      textLimit: json['text_limit'] as String?,
      buttonCart: json['button_cart'] as String?,
      buttonWishlist: json['button_wishlist'] as String?,
      buttonCompare: json['button_compare'] as String?,
      buttonContinue: json['button_continue'] as String?,
      buttonList: json['button_list'] as String?,
      buttonGrid: json['button_grid'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      sorts: (json['sorts'] as List<dynamic>?)
          ?.map((e) => Sorts.fromJson(e as Map<String, dynamic>))
          .toList(),
      productTotal: json['product_total'] as String?,
      limits: (json['limits'] as List<dynamic>?)
          ?.map((e) => Limits.fromJson(e as Map<String, dynamic>))
          .toList(),
      results: json['results'] as String?,
      sort: json['sort'] as String?,
      order: json['order'] as String?,
      limit: json['limit'] as String?,
    );

Map<String, dynamic> _$ManufacturersToJson(Manufacturers instance) =>
    <String, dynamic>{
      'heading_title': instance.headingTitle,
      'text_empty': instance.textEmpty,
      'text_quantity': instance.textQuantity,
      'text_manufacturer': instance.textManufacturer,
      'text_model': instance.textModel,
      'text_price': instance.textPrice,
      'text_tax': instance.textTax,
      'text_points': instance.textPoints,
      'text_compare': instance.textCompare,
      'text_sort': instance.textSort,
      'text_limit': instance.textLimit,
      'button_cart': instance.buttonCart,
      'button_wishlist': instance.buttonWishlist,
      'button_compare': instance.buttonCompare,
      'button_continue': instance.buttonContinue,
      'button_list': instance.buttonList,
      'button_grid': instance.buttonGrid,
      'products': instance.products,
      'sorts': instance.sorts,
      'product_total': instance.productTotal,
      'limits': instance.limits,
      'results': instance.results,
      'sort': instance.sort,
      'order': instance.order,
      'limit': instance.limit,
    };

Sorts _$SortsFromJson(Map<String, dynamic> json) => Sorts(
      text: json['text'] as String?,
      value: json['value'] as String?,
      order: json['order'] as String?,
    );

Map<String, dynamic> _$SortsToJson(Sorts instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
      'order': instance.order,
    };

Limits _$LimitsFromJson(Map<String, dynamic> json) => Limits(
      text: json['text'] as int?,
      value: json['value'] as int?,
    );

Map<String, dynamic> _$LimitsToJson(Limits instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };
