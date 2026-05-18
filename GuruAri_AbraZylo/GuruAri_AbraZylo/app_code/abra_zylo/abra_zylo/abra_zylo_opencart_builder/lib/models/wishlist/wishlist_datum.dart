import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../hive/hive_constant.dart';

part 'wishlist_datum.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyFour)
class WishlistDatum extends BaseModel {
  @JsonKey(name: "product_id")
  @HiveField(HiveConstant.One)
  String? productId;
  @JsonKey(name: "is_ar")
  @HiveField(HiveConstant.Two)
  bool? isAr;
  @JsonKey(name: "thumb")
  @HiveField(HiveConstant.Three)
  dynamic? thumb;
  @JsonKey(name: "dominant_color")
  @HiveField(HiveConstant.Four)
  String? dominantColor;

  @JsonKey(name: "name")
  @HiveField(HiveConstant.Five)
  String? name;

  @JsonKey(name: "model")
  @HiveField(HiveConstant.Six)
  String? model;
  @JsonKey(name: "stock")
  @HiveField(HiveConstant.Seven)
  String? stock;
  @JsonKey(name: "price")
  @HiveField(HiveConstant.Eight)
  String? price;

  @JsonKey(name: "formatted_special")
  @HiveField(HiveConstant.Nine)
  String? formattedSpecial;
  @JsonKey(name: "hasOption")
  @HiveField(HiveConstant.Ten)
  bool? hasOption;
  WishlistDatum(
      {this.productId,
      this.isAr,
      this.thumb,
      this.dominantColor,
      this.name,
      this.model,
      this.stock,
      this.price,
      this.formattedSpecial,
      this.hasOption});

  factory WishlistDatum.fromJson(Map<String, dynamic> json) =>
      _$WishlistDatumFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistDatumToJson(this);
}
