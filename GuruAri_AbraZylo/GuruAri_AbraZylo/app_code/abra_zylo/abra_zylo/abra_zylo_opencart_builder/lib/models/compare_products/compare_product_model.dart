import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'compare_product_model.g.dart';

@JsonSerializable()
class CompareProduct extends BaseModel {
  @JsonKey(name: "products", defaultValue: null)
  List<CompareProductData>? compareProductList = null;

  CompareProduct(this.compareProductList);

  factory CompareProduct.fromJson(Map<String, dynamic> json) =>
      _$CompareProductFromJson(json);

  // List<CompareProductData> getCompareProduct() {
  //   List<CompareProductData> value = [];
  //   try {
  //     if (compareProduct != null) {
  //       if (compareProduct is List) {
  //         for (var e in (compareProduct as List)) {
  //           value.add(CompareProductData.fromJson(manipulateMap(e)));
  //         }
  //       } else {
  //         value = [CompareProductData.fromJson(manipulateMap(compareProduct))];
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   return value;
  // }
}
//
// Map<String, dynamic> manipulateMap(var item) {
//   Map<String, dynamic> updatedMap = Map();
//
//   if (item is Map) {
//     item.forEach((key, value) {
//       updatedMap[key.toString()] = value;
//     });
//   }
//
//   return updatedMap;
//
// }

@JsonSerializable()
class CompareProductData {
  @JsonKey(name: "tab_review")
  String? tab_review;

  @JsonKey(name: "manufacturer")
  String? manufacturer;

  @JsonKey(name: "model")
  String? model;

  @JsonKey(name: "stock")
  String? stock;

  @JsonKey(name: "product_id")
  int? productId;

  @JsonKey(name: "popup")
  String? popup;

  @JsonKey(name: "thumb")
  String? thumb;

  @JsonKey(name: "wishlist_status")
  bool? wishlist_status;

  @JsonKey(name: "review_status")
  String? review_status;

  @JsonKey(name: "rating")
  int? rating;

  @JsonKey(name: "reviews")
  String? reviews;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "tax")
  String? tax;

  @JsonKey(name: "descriptionShort")
  String? descriptionShort;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "price")
  String? price;

  @JsonKey(name: "image_link")
  String? imageLink;

  @JsonKey(name: "reduction_amount")
  String? reductionAmount;

  @JsonKey(name: "old_price")
  String? oldPrice;

  @JsonKey(name: "show_price")
  String? showPrice;

  @JsonKey(name: "display_addtocart")
  String? displayAddtocart;

  @JsonKey(name: "is_combination_product")
  String? isCombinationProduct;

  @JsonKey(name: "added_in_wishlist")
  String? addedInWishlist;

  @JsonKey(name: "avarage_rating")
  String? avarageRating;

  CompareProductData(
      {this.imageLink,
      this.descriptionShort,
      this.name,
      this.price,
      this.description,
      this.productId,
      this.addedInWishlist,
      this.displayAddtocart,
      this.model,
      this.isCombinationProduct,
      this.oldPrice,
      this.reductionAmount,
      this.showPrice,
      this.avarageRating,
      this.tax,
      this.reviews,
      this.rating,
      this.manufacturer,
      this.popup,
      this.review_status,
      this.stock,
      this.tab_review,
      this.thumb,
      this.wishlist_status});

  factory CompareProductData.fromJson(Map<String, dynamic> json) =>
      _$CompareProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$CompareProductDataToJson(this);
}
