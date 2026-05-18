// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GuestOrderReturn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestOrderReturn _$GuestOrderReturnFromJson(Map<String, dynamic> json) =>
    GuestOrderReturn(
      orderId: json['order_id'] as String?,
      invoiceNo: json['invoice_no'] as String?,
      customerId: json['customer_id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$GuestOrderReturnToJson(GuestOrderReturn instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'order_id': instance.orderId,
      'invoice_no': instance.invoiceNo,
      'customer_id': instance.customerId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'telephone': instance.telephone,
      'email': instance.email,
    };
