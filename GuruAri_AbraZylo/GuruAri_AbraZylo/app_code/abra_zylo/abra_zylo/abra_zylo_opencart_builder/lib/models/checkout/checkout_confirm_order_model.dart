import 'package:json_annotation/json_annotation.dart';

part 'checkout_confirm_order_model.g.dart';

@JsonSerializable()
class CheckoutConfirmOrderModel {
  @JsonKey(name: "order_id", defaultValue: 0)
  int? orderId;
  Success? success;
  int? error;

  CheckoutConfirmOrderModel({this.success, this.error, this.orderId});

  factory CheckoutConfirmOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutConfirmOrderModelFromJson(json);
}

@JsonSerializable()
class Success {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "text_message")
  String? textMessage;
  @JsonKey(name: "button_continue")
  String? buttonContinue;

  Success({this.headingTitle, this.textMessage, this.buttonContinue});

  factory Success.fromJson(Map<String, dynamic> json) =>
      _$SuccessFromJson(json);
}
