// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleDataAdapter extends TypeAdapter<ModuleData> {
  @override
  final int typeId = 33;

  @override
  ModuleData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleData(
      path: fields[1] as String?,
      filterCategory: (fields[2] as List?)?.cast<String>(),
      filterGroups: (fields[3] as List?)?.cast<FilterGroup>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModuleData obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.filterCategory)
      ..writeByte(3)
      ..write(obj.filterGroups);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleData _$ModuleDataFromJson(Map<String, dynamic> json) => ModuleData(
      path: json['path'] as String?,
      filterCategory: (json['filter_category'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      filterGroups: (json['filter_groups'] as List<dynamic>?)
          ?.map((e) => FilterGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModuleDataToJson(ModuleData instance) =>
    <String, dynamic>{
      'path': instance.path,
      'filter_category': instance.filterCategory,
      'filter_groups': instance.filterGroups,
    };
