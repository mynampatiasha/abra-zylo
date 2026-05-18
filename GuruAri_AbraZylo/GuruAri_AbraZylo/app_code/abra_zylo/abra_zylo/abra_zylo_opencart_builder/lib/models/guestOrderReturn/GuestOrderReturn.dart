import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'GuestOrderReturn.g.dart';

@JsonSerializable()
class GuestOrderReturn extends BaseModel {
  @JsonKey(name: "order_id")
  String? orderId;
  @JsonKey(name: "invoice_no")
  String? invoiceNo;
  @JsonKey(name: "customer_id")
  String? customerId;
  String? firstname;
  String? lastname;
  String? telephone;
  String? email;

  GuestOrderReturn({
    this.orderId,
    this.invoiceNo,
    this.customerId,
    this.firstname,
    this.lastname,
    this.telephone,
    this.email,
  });

  factory GuestOrderReturn.fromJson(Map<String, dynamic> json) =>
      _$GuestOrderReturnFromJson(json);

  Map<String, dynamic> toJson() => _$GuestOrderReturnToJson(this);
}
