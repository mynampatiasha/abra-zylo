// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseModelAdapter extends TypeAdapter<BaseModel> {
  @override
  final int typeId = 24;

  @override
  BaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseModel(
      fault: fields[201] as int?,
      message: fields[202] as String?,
      error: fields[203] as int?,
      redirect: fields[204] as String?,
      newsletter: fields[205] as dynamic,
      cartTotal: fields[206] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, BaseModel obj) {
    writer
      ..writeByte(6)
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
      other is BaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) => BaseModel(
      fault: json['fault'] as int?,
      message: json['message'] as String?,
      error: json['error'] as int?,
      redirect: json['redirect'] as String?,
      newsletter: json['newsletter'],
      cartTotal: json['total'],
    );

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
    };
