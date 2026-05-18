// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortAdapter extends TypeAdapter<Sort> {
  @override
  final int typeId = 27;

  @override
  Sort read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sort(
      text: fields[1] as String?,
      value: fields[2] as String?,
      order: fields[3] as String?,
      path: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Sort obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sort _$SortFromJson(Map<String, dynamic> json) => Sort(
      text: json['text'] as String?,
      value: json['value'] as String?,
      order: json['order'] as String?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$SortToJson(Sort instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
      'order': instance.order,
      'path': instance.path,
    };
