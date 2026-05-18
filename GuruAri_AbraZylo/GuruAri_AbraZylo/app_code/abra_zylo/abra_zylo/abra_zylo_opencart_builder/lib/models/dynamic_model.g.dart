// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DynamicModelAdapter extends TypeAdapter<DynamicModel> {
  @override
  final int typeId = 12;

  @override
  DynamicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicModel(
      response: fields[0] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, DynamicModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.response);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicModel _$DynamicModelFromJson(Map<String, dynamic> json) => DynamicModel(
      response: json['response'],
    );

Map<String, dynamic> _$DynamicModelToJson(DynamicModel instance) =>
    <String, dynamic>{
      'response': instance.response,
    };
