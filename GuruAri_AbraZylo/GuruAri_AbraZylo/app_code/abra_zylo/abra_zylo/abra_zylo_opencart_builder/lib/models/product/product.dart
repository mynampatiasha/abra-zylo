import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'product.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.Eleven)
class Product {
  @JsonKey(name: "product_id")
  @HiveField(HiveConstant.Two)
  String? productId;
  @JsonKey(name: "thumb")
  @HiveField(HiveConstant.Three)
  String? thumb;
  @JsonKey(name: "name")
  @HiveField(HiveConstant.Four)
  String? name;
  @JsonKey(name: "description")
  @HiveField(HiveConstant.Five)
  String? description;
  @JsonKey(name: "price")
  @HiveField(HiveConstant.Six)
  String? price;
  @JsonKey(name: "special")
  @HiveField(HiveConstant.Seven)
  dynamic? special;
  @JsonKey(name: "tax")
  @HiveField(HiveConstant.Eight)
  String? tax;
  @JsonKey(name: "minimum")
  @HiveField(HiveConstant.Nine)
  dynamic? minimum;
  @JsonKey(name: "rating")
  @HiveField(HiveConstant.Ten)
  int? rating;
  @JsonKey(name: "path")
  @HiveField(HiveConstant.Twelve)
  String? path;
  @JsonKey(name: "dominant_color")
  @HiveField(HiveConstant.Thirten)
  String? dominantColor;
  @JsonKey(name: "hasOption")
  @HiveField(HiveConstant.Fourteen)
  bool? hasOption;
  @JsonKey(name: "formatted_special")
  @HiveField(HiveConstant.Fifteen)
  String? formattedSpecial;
  @JsonKey(name: "wishlist_status")
  @HiveField(HiveConstant.Sixteen)
  bool? wishlistStatus;
  @JsonKey(name: "is_ar")
  @HiveField(HiveConstant.Seventeen)
  bool? ar;

  Product({
    this.productId,
    this.thumb,
    this.name,
    this.description,
    this.price,
    this.special,
    this.tax,
    this.minimum,
    this.rating,
    this.path,
    this.dominantColor,
    this.hasOption,
    this.formattedSpecial,
    this.wishlistStatus,
    this.ar,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
