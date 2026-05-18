import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/checkout/checkout_address_model.dart';

part 'checkout_payment_address_model.g.dart';

@JsonSerializable()
class CheckoutPaymentAddressModel {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "shipping_required")
  bool? shippingRequired;
  CheckoutAddressModel? paymentAddress;
  String? account;
  String? logged;
  dynamic? cartCount;
  @JsonKey(name: "currency_code")
  String? currencyCode;

  CheckoutPaymentAddressModel(
      {this.headingTitle,
      this.shippingRequired,
      this.paymentAddress,
      this.account,
      this.logged,
      this.cartCount,
      this.currencyCode});

  factory CheckoutPaymentAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPaymentAddressModelFromJson(json);
}

@JsonSerializable()
class LoginData {
  @JsonKey(name: "customer_id")
  String? customerId;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;

  LoginData(
      {this.customerId, this.firstname, this.lastname, this.email, this.phone});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}
