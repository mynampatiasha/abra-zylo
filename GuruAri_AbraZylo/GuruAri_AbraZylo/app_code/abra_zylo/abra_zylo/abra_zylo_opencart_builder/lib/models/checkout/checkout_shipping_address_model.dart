import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/checkout/checkout_address_model.dart';

part 'checkout_shipping_address_model.g.dart';

@JsonSerializable()
class CheckoutShippingAddressModel {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "shipping_required")
  bool? shippingRequired;
  CheckoutAddressModel? shippingAddress;
  String? account;
  String? logged;
  dynamic cartCount;
  @JsonKey(name: "currency_code")
  String? currencyCode;

  CheckoutShippingAddressModel(
      {this.headingTitle,
      this.shippingRequired,
      this.shippingAddress,
      this.account,
      this.logged,
      this.cartCount,
      this.currencyCode});

  factory CheckoutShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutShippingAddressModelFromJson(json);
}
