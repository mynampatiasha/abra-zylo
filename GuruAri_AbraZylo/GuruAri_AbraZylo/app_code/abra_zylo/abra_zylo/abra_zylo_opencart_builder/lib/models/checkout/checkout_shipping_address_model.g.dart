// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_shipping_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutShippingAddressModel _$CheckoutShippingAddressModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutShippingAddressModel(
      headingTitle: json['heading_title'] as String?,
      shippingRequired: json['shipping_required'] as bool?,
      shippingAddress: json['shippingAddress'] == null
          ? null
          : CheckoutAddressModel.fromJson(
              json['shippingAddress'] as Map<String, dynamic>),
      account: json['account'] as String?,
      logged: json['logged'] as String?,
      cartCount: json['cartCount'],
      currencyCode: json['currency_code'] as String?,
    );

Map<String, dynamic> _$CheckoutShippingAddressModelToJson(
        CheckoutShippingAddressModel instance) =>
    <String, dynamic>{
      'heading_title': instance.headingTitle,
      'shipping_required': instance.shippingRequired,
      'shippingAddress': instance.shippingAddress,
      'account': instance.account,
      'logged': instance.logged,
      'cartCount': instance.cartCount,
      'currency_code': instance.currencyCode,
    };
