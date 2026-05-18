// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_order_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReturnOrderListModelAdapter extends TypeAdapter<ReturnOrderListModel> {
  @override
  final int typeId = 37;

  @override
  ReturnOrderListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReturnOrderListModel(
      returnData: (fields[1] as List?)?.cast<ReturnListData>(),
      returnTotals: fields[2] as String?,
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
  void write(BinaryWriter writer, ReturnOrderListModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(1)
      ..write(obj.returnData)
      ..writeByte(2)
      ..write(obj.returnTotals)
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
      other is ReturnOrderListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReturnListDataAdapter extends TypeAdapter<ReturnListData> {
  @override
  final int typeId = 38;

  @override
  ReturnListData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReturnListData(
      returnId: fields[1] as String?,
      orderId: fields[2] as String?,
      name: fields[3] as String?,
      status: fields[4] as String?,
      dateAdded: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReturnListData obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.returnId)
      ..writeByte(2)
      ..write(obj.orderId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.dateAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReturnListDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnOrderListModel _$ReturnOrderListModelFromJson(
        Map<String, dynamic> json) =>
    ReturnOrderListModel(
      returnData: (json['returnData'] as List<dynamic>?)
          ?.map((e) => ReturnListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      returnTotals: json['returnTotals'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total']
      ..eTag = json['etag'] as String?;

Map<String, dynamic> _$ReturnOrderListModelToJson(
        ReturnOrderListModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'etag': instance.eTag,
      'returnData': instance.returnData,
      'returnTotals': instance.returnTotals,
    };

ReturnListData _$ReturnListDataFromJson(Map<String, dynamic> json) =>
    ReturnListData(
      returnId: json['return_id'] as String?,
      orderId: json['order_id'] as String?,
      name: json['name'] as String?,
      status: json['status'] as String?,
      dateAdded: json['date_added'] as String?,
    );

Map<String, dynamic> _$ReturnListDataToJson(ReturnListData instance) =>
    <String, dynamic>{
      'return_id': instance.returnId,
      'order_id': instance.orderId,
      'name': instance.name,
      'status': instance.status,
      'date_added': instance.dateAdded,
    };
