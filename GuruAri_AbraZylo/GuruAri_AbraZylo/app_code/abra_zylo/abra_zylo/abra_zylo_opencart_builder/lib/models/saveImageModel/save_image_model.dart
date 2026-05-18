import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'save_image_model.g.dart';

@JsonSerializable()
class SaveImageModel {
  String? message;
  int? error;
  int? success;

  SaveImageModel({
    this.message,
    this.error,
    this.success,
  });

  factory SaveImageModel.fromJson(Map<String, dynamic> json) =>
      _$SaveImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveImageModelToJson(this);
}
