import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'carousel_model.g.dart';

@JsonSerializable()
class CarouselModel {
  @JsonKey(name: "home_sequence_id")
  String? homeSequenceId;
  @JsonKey(name: "image_sub_type")
  String? imageSubType;
  String? id;
  String? title;
  String? type;
  @JsonKey(name: "product_type")
  String? productType;
  @JsonKey(name: "sort_order")
  String? sortOrder;
  @JsonKey(name: "products")
  List<Product>? product;
  @JsonKey(name: "image_all_parrent_category")
  List<Categories>? imageTypeCategoryCarousal;
  @JsonKey(name: "image_catagory")
  List<Categories>? imageCatagory;
  @JsonKey(name: "image_carousel")
  List<SliderImages>? slider;
  @JsonKey(name: "image_manufacturer")
  List<ImageManufacturer>? imageManufacturer;
  @JsonKey(name: "total_count")
  int? totalCount;

  CarouselModel(
      {this.homeSequenceId,
      this.id,
      this.title,
      this.type,
      this.imageSubType,
      this.productType,
      this.sortOrder,
      this.product,
      this.slider,
      this.imageTypeCategoryCarousal,
      this.imageCatagory,
      this.imageManufacturer});
  factory CarouselModel.fromJson(Map<String, dynamic> json) =>
      _$CarouselModelFromJson(json);
}

@JsonSerializable()
class Product {
  @JsonKey(name: "product_id")
  String? productId;
  String? thumb;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? name;
  String? price;
  String? quantity;
  int? special;
  @JsonKey(name: "formatted_special")
  String? formattedSpecial;
  String? tax;
  int? rating;
  String? reviews;
  bool? hasOption;
  @JsonKey(name: "wishlist_status")
  bool? wishlistStatus;

  Product(
      {this.productId,
      this.thumb,
      this.dominantColor,
      this.name,
      this.price,
      this.quantity,
      this.special,
      this.formattedSpecial,
      this.tax,
      this.rating,
      this.reviews,
      this.hasOption,
      this.wishlistStatus});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
class Categories {
  String? name;
  @JsonKey(name: "child_status")
  bool? childStatus;
  String? path;
  String? image;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? icon;
  @JsonKey(name: "dominant_color_icon")
  String? dominantColorIcon;

  Categories(
      {this.name,
      this.childStatus,
      this.path,
      this.image,
      this.dominantColor,
      this.icon,
      this.dominantColorIcon});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);
}

@JsonSerializable()
class HomeSequenceElement {
  String? id;
  String? type;

  HomeSequenceElement({
    this.id,
    this.type,
  });
  factory HomeSequenceElement.fromJson(Map<String, dynamic> json) =>
      _$HomeSequenceElementFromJson(json);
}

@JsonSerializable()
class SliderImages {
  @JsonKey(name: "banner_title")
  String? bannerTitle;
  String? title;
  String? type;
  String? link;
  String? image;
  String? dominantColor;

  SliderImages(
      {this.bannerTitle,
      this.title,
      this.type,
      this.link,
      this.image,
      this.dominantColor});

  factory SliderImages.fromJson(Map<String, dynamic> json) =>
      _$SliderImagesFromJson(json);
}

@JsonSerializable()
class ImageTypeCategoryCarousal {
  String? name;
  @JsonKey(name: "child_status")
  bool? childStatus;
  String? path;
  String? image;
  String? dominantColor;
  String? icon;
  String? dominantColorIcon;

  ImageTypeCategoryCarousal(
      {this.name,
      this.childStatus,
      this.path,
      this.image,
      this.dominantColor,
      this.icon,
      this.dominantColorIcon});

  factory ImageTypeCategoryCarousal.fromJson(Map<String, dynamic> json) =>
      _$ImageTypeCategoryCarousalFromJson(json);
}

@JsonSerializable()
class ImageManufacturer {
  @JsonKey(name: "manufacturer_id")
  String? manufacturerId;
  String? name;
  String? image;

  ImageManufacturer({this.manufacturerId, this.name, this.image});
  factory ImageManufacturer.fromJson(Map<String, dynamic> json) =>
      _$ImageManufacturerFromJson(json);
}
