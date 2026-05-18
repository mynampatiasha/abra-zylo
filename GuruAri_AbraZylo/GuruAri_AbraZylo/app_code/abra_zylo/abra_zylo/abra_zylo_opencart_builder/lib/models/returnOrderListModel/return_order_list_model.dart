import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../hive/hive_constant.dart';
part 'return_order_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtySeven)
class ReturnOrderListModel extends BaseModel {
  @HiveField(HiveConstant.Hundred)
  @JsonKey(name: "etag")
  String? eTag = "";
  @HiveField(HiveConstant.One)
  List<ReturnListData>? returnData;

  @HiveField(HiveConstant.Two)
  String? returnTotals;

  ReturnOrderListModel({this.returnData, this.returnTotals});

  factory ReturnOrderListModel.fromJson(Map<String, dynamic> json) =>
      _$ReturnOrderListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnOrderListModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyEight)
class ReturnListData {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "return_id")
  String? returnId;
  @HiveField(HiveConstant.Two)
  @JsonKey(name: "order_id")
  String? orderId;
  @HiveField(HiveConstant.Three)
  String? name;
  @HiveField(HiveConstant.Four)
  String? status;
  @HiveField(HiveConstant.Five)
  @JsonKey(name: "date_added")
  String? dateAdded;

  ReturnListData(
      {this.returnId, this.orderId, this.name, this.status, this.dateAdded});

  factory ReturnListData.fromJson(Map<String, dynamic> json) =>
      _$ReturnListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnListDataToJson(this);
}
