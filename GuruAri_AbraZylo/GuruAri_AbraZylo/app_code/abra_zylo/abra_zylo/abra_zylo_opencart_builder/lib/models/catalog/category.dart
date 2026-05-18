import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'category.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyTwo)
class Category {
  @HiveField(HiveConstant.One)
  String? name;
  @HiveField(HiveConstant.Two)
  String? path;

  Category({
    this.name,
    this.path,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
