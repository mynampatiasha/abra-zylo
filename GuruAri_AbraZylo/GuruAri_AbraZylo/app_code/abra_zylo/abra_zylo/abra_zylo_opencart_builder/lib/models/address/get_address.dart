import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/address/address_datum.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../hive/hive_constant.dart';

part 'get_address.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyNine)
class GetAddress extends BaseModel {
  @HiveField(HiveConstant.Hundred)
  @JsonKey(name: "etag")
  String? eTag = "";

  @HiveField(HiveConstant.One)
  @JsonKey(name: "addressData")
  List<AddressDatum>? addressData;

  @HiveField(HiveConstant.Two)
  @JsonKey(name: "default")
  String? defaultAddress;

  GetAddress({this.eTag, this.addressData, this.defaultAddress});

  factory GetAddress.fromJson(Map<String, dynamic> json) =>
      _$GetAddressFromJson(json);

  Map<String, dynamic> toJson() => _$GetAddressToJson(this);
}
