import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'address_datum.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.Fourty)
class AddressDatum {
  @HiveField(HiveConstant.One)
  @JsonKey(name: "address_id")
  String? addressId;

  @HiveField(HiveConstant.Two)
  @JsonKey(name: "value")
  String? value;

  AddressDatum({this.addressId, this.value});

  factory AddressDatum.fromJson(Map<String, dynamic> json) =>
      _$AddressDatumFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDatumToJson(this);
}
