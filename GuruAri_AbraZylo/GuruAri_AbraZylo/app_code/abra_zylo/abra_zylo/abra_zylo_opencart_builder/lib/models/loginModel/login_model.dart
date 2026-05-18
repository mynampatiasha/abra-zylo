import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';

@JsonSerializable()
class LoginModel extends BaseModel {
  LoginModel({
    this.customerId,
    this.partner,
    this.partnerApproveRequired,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.storeId,
    this.status,
    this.image,
  });
  @JsonKey(name: "customer_id")
  dynamic? customerId;
  int? partner;
  bool? partnerApproveRequired;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? storeId;
  String? status;
  String? image;

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
