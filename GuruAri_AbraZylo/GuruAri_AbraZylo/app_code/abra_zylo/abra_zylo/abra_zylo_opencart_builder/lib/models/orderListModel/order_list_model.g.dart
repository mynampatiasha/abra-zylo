// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderListModelAdapter extends TypeAdapter<OrderListModel> {
  @override
  final int typeId = 35;

  @override
  OrderListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderListModel(
      orderData: (fields[1] as List?)?.cast<OrderListData>(),
      orderTotals: fields[2] as String?,
      error: fields[3] as int?,
    )
      ..eTag = fields[100] as String?
      ..fault = fields[201] as int?
      ..message = fields[202] as String?
      ..redirect = fields[204] as String?
      ..newsletter = fields[205] as dynamic
      ..cartTotal = fields[206] as dynamic;
  }

  @override
  void write(BinaryWriter writer, OrderListModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(1)
      ..write(obj.orderData)
      ..writeByte(2)
      ..write(obj.orderTotals)
      ..writeByte(3)
      ..write(obj.error)
      ..writeByte(201)
      ..write(obj.fault)
      ..writeByte(202)
      ..write(obj.message)
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
      other is OrderListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderListDataAdapter extends TypeAdapter<OrderListData> {
  @override
  final int typeId = 36;

  @override
  OrderListData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderListData(
      orderId: fields[1] as String?,
      name: fields[2] as String?,
      status: fields[3] as String?,
      dateAdded: fields[4] as String?,
      products: fields[5] as int?,
      total: fields[6] as String?,
      image: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderListData obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.dateAdded)
      ..writeByte(5)
      ..write(obj.products)
      ..writeByte(6)
      ..write(obj.total)
      ..writeByte(7)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderListDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListModel _$OrderListModelFromJson(Map<String, dynamic> json) =>
    OrderListModel(
      orderData: (json['orderData'] as List<dynamic>?)
          ?.map((e) => OrderListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderTotals: json['orderTotals'] as String?,
      error: json['error'] as int?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total']
      ..eTag = json['etag'] as String?;

Map<String, dynamic> _$OrderListModelToJson(OrderListModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'etag': instance.eTag,
      'orderData': instance.orderData,
      'orderTotals': instance.orderTotals,
      'error': instance.error,
    };

OrderListData _$OrderListDataFromJson(Map<String, dynamic> json) =>
    OrderListData(
      orderId: json['orderId'] as String?,
      name: json['name'] as String?,
      status: json['status'] as String?,
      dateAdded: json['dateAdded'] as String?,
      products: json['products'] as int?,
      total: json['total'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$OrderListDataToJson(OrderListData instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'name': instance.name,
      'status': instance.status,
      'dateAdded': instance.dateAdded,
      'products': instance.products,
      'total': instance.total,
      'image': instance.image,
    };
