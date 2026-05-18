import 'package:json_annotation/json_annotation.dart';
part 'razor_pay_model.g.dart';

@JsonSerializable()
class RazorPayModel {
  @JsonKey(name: "key_id")
  String? keyId;
  @JsonKey(name: "secret_key")
  String? secretKey;
  @JsonKey(name: "order_payment_id")
  String? orderPaymentId;
  @JsonKey(name: "error")
  String? error;
  @JsonKey(name: "currency")
  String? currency;
  @JsonKey(name: "total")
  String? total;

  RazorPayModel(
      {this.keyId,
      this.secretKey,
      this.orderPaymentId,
      this.error,
      this.currency,
      this.total});

  factory RazorPayModel.fromJson(Map<String, dynamic> json) =>
      _$RazorPayModelFromJson(json);

  Map<String, dynamic> toJson() => _$RazorPayModelToJson(this);
}
