// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewsListModel _$ReviewsListModelFromJson(Map<String, dynamic> json) =>
    ReviewsListModel(
      total: json['total'] as int?,
      reviewsList: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewsListData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as int?
      ..message = json['message'] as String?;

Map<String, dynamic> _$ReviewsListModelToJson(ReviewsListModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'success': instance.success,
      'message': instance.message,
      'reviews': instance.reviewsList,
    };

ReviewsListData _$ReviewsListDataFromJson(Map<String, dynamic> json) =>
    ReviewsListData(
      reviewId: json['review_id'] as String?,
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String?,
      text: json['text'] as String?,
      rating: json['rating'] as String?,
      status: json['status'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ReviewsListDataToJson(ReviewsListData instance) =>
    <String, dynamic>{
      'review_id': instance.reviewId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'text': instance.text,
      'rating': instance.rating,
      'status': instance.status,
      'image': instance.image,
    };
