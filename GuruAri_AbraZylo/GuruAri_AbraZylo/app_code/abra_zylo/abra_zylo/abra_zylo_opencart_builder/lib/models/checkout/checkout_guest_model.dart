import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/checkout/checkout_address_model.dart';

part 'checkout_guest_model.g.dart';

@JsonSerializable()
class CheckoutGuestModel {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "shipping_required")
  bool? shippingRequired;
  @JsonKey(name: "guest")
  CheckoutAddressModel?
      guestData; //currently using only for address if any thing required in future then have to change guest model acc to respose.
  String? account;
  String? logged;
  dynamic? cartCount;
  @JsonKey(name: "currency_code")
  String? currencyCode;

  CheckoutGuestModel(
      {this.headingTitle,
      this.shippingRequired,
      this.guestData,
      this.account,
      this.logged,
      this.cartCount,
      this.currencyCode});

  factory CheckoutGuestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutGuestModelFromJson(json);
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
