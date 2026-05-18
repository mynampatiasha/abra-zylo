import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'filter.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyNine)
class Filter {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "filter_id")
  String? filterId;
  @HiveField(HiveConstant.Two)
  @JsonKey(name: "name")
  String? name;

  @JsonKey(ignore: true)
  bool? selected = false;

  Filter({this.filterId, this.name, this.selected});

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}
