import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';
import '../product/product.dart';
import 'category.dart';
import 'sort.dart';

part 'category_data.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyOne)
class CategoryData {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "thumb")
  String? thumb;
  @HiveField(HiveConstant.Two)
  @JsonKey(name: "description")
  String? description;
  @HiveField(HiveConstant.Three)
  @JsonKey(name: "categories")
  List<Category>? categories;
  @HiveField(HiveConstant.Four)
  @JsonKey(name: "products")
  List<Product>? products;
  @HiveField(HiveConstant.Five)
  @JsonKey(name: "product_total")
  String? productTotal;
  @HiveField(HiveConstant.Six)
  @JsonKey(name: "sorts")
  List<Sort>? sorts;

  CategoryData({
    this.thumb,
    this.description,
    this.categories,
    this.products,
    this.productTotal,
    this.sorts,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}
