// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_confirm_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutConfirmOrderModel _$CheckoutConfirmOrderModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutConfirmOrderModel(
      success: json['success'] == null
          ? null
          : Success.fromJson(json['success'] as Map<String, dynamic>),
      error: json['error'] as int?,
      orderId: json['order_id'] as int? ?? 0,
    );

Map<String, dynamic> _$CheckoutConfirmOrderModelToJson(
        CheckoutConfirmOrderModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'success': instance.success,
      'error': instance.error,
    };

Success _$SuccessFromJson(Map<String, dynamic> json) => Success(
      headingTitle: json['heading_title'] as String?,
      textMessage: json['text_message'] as String?,
      buttonContinue: json['button_continue'] as String?,
    );

Map<String, dynamic> _$SuccessToJson(Success instance) => <String, dynamic>{
      'heading_title': instance.headingTitle,
      'text_message': instance.textMessage,
      'button_continue': instance.buttonContinue,
    };
