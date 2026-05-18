import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'sort.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentySeven)
class Sort {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "text")
  String? text;
  @HiveField(HiveConstant.Two)
  @JsonKey(name: "value")
  String? value;
  @HiveField(HiveConstant.Three)
  @JsonKey(name: "order")
  String? order;
  @HiveField(HiveConstant.Four)
  @JsonKey(name: "path")
  String? path;

  Sort({
    this.text,
    this.value,
    this.order,
    this.path,
  });

  @override
  String toString() {
    return 'Sort{text: $text, value: $value, order: $order, path: $path}';
  }

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

  Map<String, dynamic> toJson() => _$SortToJson(this);
}
