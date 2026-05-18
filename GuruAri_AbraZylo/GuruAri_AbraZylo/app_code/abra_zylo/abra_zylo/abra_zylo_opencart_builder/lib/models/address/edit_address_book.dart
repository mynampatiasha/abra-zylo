import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/address/country_datum.dart';
import 'package:oc_demo/models/address/data.dart';
import 'package:oc_demo/models/base_model.dart';

part 'edit_address_book.g.dart';

@JsonSerializable()
class EditAddressBook extends BaseModel {
  @JsonKey(name: "gdpr_status", defaultValue: 101)
  int? gdprStatus;

  @JsonKey(name: "gdpr_content")
  String? gdprContent;

  @JsonKey(name: "gdpr_request_status", defaultValue: 101)
  int? gdprRequestStatus;

  @JsonKey(name: "data")
  Data? data;

  @JsonKey(name: "store_country_id")
  String? countryId;

  @JsonKey(name: "default")
  int? defaultValue;

  @JsonKey(name: "countryData")
  List<CountryDatum>? countryData;

  EditAddressBook({
    this.gdprStatus,
    this.gdprContent,
    this.gdprRequestStatus,
    this.data,
    this.countryId,
    this.defaultValue,
    this.countryData,
  });

  CountryDatum? getCountryById(String? id) {
    for (var country in (countryData ?? <CountryDatum?>[])) {
      if (country?.countryId == id) {
        return country;
      }
    }
    return countryData?.isNotEmpty == true ? countryData?.elementAt(0) : null;
  }

  CountryDatum? getCountryByName(String? countryName) {
    for (var country in (countryData ?? <CountryDatum?>[])) {
      if (country?.name?.toLowerCase() == countryName?.toLowerCase()) {
        return country;
      }
    }
    return countryData?.isNotEmpty == true ? countryData?.elementAt(0) : null;
  }

  factory EditAddressBook.fromJson(Map<String, dynamic> json) =>
      _$EditAddressBookFromJson(json);

  Map<String, dynamic> toJson() => _$EditAddressBookToJson(this);
}
