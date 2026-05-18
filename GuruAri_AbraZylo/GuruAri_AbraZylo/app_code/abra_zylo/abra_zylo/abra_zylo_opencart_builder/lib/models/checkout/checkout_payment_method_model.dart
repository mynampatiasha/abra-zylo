import 'package:json_annotation/json_annotation.dart';
part 'checkout_payment_method_model.g.dart';

@JsonSerializable()
class CheckoutPaymentMethodModel {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "shipping_required")
  bool? shippingRequired;
  PaymentMethods? paymentMethods;
  String? account;
  String? logged;
  dynamic? cartCount;
  @JsonKey(name: "currency_code")
  String? currencyCode;

  CheckoutPaymentMethodModel(
      {this.headingTitle,
      this.shippingRequired,
      this.paymentMethods,
      this.account,
      this.logged,
      this.cartCount,
      this.currencyCode});
  factory CheckoutPaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPaymentMethodModelFromJson(json);
}

@JsonSerializable()
class PaymentMethods {
  @JsonKey(name: "text_payment_method")
  String? textPaymentMethod;
  @JsonKey(name: "text_comments")
  String? textComments;
  @JsonKey(name: "text_loading")
  String? textLoading;
  @JsonKey(name: "button_continue")
  String? buttonContinue;
  @JsonKey(name: "error_warning")
  String? errorWarning;
  @JsonKey(name: "payment_methods")
  List<PaymentMethod>? paymentMethodList;
  String? code;
  String? comment;
  List<dynamic>? scripts;
  @JsonKey(name: "text_agree")
  String? textAgree;
  @JsonKey(name: "text_agree_info")
  String? textAgreeInfo;
  String? agree;

  PaymentMethods(
      {this.textPaymentMethod,
      this.textComments,
      this.textLoading,
      this.buttonContinue,
      this.errorWarning,
      this.paymentMethodList,
      this.code,
      this.comment,
      this.scripts,
      this.textAgree,
      this.textAgreeInfo,
      this.agree});

  factory PaymentMethods.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodsFromJson(json);
}

@JsonSerializable()
class PaymentMethod {
  String? code;
  String? title;
  String? terms;
  @JsonKey(name: "sort_order")
  String? sortOrder;

  PaymentMethod({this.code, this.title, this.terms, this.sortOrder});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}
