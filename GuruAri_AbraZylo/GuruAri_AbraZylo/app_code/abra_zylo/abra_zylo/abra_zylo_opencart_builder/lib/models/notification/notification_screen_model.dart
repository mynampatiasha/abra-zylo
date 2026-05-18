import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'notification_screen_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.FourtyOne)
class NotificationScreenModel {
  @HiveField(HiveConstant.Hundred)
  @JsonKey(name: "etag")
  String? eTag = "";

  @HiveField(HiveConstant.One)
  List<Notifications>? notifications;

  @HiveField(HiveConstant.Two)
  int? error;

  NotificationScreenModel({this.notifications, this.error});
  factory NotificationScreenModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationScreenModelFromJson(json);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.FourtyTwo)
class Notifications {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "notification_id")
  String? notificationId;
  @HiveField(HiveConstant.Two)
  String? title;
  @HiveField(HiveConstant.Three)
  String? image;
  @HiveField(HiveConstant.Four)
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  @HiveField(HiveConstant.Five)
  String? type;
  @HiveField(HiveConstant.Six)
  String? id;
  @HiveField(HiveConstant.Seven)
  String? content;
  @HiveField(HiveConstant.Eight)
  String? subTitle;

  Notifications(
      {this.notificationId,
      this.title,
      this.image,
      this.dominantColor,
      this.type,
      this.id,
      this.content,
      this.subTitle});
  factory Notifications.fromJson(Map<String, dynamic> json) =>
      _$NotificationsFromJson(json);
}
