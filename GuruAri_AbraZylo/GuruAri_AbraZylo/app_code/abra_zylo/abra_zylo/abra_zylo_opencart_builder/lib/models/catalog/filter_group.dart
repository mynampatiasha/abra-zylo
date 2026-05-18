import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';
import 'filter.dart';

part 'filter_group.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyEight)
class FilterGroup {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "filter_group_id")
  String? filterGroupId;
  @HiveField(HiveConstant.Two)
  @JsonKey(name: "name")
  String? name;
  @HiveField(HiveConstant.Three)
  @JsonKey(name: "filter")
  List<Filter>? filter;

  FilterGroup({
    this.filterGroupId,
    this.name,
    this.filter,
  });

  factory FilterGroup.fromJson(Map<String, dynamic> json) =>
      _$FilterGroupFromJson(json);

  Map<String, dynamic> toJson() => _$FilterGroupToJson(this);
}
