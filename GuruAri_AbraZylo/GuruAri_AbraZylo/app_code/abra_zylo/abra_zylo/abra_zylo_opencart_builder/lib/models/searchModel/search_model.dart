import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchModel extends BaseModel {
  @JsonKey(name: "search_data")
  List<SearchData>? searchData;

  SearchModel({this.searchData});

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}

@JsonSerializable()
class SearchData {
  @JsonKey(name: "product_id")
  String? productId;
  String? name;

  SearchData({this.productId, this.name});

  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataToJson(this);
}
