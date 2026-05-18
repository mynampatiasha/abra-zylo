/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';

part 'walk_through_model.g.dart';

@JsonSerializable()
class WalkThroughModel extends BaseModel {
  @JsonKey(name: "walkthroughVersion")
  double? walkthroughVersion;

  @JsonKey(name: "walkthrough_list")
  List<WalkthroughData>? walkthroughData;

  WalkThroughModel({this.walkthroughVersion, this.walkthroughData});

  factory WalkThroughModel.fromJson(Map<String, dynamic> json) =>
      _$WalkThroughModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalkThroughModelToJson(this);
}

@JsonSerializable()
class WalkthroughData {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "image")
  String? name;

  @JsonKey(name: "title")
  String? productId;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "sort_order")
  String? sort_order;

  @JsonKey(name: "description")
  String? content;

  WalkthroughData(this.id, this.name, this.productId, this.status,
      this.sort_order, this.content);

  factory WalkthroughData.fromJson(Map<String, dynamic> json) =>
      _$WalkthroughDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalkthroughDataToJson(this);
}
