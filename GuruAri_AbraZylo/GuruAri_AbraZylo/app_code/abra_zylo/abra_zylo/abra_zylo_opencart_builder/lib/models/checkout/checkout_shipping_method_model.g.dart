// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_shipping_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutShippingMethodModel _$CheckoutShippingMethodModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutShippingMethodModel(
      headingTitle: json['heading_title'] as String?,
      shippingRequired: json['shipping_required'] as bool?,
      shippingMethods: json['shippingMethods'] == null
          ? null
          : ShippingMethods.fromJson(
              json['shippingMethods'] as Map<String, dynamic>),
      account: json['account'] as String?,
      guestData: json['guestShipping'] == null
          ? null
          : Address.fromJson(json['guestShipping'] as Map<String, dynamic>),
      logged: json['logged'] as String?,
      cartCount: json['cartCount'],
      currencyCode: json['currency_code'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$CheckoutShippingMethodModelToJson(
        CheckoutShippingMethodModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'heading_title': instance.headingTitle,
      'shipping_required': instance.shippingRequired,
      'shippingMethods': instance.shippingMethods,
      'guestShipping': instance.guestData,
      'account': instance.account,
      'logged': instance.logged,
      'cartCount': instance.cartCount,
      'currency_code': instance.currencyCode,
    };

ShippingMethods _$ShippingMethodsFromJson(Map<String, dynamic> json) =>
    ShippingMethods(
      textShippingMethod: json['text_Shipping_method'] as String?,
      textComments: json['text_comments'] as String?,
      textLoading: json['text_loading'] as String?,
      buttonContinue: json['button_continue'] as String?,
      errorWarning: json['error_warning'] as String?,
      shippingMethodList: (json['shipping_methods'] as List<dynamic>?)
          ?.map((e) => ShippingMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethodList: (json['payment_methods'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as String?,
      comment: json['comment'] as String?,
      textAgree: json['text_agree'] as String?,
      textAgreeInfo: json['text_agree_info'] as String?,
      agree: json['agree'] as String?,
    );

Map<String, dynamic> _$ShippingMethodsToJson(ShippingMethods instance) =>
    <String, dynamic>{
      'text_Shipping_method': instance.textShippingMethod,
      'text_comments': instance.textComments,
      'text_loading': instance.textLoading,
      'button_continue': instance.buttonContinue,
      'error_warning': instance.errorWarning,
      'shipping_methods': instance.shippingMethodList,
      'payment_methods': instance.paymentMethodList,
      'code': instance.code,
      'comment': instance.comment,
      'text_agree': instance.textAgree,
      'text_agree_info': instance.textAgreeInfo,
      'agree': instance.agree,
    };

ShippingMethod _$ShippingMethodFromJson(Map<String, dynamic> json) =>
    ShippingMethod(
      title: json['title'] as String?,
      quote: (json['quote'] as List<dynamic>?)
          ?.map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: json['sort_order'] as String?,
      error: json['error'] as bool?,
    );

Map<String, dynamic> _$ShippingMethodToJson(ShippingMethod instance) =>
    <String, dynamic>{
      'title': instance.title,
      'quote': instance.quote,
      'sort_order': instance.sortOrder,
      'error': instance.error,
    };

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      code: json['code'] as String?,
      title: json['title'] as String?,
      cost: json['cost'],
      taxClassId: json['tax_class_id'],
      text: json['text'] as String?,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'cost': instance.cost,
      'tax_class_id': instance.taxClassId,
      'text': instance.text,
    };
