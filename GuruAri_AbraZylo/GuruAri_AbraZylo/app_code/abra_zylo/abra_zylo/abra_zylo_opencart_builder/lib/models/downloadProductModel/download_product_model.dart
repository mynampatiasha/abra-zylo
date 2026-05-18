import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'download_product_model.g.dart';

@JsonSerializable()
class DownloadProductModel extends BaseModel {
  int? error;
  List<DownloadData>? downloadData;
  String? downloadsTotal;

  DownloadProductModel({this.error, this.downloadData, this.downloadsTotal});

  factory DownloadProductModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadProductModelToJson(this);
}

@JsonSerializable()
class DownloadData {
  @JsonKey(name: "order_id")
  String? orderId;
  @JsonKey(name: "date_added")
  String? dateAdded;
  String? name;
  String? size;
  @JsonKey(name: "download_id")
  String? downloadId;
  String? file;
  String? extension;
  String? url;

  DownloadData(
      {this.orderId,
      this.dateAdded,
      this.name,
      this.size,
      this.downloadId,
      this.file,
      this.extension,
      this.url});

  factory DownloadData.fromJson(Map<String, dynamic> json) =>
      _$DownloadDataFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadDataToJson(this);
}
