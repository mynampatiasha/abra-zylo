import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/catalog/filter_group.dart';
import 'package:oc_demo/models/catalog/sort.dart';
import 'package:oc_demo/models/product/product.dart';

import '../../hive/hive_constant.dart';
import '../base_model.dart';
import 'category_data.dart';
import 'module_data.dart';

part 'catalog_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentySix)
class CatalogModel extends BaseModel {
  @HiveField(100)
  @JsonKey(name: "etag")
  String? eTag = "";
  @HiveField(HiveConstant.One)
  @JsonKey(name: "categoryData")
  CategoryData? categoryData;
  @HiveField(HiveConstant.Two)
  @JsonKey(name: "moduleData")
  ModuleData? moduleData;
  @HiveField(HiveConstant.Three)
  @JsonKey(name: "products")
  List<Product>? products;
  @HiveField(HiveConstant.Four)
  @JsonKey(name: "product_total")
  String? productTotal;
  @HiveField(HiveConstant.Five)
  @JsonKey(name: "sorts")
  List<Sort>? sorts;
  @HiveField(HiveConstant.Six)
  @JsonKey(name: "filter_groups")
  List<FilterGroup>? filterGroups;

  CatalogModel({
    this.categoryData,
    this.moduleData,
    this.productTotal,
    this.products,
    this.filterGroups,
    this.sorts,
  });

  factory CatalogModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogModelFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogModelToJson(this);
}
