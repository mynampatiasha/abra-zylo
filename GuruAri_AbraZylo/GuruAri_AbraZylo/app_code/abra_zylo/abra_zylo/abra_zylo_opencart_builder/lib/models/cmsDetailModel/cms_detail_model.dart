import 'package:json_annotation/json_annotation.dart';

part 'cms_detail_model.g.dart';

@JsonSerializable()
class CmsDetailModel {
  int? error;
  @JsonKey(name: "information_id")
  String? informationId;
  String? title;
  String? description;

  CmsDetailModel(
      {this.error, this.informationId, this.title, this.description});

  factory CmsDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CmsDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$CmsDetailModelToJson(this);
}
