// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) => SearchModel(
      searchData: (json['search_data'] as List<dynamic>?)
          ?.map((e) => SearchData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'search_data': instance.searchData,
    };

SearchData _$SearchDataFromJson(Map<String, dynamic> json) => SearchData(
      productId: json['product_id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SearchDataToJson(SearchData instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
    };
