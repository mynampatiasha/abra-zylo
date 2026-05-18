// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_guest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutGuestModel _$CheckoutGuestModelFromJson(Map<String, dynamic> json) =>
    CheckoutGuestModel(
      headingTitle: json['heading_title'] as String?,
      shippingRequired: json['shipping_required'] as bool?,
      guestData: json['guest'] == null
          ? null
          : CheckoutAddressModel.fromJson(
              json['guest'] as Map<String, dynamic>),
      account: json['account'] as String?,
      logged: json['logged'] as String?,
      cartCount: json['cartCount'],
      currencyCode: json['currency_code'] as String?,
    );

Map<String, dynamic> _$CheckoutGuestModelToJson(CheckoutGuestModel instance) =>
    <String, dynamic>{
      'heading_title': instance.headingTitle,
      'shipping_required': instance.shippingRequired,
      'guest': instance.guestData,
      'account': instance.account,
      'logged': instance.logged,
      'cartCount': instance.cartCount,
      'currency_code': instance.currencyCode,
    };

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      customerId: json['customer_id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'customer_id': instance.customerId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'phone': instance.phone,
    };
