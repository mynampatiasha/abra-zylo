import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  @JsonKey(name: "address_id")
  String? addressId;

  @JsonKey(name: "firstname")
  String? firstname;

  @JsonKey(name: "lastname")
  String? lastname;

  @JsonKey(name: "company")
  String? company;

  @JsonKey(name: "address_1")
  String? address1;

  @JsonKey(name: "address_2")
  String? address2;

  @JsonKey(name: "postcode")
  String? postcode;

  @JsonKey(name: "city")
  String? city;

  @JsonKey(name: "zone_id")
  String? zoneId;

  @JsonKey(name: "zone")
  String? zone;

  @JsonKey(name: "zone_code")
  String? zoneCode;

  @JsonKey(name: "country_id")
  String? countryId;

  @JsonKey(name: "country")
  String? country;

  @JsonKey(name: "iso_code_2")
  String? isoCode2;

  @JsonKey(name: "iso_code_3")
  String? isoCode3;

  @JsonKey(name: "address_format")
  String? addressFormat;

  @JsonKey(name: "custom_field")
  String? customField;

  Data({
    this.addressId,
    this.firstname,
    this.lastname,
    this.company,
    this.address1,
    this.address2,
    this.postcode,
    this.city,
    this.zoneId,
    this.zone,
    this.zoneCode,
    this.countryId,
    this.country,
    this.isoCode2,
    this.isoCode3,
    this.addressFormat,
    this.customField,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
