// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilterGroupAdapter extends TypeAdapter<FilterGroup> {
  @override
  final int typeId = 28;

  @override
  FilterGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilterGroup(
      filterGroupId: fields[1] as String?,
      name: fields[2] as String?,
      filter: (fields[3] as List?)?.cast<Filter>(),
    );
  }

  @override
  void write(BinaryWriter writer, FilterGroup obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.filterGroupId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.filter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterGroup _$FilterGroupFromJson(Map<String, dynamic> json) => FilterGroup(
      filterGroupId: json['filter_group_id'] as String?,
      name: json['name'] as String?,
      filter: (json['filter'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilterGroupToJson(FilterGroup instance) =>
    <String, dynamic>{
      'filter_group_id': instance.filterGroupId,
      'name': instance.name,
      'filter': instance.filter,
    };
