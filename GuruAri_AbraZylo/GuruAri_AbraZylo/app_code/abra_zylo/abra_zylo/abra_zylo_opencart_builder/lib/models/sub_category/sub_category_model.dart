import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../hive/hive_constant.dart';
import '../homPage/home_screen_model.dart';

part 'sub_category_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.Thirty)
class SubCategoryModel extends BaseModel {
  @HiveField(100)
  @JsonKey(name: "etag")
  String? eTag = "";
  @HiveField(HiveConstant.One)
  List<Categories>? categories;
  @HiveField(HiveConstant.Two)
  SubCategoryModel({this.categories});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryModelToJson(this);
}
