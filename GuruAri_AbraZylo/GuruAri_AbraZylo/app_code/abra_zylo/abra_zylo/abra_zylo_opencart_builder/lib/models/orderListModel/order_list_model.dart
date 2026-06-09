import 'package:hive/hive.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';
part 'order_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyFive)
class OrderListModel extends BaseModel {
  @HiveField(HiveConstant.Hundred)
  @JsonKey(name: "etag")
  String? eTag = "";

  @HiveField(HiveConstant.One)
  List<OrderListData>? orderData;
  @HiveField(HiveConstant.Two)
  String? orderTotals;
  @HiveField(HiveConstant.Three)
  dynamic error;

  OrderListModel({this.orderData, this.orderTotals, this.error});
  factory OrderListModel.fromJson(Map<String, dynamic> json) =>
      _$OrderListModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtySix)
class OrderListData {
  @HiveField(HiveConstant.One)
  String? orderId;
  @HiveField(HiveConstant.Two)
  String? name;
  @HiveField(HiveConstant.Three)
  String? status;
  @HiveField(HiveConstant.Four)
  String? dateAdded;
  @HiveField(HiveConstant.Five)
  int? products;
  @HiveField(HiveConstant.Six)
  String? total;
  @HiveField(HiveConstant.Seven)
  @JsonKey(name: "image")
  String? image;

  OrderListData(
      {this.orderId,
      this.name,
      this.status,
      this.dateAdded,
      this.products,
      this.total,
      this.image});
  factory OrderListData.fromJson(Map<String, dynamic> json) =>
      _$OrderListDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListDataToJson(this);
}
