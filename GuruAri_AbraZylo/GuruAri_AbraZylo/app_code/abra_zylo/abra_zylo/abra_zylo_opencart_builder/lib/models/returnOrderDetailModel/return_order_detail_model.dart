import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'return_order_detail_model.g.dart';

@JsonSerializable()
class ReturnOrderDetailModel extends BaseModel {
  @JsonKey(name: "return_id")
  String? returnId;
  @JsonKey(name: "order_id")
  String? orderId;
  @JsonKey(name: "date_ordered")
  String? dateOrdered;
  @JsonKey(name: "date_added")
  String? dateAdded;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? product;
  String? model;
  String? quantity;
  String? reason;
  String? opened;
  String? comment;
  dynamic? action;
  @JsonKey(name: "histories")
  List<Histories>? histories;

  ReturnOrderDetailModel(
      {this.returnId,
      this.orderId,
      this.dateOrdered,
      this.dateAdded,
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.product,
      this.model,
      this.quantity,
      this.reason,
      this.opened,
      this.comment,
      this.action,
      this.histories});

  factory ReturnOrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ReturnOrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnOrderDetailModelToJson(this);
}

@JsonSerializable()
class Histories {
  String? status;
  String? comment;
  @JsonKey(name: "date_added")
  String? dateAdded;

  Histories({this.status, this.comment, this.dateAdded});

  factory Histories.fromJson(Map<String, dynamic> json) =>
      _$HistoriesFromJson(json);
}
