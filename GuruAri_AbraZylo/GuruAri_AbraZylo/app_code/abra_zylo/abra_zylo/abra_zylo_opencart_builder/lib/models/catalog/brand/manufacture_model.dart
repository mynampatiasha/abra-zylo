import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/product/product.dart';

import '../../../hive/hive_constant.dart';

part 'manufacture_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.FourtyThree)
class ManufactureModel extends BaseModel {
  @HiveField(100)
  @JsonKey(name: "etag")
  String? eTag = "";

  @HiveField(HiveConstant.Two)
  Manufacturers? manufacturers;

  ManufactureModel({this.manufacturers});

  factory ManufactureModel.fromJson(Map<String, dynamic> json) =>
      _$ManufactureModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManufactureModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.FourtyFour)
class Manufacturers {
  @HiveField(HiveConstant.Three)
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "text_empty")
  @HiveField(4)
  String? textEmpty;
  @JsonKey(name: "text_quantity")
  @HiveField(5)
  String? textQuantity;
  @JsonKey(name: "text_manufacturer")
  @HiveField(6)
  String? textManufacturer;
  @JsonKey(name: "text_model")
  @HiveField(7)
  String? textModel;
  @JsonKey(name: "text_price")
  @HiveField(8)
  String? textPrice;
  @JsonKey(name: "text_tax")
  @HiveField(9)
  String? textTax;
  @JsonKey(name: "text_points")
  @HiveField(10)
  String? textPoints;

  @JsonKey(name: "text_compare")
  @HiveField(11)
  String? textCompare;
  @JsonKey(name: "text_sort")
  @HiveField(12)
  String? textSort;
  @JsonKey(name: "text_limit")
  @HiveField(13)
  String? textLimit;
  @JsonKey(name: "button_cart")
  @HiveField(14)
  String? buttonCart;
  @JsonKey(name: "button_wishlist")
  @HiveField(27)
  String? buttonWishlist;
  @JsonKey(name: "button_compare")
  @HiveField(15)
  String? buttonCompare;
  @JsonKey(name: "button_continue")
  @HiveField(16)
  String? buttonContinue;
  @JsonKey(name: "button_list")
  @HiveField(17)
  String? buttonList;
  @JsonKey(name: "button_grid")
  @HiveField(18)
  String? buttonGrid;
  @JsonKey(name: "products")
  @HiveField(19)
  List<Product>? products;
  @JsonKey(name: "sorts")
  @HiveField(20)
  List<Sorts>? sorts;
  @JsonKey(name: "product_total")
  @HiveField(21)
  String? productTotal;
  @HiveField(22)
  List<Limits>? limits;
  @HiveField(23)
  String? results;
  @HiveField(24)
  String? sort;
  @HiveField(25)
  String? order;
  @HiveField(26)
  String? limit;

  Manufacturers(
      {this.headingTitle,
      this.textEmpty,
      this.textQuantity,
      this.textManufacturer,
      this.textModel,
      this.textPrice,
      this.textTax,
      this.textPoints,
      this.textCompare,
      this.textSort,
      this.textLimit,
      this.buttonCart,
      this.buttonWishlist,
      this.buttonCompare,
      this.buttonContinue,
      this.buttonList,
      this.buttonGrid,
      this.products,
      this.sorts,
      this.productTotal,
      this.limits,
      this.results,
      this.sort,
      this.order,
      this.limit});

  factory Manufacturers.fromJson(Map<String, dynamic> json) =>
      _$ManufacturersFromJson(json);

  Map<String, dynamic> toJson() => _$ManufacturersToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.FourtyFive)
class Sorts {
  String? text;
  String? value;
  String? order;

  Sorts({this.text, this.value, this.order});

  factory Sorts.fromJson(Map<String, dynamic> json) => _$SortsFromJson(json);

  Map<String, dynamic> toJson() => _$SortsToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.FourtySix)
class Limits {
  int? text;
  int? value;

  Limits({this.text, this.value});

  factory Limits.fromJson(Map<String, dynamic> json) => _$LimitsFromJson(json);

  Map<String, dynamic> toJson() => _$LimitsToJson(this);
}
