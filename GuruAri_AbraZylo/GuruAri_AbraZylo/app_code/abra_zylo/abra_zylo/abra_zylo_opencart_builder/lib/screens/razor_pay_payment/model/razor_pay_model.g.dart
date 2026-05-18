// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'razor_pay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RazorPayModel _$RazorPayModelFromJson(Map<String, dynamic> json) =>
    RazorPayModel(
      keyId: json['key_id'] as String?,
      secretKey: json['secret_key'] as String?,
      orderPaymentId: json['order_payment_id'] as String?,
      error: json['error'] as String?,
      currency: json['currency'] as String?,
      total: json['total'] as String?,
    );

Map<String, dynamic> _$RazorPayModelToJson(RazorPayModel instance) =>
    <String, dynamic>{
      'key_id': instance.keyId,
      'secret_key': instance.secretKey,
      'order_payment_id': instance.orderPaymentId,
      'error': instance.error,
      'currency': instance.currency,
      'total': instance.total,
    };
