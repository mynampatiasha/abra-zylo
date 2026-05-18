import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'country_data_model.g.dart';

@JsonSerializable()
class CountryDataModel extends BaseModel {
  @JsonKey(name: "country_data")
  List<CountryData>? countryData;

  CountryDataModel({
    this.countryData,
  });

  factory CountryDataModel.fromJson(Map<String, dynamic> json) =>
      _$CountryDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataModelToJson(this);
}

@JsonSerializable()
class CountryData {
  @JsonKey(name: "country_id")
  String? countryId;
  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "zone")
  List<Zone>? zone;
  CountryData({
    this.countryId,
    this.name,
    this.zone,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) =>
      _$CountryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataToJson(this);

  Zone? getZoneById(String? zoneId) {
    for (var cur in (zone ?? <Zone>[])) {
      if (cur.zoneId == zoneId) {
        return cur;
      }
    }
    return zone?.isNotEmpty == false ? zone?.elementAt(0) : null;
  }

  Zone? getZoneByName(String? name) {
    for (var cur in (zone ?? <Zone>[])) {
      if (cur.name?.toLowerCase() == name?.toLowerCase()) {
        return cur;
      }
    }
    return zone?.isNotEmpty == false ? zone?.elementAt(0) : null;
  }
}

@JsonSerializable()
class Zone {
  @JsonKey(name: "zone_id")
  String? zoneId;
  @JsonKey(name: "name")
  String? name;
  Zone({this.zoneId, this.name});
  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);

  Map<String, dynamic> toJson() => _$ZoneToJson(this);
}
