import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';
import 'filter_group.dart';

part 'module_data.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyThree)
class ModuleData {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "path")
  String? path;
  @HiveField(HiveConstant.Two)
  @JsonKey(name: "filter_category")
  List<String>? filterCategory;
  @HiveField(HiveConstant.Three)
  @JsonKey(name: "filter_groups")
  List<FilterGroup>? filterGroups;

  ModuleData({
    this.path,
    this.filterCategory,
    this.filterGroups,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) =>
      _$ModuleDataFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleDataToJson(this);
}
