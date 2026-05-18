import 'package:json_annotation/json_annotation.dart';

part 'catalog_product_request.g.dart';

@JsonSerializable()
class CatalogProductRequest {
  String? page;
  String? limit;
  String? width;
  String? path;
  String? id;
  String? sort;
  String? order;
  String? filter;
  @JsonKey(name: "wk_token")
  String? token;
  @JsonKey(name: "manufacture_id")
  String? manufactureId;

  CatalogProductRequest({
    this.page,
    this.limit,
    this.width,
    this.path,
    this.id,
    this.sort,
    this.order,
    this.filter,
    this.token,
    this.manufactureId,
  });

  factory CatalogProductRequest.fromJson(Map<String, dynamic> json) =>
      _$CatalogProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogProductRequestToJson(this);
}
