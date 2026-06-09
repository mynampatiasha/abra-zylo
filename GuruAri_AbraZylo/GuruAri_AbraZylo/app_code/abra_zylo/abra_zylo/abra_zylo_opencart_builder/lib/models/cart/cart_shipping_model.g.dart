// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_shipping_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartShippingModel _$CartShippingModelFromJson(Map<String, dynamic> json) =>
    CartShippingModel(
      error: json['error'],
      shippingMethod: (json['shippingMethod'] as List<dynamic>?)
          ?.map((e) => ShippingMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'],
    )
      ..fault = json['fault'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$CartShippingModelToJson(CartShippingModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'error': instance.error,
      'message': instance.message,
      'shippingMethod': instance.shippingMethod,
    };

ShippingMethod _$ShippingMethodFromJson(Map<String, dynamic> json) =>
    ShippingMethod(
      title: json['title'] as String?,
      quote: (json['quote'] as List<dynamic>?)
          ?.map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: json['sortOrder'] as String?,
    );

Map<String, dynamic> _$ShippingMethodToJson(ShippingMethod instance) =>
    <String, dynamic>{
      'title': instance.title,
      'quote': instance.quote,
      'sortOrder': instance.sortOrder,
    };

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      code: json['code'] as String?,
      title: json['title'] as String?,
      cost: json['cost'],
      taxClassId: json['taxClassId'],
      text: json['text'] as String?,
    )..isSelected = json['isSelected'] as bool?;

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'cost': instance.cost,
      'taxClassId': instance.taxClassId,
      'text': instance.text,
      'isSelected': instance.isSelected,
    };
