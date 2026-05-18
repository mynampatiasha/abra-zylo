// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompareProduct _$CompareProductFromJson(Map<String, dynamic> json) =>
    CompareProduct(
      (json['products'] as List<dynamic>?)
          ?.map((e) => CompareProductData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$CompareProductToJson(CompareProduct instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'products': instance.compareProductList,
    };

CompareProductData _$CompareProductDataFromJson(Map<String, dynamic> json) =>
    CompareProductData(
      imageLink: json['image_link'] as String?,
      descriptionShort: json['descriptionShort'] as String?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      description: json['description'] as String?,
      productId: json['product_id'] as int?,
      addedInWishlist: json['added_in_wishlist'] as String?,
      displayAddtocart: json['display_addtocart'] as String?,
      model: json['model'] as String?,
      isCombinationProduct: json['is_combination_product'] as String?,
      oldPrice: json['old_price'] as String?,
      reductionAmount: json['reduction_amount'] as String?,
      showPrice: json['show_price'] as String?,
      avarageRating: json['avarage_rating'] as String?,
      tax: json['tax'] as String?,
      reviews: json['reviews'] as String?,
      rating: json['rating'] as int?,
      manufacturer: json['manufacturer'] as String?,
      popup: json['popup'] as String?,
      review_status: json['review_status'] as String?,
      stock: json['stock'] as String?,
      tab_review: json['tab_review'] as String?,
      thumb: json['thumb'] as String?,
      wishlist_status: json['wishlist_status'] as bool?,
    );

Map<String, dynamic> _$CompareProductDataToJson(CompareProductData instance) =>
    <String, dynamic>{
      'tab_review': instance.tab_review,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'stock': instance.stock,
      'product_id': instance.productId,
      'popup': instance.popup,
      'thumb': instance.thumb,
      'wishlist_status': instance.wishlist_status,
      'review_status': instance.review_status,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'name': instance.name,
      'tax': instance.tax,
      'descriptionShort': instance.descriptionShort,
      'description': instance.description,
      'price': instance.price,
      'image_link': instance.imageLink,
      'reduction_amount': instance.reductionAmount,
      'old_price': instance.oldPrice,
      'show_price': instance.showPrice,
      'display_addtocart': instance.displayAddtocart,
      'is_combination_product': instance.isCombinationProduct,
      'added_in_wishlist': instance.addedInWishlist,
      'avarage_rating': instance.avarageRating,
    };
