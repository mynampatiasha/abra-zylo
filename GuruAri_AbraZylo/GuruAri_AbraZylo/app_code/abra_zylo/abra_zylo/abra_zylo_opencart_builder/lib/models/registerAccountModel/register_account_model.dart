import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'register_account_model.g.dart';

@JsonSerializable()
class RegisterAccountModel extends BaseModel {
  @JsonKey(name: "text_becomepartner")
  String? textBecomepartner;
  @JsonKey(name: "text_shop")
  String? textShop;
  @JsonKey(name: "become_seller")
  bool? becomeSeller;
  @JsonKey(name: "agreeInfo")
  AgreeInfo? agreeInfo;
  @JsonKey(name: "customer_group")
  List<CustomerGroup>? customerGroup;
  @JsonKey(name: "customField")
  List<dynamic>? customField;
  @JsonKey(name: "countryData")
  List<CountryData>? countryData;
  @JsonKey(name: "store_country_id")
  String? storeCountryId;

  RegisterAccountModel(
      {this.textBecomepartner,
      this.textShop,
      this.becomeSeller,
      this.agreeInfo,
      this.customerGroup,
      this.customField,
      this.countryData,
      this.storeCountryId});

  factory RegisterAccountModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountModelToJson(this);

  @override
  String toString() {
    return 'RegisterAccountModel{textBecomepartner: $textBecomepartner, textShop: $textShop, becomeSeller: $becomeSeller, agreeInfo: $agreeInfo, customerGroup: $customerGroup, customField: $customField, countryData: $countryData, storeCountryId: $storeCountryId}';
  }
}

@JsonSerializable()
class AgreeInfo {
  String? text;
  TermsData? data;

  AgreeInfo({this.text, this.data});
  factory AgreeInfo.fromJson(Map<String, dynamic> json) =>
      _$AgreeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AgreeInfoToJson(this);

  @override
  String toString() {
    return 'AgreeInfo{text: $text, data: $data}';
  }
}

@JsonSerializable()
class TermsData {
  @JsonKey(name: "information_id")
  String? informationId;
  String? bottom;
  @JsonKey(name: "sort_order")
  String? sortOrder;
  String? status;
  @JsonKey(name: "language_id")
  String? languageId;
  String? title;
  String? description;
  @JsonKey(name: "meta_title")
  String? metaTitle;
  @JsonKey(name: "meta_description")
  String? metaDescription;
  @JsonKey(name: "meta_keyword")
  String? metaKeyword;
  @JsonKey(name: "store_id")
  String? storeId;

  TermsData(
      {this.informationId,
      this.bottom,
      this.sortOrder,
      this.status,
      this.languageId,
      this.title,
      this.description,
      this.metaTitle,
      this.metaDescription,
      this.metaKeyword,
      this.storeId});

  factory TermsData.fromJson(Map<String, dynamic> json) =>
      _$TermsDataFromJson(json);

  Map<String, dynamic> toJson() => _$TermsDataToJson(this);

  @override
  String toString() {
    return 'TermsData{informationId: $informationId, bottom: $bottom, sortOrder: $sortOrder, status: $status, languageId: $languageId, title: $title, description: $description, metaTitle: $metaTitle, metaDescription: $metaDescription, metaKeyword: $metaKeyword, storeId: $storeId}';
  }
}

@JsonSerializable()
class CustomerGroup {
  @JsonKey(name: "customer_group_id")
  String? customerGroupId;
  String? approval;
  @JsonKey(name: "sort_order")
  String? sortOrder;
  @JsonKey(name: "language_id")
  String? languageId;
  String? name;
  String? description;

  CustomerGroup(
      {this.customerGroupId,
      this.approval,
      this.sortOrder,
      this.languageId,
      this.name,
      this.description});

  factory CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerGroupToJson(this);
}

@JsonSerializable()
class CountryData {
  @JsonKey(name: "country_id")
  String? countryId;
  String? name;
  List<Zone>? zone;

  CountryData({this.countryId, this.name, this.zone});

  factory CountryData.fromJson(Map<String, dynamic> json) =>
      _$CountryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataToJson(this);
}

@JsonSerializable()
class Zone {
  String? zoneId;
  String? name;

  Zone({this.zoneId, this.name});

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);

  Map<String, dynamic> toJson() => _$ZoneToJson(this);
}
