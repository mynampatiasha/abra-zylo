import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'reviews_list_model.g.dart';

@JsonSerializable()
class ReviewsListModel {
  int? total;
  int? success;
  String? message;
  @JsonKey(name: "reviews")
  List<ReviewsListData>? reviewsList;

  ReviewsListModel({
    this.total,
    this.reviewsList,
  });

  factory ReviewsListModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewsListModelFromJson(json);
}

@JsonSerializable()
class ReviewsListData {
  @JsonKey(name: "review_id")
  String? reviewId;
  @JsonKey(name: "product_id")
  String? productId;
  @JsonKey(name: "product_name")
  String? productName;
  @JsonKey(name: "text")
  String? text;
  @JsonKey(name: "rating")
  String? rating;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "image")
  String? image;

  ReviewsListData(
      {this.reviewId,
      this.productId,
      this.productName,
      this.text,
      this.rating,
      this.status,
      this.image});

  factory ReviewsListData.fromJson(Map<String, dynamic> json) =>
      _$ReviewsListDataFromJson(json);
}
