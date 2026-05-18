import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../hive/hive_constant.dart';

part 'base_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyFour)
class BaseModel {
  @HiveField(201)
  int? fault;

  @HiveField(202)
  String? message;

  @HiveField(203)
  int? error;

  @HiveField(204)
  String? redirect;

  @HiveField(205)
  dynamic newsletter;

  @HiveField(206)
  @JsonKey(name: "total")
  dynamic? cartTotal = "";

  /* @HiveField( 207)
  @JsonKey(name:"e_tag")
  String? reserveTag = "";*/

  BaseModel({
    this.fault,
    this.message,
    this.error,
    this.redirect,
    this.newsletter,
    this.cartTotal,
    /* this.reserveTag*/
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}
