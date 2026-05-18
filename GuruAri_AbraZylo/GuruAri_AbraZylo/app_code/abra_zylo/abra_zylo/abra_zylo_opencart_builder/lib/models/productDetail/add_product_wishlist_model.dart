import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'add_product_wishlist_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyFour)
class AddProductToWishListModel {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "message")
  String? message = "";

  @HiveField(HiveConstant.Two)
  @JsonKey(name: "error")
  int? error = 0;

  @HiveField(HiveConstant.Three)
  @JsonKey(name: "wishlist_status")
  bool? wishliststatus;

  @HiveField(HiveConstant.Four)
  @JsonKey(name: "total")
  String? wishListTotal = "";

  AddProductToWishListModel(
      {this.message, this.error, this.wishliststatus, this.wishListTotal});

  factory AddProductToWishListModel.fromJson(Map<String, dynamic> json) =>
      _$AddProductToWishListModelFromJson(json);
}
