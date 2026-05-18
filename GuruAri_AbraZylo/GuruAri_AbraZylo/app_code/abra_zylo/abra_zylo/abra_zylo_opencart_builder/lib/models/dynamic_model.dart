import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'dynamic_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 12)
class DynamicModel {
  @HiveField(0)
  dynamic response;

  DynamicModel({this.response});

  factory DynamicModel.fromJson(Map<String, dynamic> json) =>
      _$DynamicModelFromJson(json);
}
