// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarouselModel _$CarouselModelFromJson(Map<String, dynamic> json) =>
    CarouselModel(
      homeSequenceId: json['home_sequence_id'] as String?,
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      imageSubType: json['image_sub_type'] as String?,
      productType: json['product_type'] as String?,
      sortOrder: json['sort_order'] as String?,
      product: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      slider: (json['image_carousel'] as List<dynamic>?)
          ?.map((e) => SliderImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageTypeCategoryCarousal:
          (json['image_all_parrent_category'] as List<dynamic>?)
              ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
              .toList(),
      imageCatagory: (json['image_catagory'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageManufacturer: (json['image_manufacturer'] as List<dynamic>?)
          ?.map((e) => ImageManufacturer.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..totalCount = json['total_count'] as int?;

Map<String, dynamic> _$CarouselModelToJson(CarouselModel instance) =>
    <String, dynamic>{
      'home_sequence_id': instance.homeSequenceId,
      'image_sub_type': instance.imageSubType,
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'product_type': instance.productType,
      'sort_order': instance.sortOrder,
      'products': instance.product,
      'image_all_parrent_category': instance.imageTypeCategoryCarousal,
      'image_catagory': instance.imageCatagory,
      'image_carousel': instance.slider,
      'image_manufacturer': instance.imageManufacturer,
      'total_count': instance.totalCount,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['product_id'] as String?,
      thumb: json['thumb'] as String?,
      dominantColor: json['dominant_color'] as String?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      quantity: json['quantity'] as String?,
      special: json['special'] as int?,
      formattedSpecial: json['formatted_special'] as String?,
      tax: json['tax'] as String?,
      rating: json['rating'] as int?,
      reviews: json['reviews'] as String?,
      hasOption: json['hasOption'] as bool?,
      wishlistStatus: json['wishlist_status'] as bool?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.productId,
      'thumb': instance.thumb,
      'dominant_color': instance.dominantColor,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'special': instance.special,
      'formatted_special': instance.formattedSpecial,
      'tax': instance.tax,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'hasOption': instance.hasOption,
      'wishlist_status': instance.wishlistStatus,
    };

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      name: json['name'] as String?,
      childStatus: json['child_status'] as bool?,
      path: json['path'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominant_color'] as String?,
      icon: json['icon'] as String?,
      dominantColorIcon: json['dominant_color_icon'] as String?,
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'name': instance.name,
      'child_status': instance.childStatus,
      'path': instance.path,
      'image': instance.image,
      'dominant_color': instance.dominantColor,
      'icon': instance.icon,
      'dominant_color_icon': instance.dominantColorIcon,
    };

HomeSequenceElement _$HomeSequenceElementFromJson(Map<String, dynamic> json) =>
    HomeSequenceElement(
      id: json['id'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$HomeSequenceElementToJson(
        HomeSequenceElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
    };

SliderImages _$SliderImagesFromJson(Map<String, dynamic> json) => SliderImages(
      bannerTitle: json['banner_title'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      link: json['link'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominantColor'] as String?,
    );

Map<String, dynamic> _$SliderImagesToJson(SliderImages instance) =>
    <String, dynamic>{
      'banner_title': instance.bannerTitle,
      'title': instance.title,
      'type': instance.type,
      'link': instance.link,
      'image': instance.image,
      'dominantColor': instance.dominantColor,
    };

ImageTypeCategoryCarousal _$ImageTypeCategoryCarousalFromJson(
        Map<String, dynamic> json) =>
    ImageTypeCategoryCarousal(
      name: json['name'] as String?,
      childStatus: json['child_status'] as bool?,
      path: json['path'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominantColor'] as String?,
      icon: json['icon'] as String?,
      dominantColorIcon: json['dominantColorIcon'] as String?,
    );

Map<String, dynamic> _$ImageTypeCategoryCarousalToJson(
        ImageTypeCategoryCarousal instance) =>
    <String, dynamic>{
      'name': instance.name,
      'child_status': instance.childStatus,
      'path': instance.path,
      'image': instance.image,
      'dominantColor': instance.dominantColor,
      'icon': instance.icon,
      'dominantColorIcon': instance.dominantColorIcon,
    };

ImageManufacturer _$ImageManufacturerFromJson(Map<String, dynamic> json) =>
    ImageManufacturer(
      manufacturerId: json['manufacturer_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ImageManufacturerToJson(ImageManufacturer instance) =>
    <String, dynamic>{
      'manufacturer_id': instance.manufacturerId,
      'name': instance.name,
      'image': instance.image,
    };
