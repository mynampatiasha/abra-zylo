import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

import 'checkout_address_model.dart';
import 'checkout_payment_method_model.dart';
part 'checkout_shipping_method_model.g.dart';

@JsonSerializable()
class CheckoutShippingMethodModel extends BaseModel {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "shipping_required")
  bool? shippingRequired;
  ShippingMethods? shippingMethods;
  @JsonKey(name: "guestShipping")
  Address? guestData;
  String? account;
  String? logged;
  dynamic cartCount;
  @JsonKey(name: "currency_code")
  String? currencyCode;

  CheckoutShippingMethodModel(
      {this.headingTitle,
      this.shippingRequired,
      this.shippingMethods,
      this.account,
      this.guestData,
      this.logged,
      this.cartCount,
      this.currencyCode});
  factory CheckoutShippingMethodModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutShippingMethodModelFromJson(json);
}

@JsonSerializable()
class ShippingMethods {
  @JsonKey(name: "text_Shipping_method")
  String? textShippingMethod;
  @JsonKey(name: "text_comments")
  String? textComments;
  @JsonKey(name: "text_loading")
  String? textLoading;
  @JsonKey(name: "button_continue")
  String? buttonContinue;
  @JsonKey(name: "error_warning")
  String? errorWarning;
  @JsonKey(name: "shipping_methods")
  List<ShippingMethod>? shippingMethodList;
  @JsonKey(name: "payment_methods")
  List<PaymentMethod>? paymentMethodList;
/*  @JsonKey(name: "payment_methods")
  PaymentMethods? paymentMethod;*/
  String? code;
  String? comment;
  @JsonKey(name: "text_agree")
  String? textAgree;
  @JsonKey(name: "text_agree_info")
  String? textAgreeInfo;
  String? agree;

  ShippingMethods(
      {this.textShippingMethod,
      this.textComments,
      this.textLoading,
      this.buttonContinue,
      this.errorWarning,
      this.shippingMethodList,
      this.paymentMethodList,
      this.code,
      this.comment,
      this.textAgree,
      this.textAgreeInfo,
      this.agree});

  factory ShippingMethods.fromJson(Map<String, dynamic> json) =>
      _$ShippingMethodsFromJson(json);
}

@JsonSerializable()
class ShippingMethod {
  String? title;
  List<Quote>? quote;
  @JsonKey(name: "sort_order")
  String? sortOrder;
  bool? error;

  ShippingMethod({this.title, this.quote, this.sortOrder, this.error});

  factory ShippingMethod.fromJson(Map<String, dynamic> json) =>
      _$ShippingMethodFromJson(json);
}

@JsonSerializable()
class Quote {
  String? code;
  String? title;
  dynamic? cost;
  @JsonKey(name: "tax_class_id")
  dynamic? taxClassId;
  String? text;

  Quote({this.code, this.title, this.cost, this.taxClassId, this.text});

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
