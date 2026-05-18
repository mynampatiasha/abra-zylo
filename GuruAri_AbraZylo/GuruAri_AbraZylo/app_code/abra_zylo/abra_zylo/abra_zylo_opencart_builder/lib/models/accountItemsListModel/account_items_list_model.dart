import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../hive/hive_constant.dart';

part 'account_items_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyFour)
class AccountItemsListModel {
  int? fault;
  String? message;
  int? error;
  @JsonKey(name: "my_account")
  String? myAccount;
  String? edit;
  String? password;
  String? address;
  String? wishlist;
  String? order;
  @JsonKey(name: "product_review")
  String? productReview;
  String? download;
  String? reward;
  @JsonKey(name: "return")
  String? itemReturn;
  String? transaction;
  String? newsletter;
  String? recurring;
  @JsonKey(name: "banner")
  BannerModel? banner;

  AccountItemsListModel({
    this.myAccount,
    this.edit,
    this.password,
    this.address,
    this.wishlist,
    this.order,
    this.productReview,
    this.download,
    this.reward,
    this.itemReturn,
    this.transaction,
    this.newsletter,
    this.recurring,
    this.banner,
  });

  factory AccountItemsListModel.fromJson(Map<String, dynamic> json) =>
      _$AccountItemsListModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountItemsListModelToJson(this);
}

@JsonSerializable()
class BannerModel {
  String? firstname;
  String? lastname;
  String? email;
  String? image;
  String? banner;

  BannerModel({
    this.firstname,
    this.lastname,
    this.email,
    this.image,
    this.banner,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
