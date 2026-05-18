import 'package:json_annotation/json_annotation.dart';
import '../cart/country_data_model.dart';
part 'checkout_address_model.g.dart';

@JsonSerializable()
class CheckoutAddressModel {
  @JsonKey(name: "text_address_existing")
  String? textAddressExisting;
  @JsonKey(name: "text_address_new")
  String? textAddressNew;
  @JsonKey(name: "text_select")
  String? textSelect;
  @JsonKey(name: "text_none")
  String? textNone;
  @JsonKey(name: "text_loading")
  String? textLoading;
  @JsonKey(name: "entry_firstname")
  String? entryFirstname;
  @JsonKey(name: "entry_lastname")
  String? entryLastname;
  @JsonKey(name: "entry_company")
  String? entryCompany;
  @JsonKey(name: "entry_address_1")
  String? entryAddress1;
  @JsonKey(name: "entry_address_2")
  String? entryAddress2;
  @JsonKey(name: "entry_postcode")
  String? entryPostcode;
  @JsonKey(name: "entry_city")
  String? entryCity;
  @JsonKey(name: "entry_country")
  String? entryCountry;
  @JsonKey(name: "entry_zone")
  String? entryZone;
  @JsonKey(name: "button_continue")
  String? buttonContinue;
  @JsonKey(name: "button_upload")
  String? buttonUpload;
  @JsonKey(name: "address_id")
  String? addressId;
  List<Addresses>? addresses;
  String? postcode;
  @JsonKey(name: "country_id")
  String? countryId;
  @JsonKey(name: "zone_id")
  String? zoneId;
  //@JsonKey(name: "country_data")
  List<CountryData>? countryData;

  CheckoutAddressModel({
    this.textAddressExisting,
    this.textAddressNew,
    this.textSelect,
    this.textNone,
    this.textLoading,
    this.entryFirstname,
    this.entryLastname,
    this.entryCompany,
    this.entryAddress1,
    this.entryAddress2,
    this.entryPostcode,
    this.entryCity,
    this.entryCountry,
    this.entryZone,
    this.buttonContinue,
    this.buttonUpload,
    this.addressId,
    this.addresses,
    this.postcode,
    this.countryId,
    this.zoneId,
    this.countryData,
    /* this.shippingAddressCustomField,
        this.customFields*/
  });

  factory CheckoutAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutAddressModelFromJson(json);
}

@JsonSerializable()
class Addresses {
  @JsonKey(name: "address_id")
  String? addressId;
  String? formatted;
  Address? address;

  Addresses({this.addressId, this.formatted, this.address});
  factory Addresses.fromJson(Map<String, dynamic> json) =>
      _$AddressesFromJson(json);
}

@JsonSerializable()
class Address {
  @JsonKey(name: "address_id")
  String? addressId;
  String? firstname;
  String? lastname;
  String? company;
  @JsonKey(name: "address_1")
  String? address1;
  @JsonKey(name: "address_2")
  String? address2;
  String? postcode;
  String? city;
  @JsonKey(name: "zone_id")
  String? zoneId;
  String? zone;
  @JsonKey(name: "zone_code")
  String? zoneCode;
  @JsonKey(name: "country_id")
  String? countryId;
  String? country;
  @JsonKey(name: "iso_code_2")
  String? isoCode2;
  @JsonKey(name: "iso_code_3")
  String? isoCode3;
  @JsonKey(name: "address_format")
  String? addressFormat;
  @JsonKey(name: "saved_address")
  String? savedAddress;

  Address(
      {this.addressId,
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
      this.savedAddress});
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
