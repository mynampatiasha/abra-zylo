// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutPaymentMethodModel _$CheckoutPaymentMethodModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutPaymentMethodModel(
      headingTitle: json['heading_title'] as String?,
      shippingRequired: json['shipping_required'] as bool?,
      paymentMethods: json['paymentMethods'] == null
          ? null
          : PaymentMethods.fromJson(
              json['paymentMethods'] as Map<String, dynamic>),
      account: json['account'] as String?,
      logged: json['logged'] as String?,
      cartCount: json['cartCount'],
      currencyCode: json['currency_code'] as String?,
    );

Map<String, dynamic> _$CheckoutPaymentMethodModelToJson(
        CheckoutPaymentMethodModel instance) =>
    <String, dynamic>{
      'heading_title': instance.headingTitle,
      'shipping_required': instance.shippingRequired,
      'paymentMethods': instance.paymentMethods,
      'account': instance.account,
      'logged': instance.logged,
      'cartCount': instance.cartCount,
      'currency_code': instance.currencyCode,
    };

PaymentMethods _$PaymentMethodsFromJson(Map<String, dynamic> json) =>
    PaymentMethods(
      textPaymentMethod: json['text_payment_method'] as String?,
      textComments: json['text_comments'] as String?,
      textLoading: json['text_loading'] as String?,
      buttonContinue: json['button_continue'] as String?,
      errorWarning: json['error_warning'] as String?,
      paymentMethodList: (json['payment_methods'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as String?,
      comment: json['comment'] as String?,
      scripts: json['scripts'] as List<dynamic>?,
      textAgree: json['text_agree'] as String?,
      textAgreeInfo: json['text_agree_info'] as String?,
      agree: json['agree'] as String?,
    );

Map<String, dynamic> _$PaymentMethodsToJson(PaymentMethods instance) =>
    <String, dynamic>{
      'text_payment_method': instance.textPaymentMethod,
      'text_comments': instance.textComments,
      'text_loading': instance.textLoading,
      'button_continue': instance.buttonContinue,
      'error_warning': instance.errorWarning,
      'payment_methods': instance.paymentMethodList,
      'code': instance.code,
      'comment': instance.comment,
      'scripts': instance.scripts,
      'text_agree': instance.textAgree,
      'text_agree_info': instance.textAgreeInfo,
      'agree': instance.agree,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      code: json['code'] as String?,
      title: json['title'] as String?,
      terms: json['terms'] as String?,
      sortOrder: json['sort_order'] as String?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'terms': instance.terms,
      'sort_order': instance.sortOrder,
    };
