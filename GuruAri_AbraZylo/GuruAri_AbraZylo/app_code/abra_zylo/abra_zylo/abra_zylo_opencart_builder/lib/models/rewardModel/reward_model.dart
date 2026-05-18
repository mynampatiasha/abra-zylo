import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_model.g.dart';

@JsonSerializable()
class RewardModel extends BaseModel {
  List<RewardData>? rewardData;
  String? rewardsTotal;
  String? rewardText;
  int? totalPoints;

  RewardModel(
      {this.rewardData, this.rewardsTotal, this.rewardText, this.totalPoints});
  factory RewardModel.fromJson(Map<String, dynamic> json) =>
      _$RewardModelFromJson(json);

  Map<String, dynamic> toJson() => _$RewardModelToJson(this);
}

@JsonSerializable()
class RewardData {
  @JsonKey(name: "order_id")
  String? orderId;
  String? points;
  String? description;
  @JsonKey(name: "date_added")
  String? dateAdded;

  RewardData({this.orderId, this.points, this.description, this.dateAdded});
  factory RewardData.fromJson(Map<String, dynamic> json) =>
      _$RewardDataFromJson(json);

  Map<String, dynamic> toJson() => _$RewardDataToJson(this);
}
