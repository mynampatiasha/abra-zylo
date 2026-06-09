// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnOrderRequest _$ReturnOrderRequestFromJson(Map<String, dynamic> json) =>
    ReturnOrderRequest(
      error: json['error'],
      orderId: json['order_id'] as String?,
      dateOrdered: json['date_ordered'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      product: json['product'] as String?,
      model: json['model'] as String?,
      returnReasons: (json['return_reasons'] as List<dynamic>?)
          ?.map((e) => ReturnReasons.fromJson(e as Map<String, dynamic>))
          .toList(),
      captcha: json['captcha'] as String?,
      agree: json['agree'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$ReturnOrderRequestToJson(ReturnOrderRequest instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'error': instance.error,
      'order_id': instance.orderId,
      'date_ordered': instance.dateOrdered,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'telephone': instance.telephone,
      'product': instance.product,
      'model': instance.model,
      'return_reasons': instance.returnReasons,
      'captcha': instance.captcha,
      'agree': instance.agree,
    };

ReturnReasons _$ReturnReasonsFromJson(Map<String, dynamic> json) =>
    ReturnReasons(
      returnReasonId: json['return_reason_id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ReturnReasonsToJson(ReturnReasons instance) =>
    <String, dynamic>{
      'return_reason_id': instance.returnReasonId,
      'name': instance.name,
    };
