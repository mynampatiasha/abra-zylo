import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_info_model.g.dart';

@JsonSerializable()
class AccountInfoModel extends BaseModel {
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? fax;
  int? status;
  List<dynamic>? customField;

  AccountInfoModel(
      {this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.fax,
      this.status,
      this.customField});

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoModelToJson(this);
}
