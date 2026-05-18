import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/wishlist/wishlist_datum.dart';

import '../../hive/hive_constant.dart';

part 'get_wish_list.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyFour)
class GetWishlist extends BaseModel {
  @HiveField(100)
  @JsonKey(name: "etag")
  String? eTag = "";

  @JsonKey(name: "wishlistData")
  @HiveField(HiveConstant.One)
  List<WishlistDatum>? wishlistData;

  GetWishlist({
    this.wishlistData,
  });

  factory GetWishlist.fromJson(Map<String, dynamic> json) =>
      _$GetWishlistFromJson(json);

  Map<String, dynamic> toJson() => _$GetWishlistToJson(this);
}
