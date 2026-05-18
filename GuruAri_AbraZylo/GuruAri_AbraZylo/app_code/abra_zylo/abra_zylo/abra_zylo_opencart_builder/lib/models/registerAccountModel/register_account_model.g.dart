// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterAccountModel _$RegisterAccountModelFromJson(
        Map<String, dynamic> json) =>
    RegisterAccountModel(
      textBecomepartner: json['text_becomepartner'] as String?,
      textShop: json['text_shop'] as String?,
      becomeSeller: json['become_seller'] as bool?,
      agreeInfo: json['agreeInfo'] == null
          ? null
          : AgreeInfo.fromJson(json['agreeInfo'] as Map<String, dynamic>),
      customerGroup: (json['customer_group'] as List<dynamic>?)
          ?.map((e) => CustomerGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      customField: json['customField'] as List<dynamic>?,
      countryData: (json['countryData'] as List<dynamic>?)
          ?.map((e) => CountryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      storeCountryId: json['store_country_id'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$RegisterAccountModelToJson(
        RegisterAccountModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'text_becomepartner': instance.textBecomepartner,
      'text_shop': instance.textShop,
      'become_seller': instance.becomeSeller,
      'agreeInfo': instance.agreeInfo,
      'customer_group': instance.customerGroup,
      'customField': instance.customField,
      'countryData': instance.countryData,
      'store_country_id': instance.storeCountryId,
    };

AgreeInfo _$AgreeInfoFromJson(Map<String, dynamic> json) => AgreeInfo(
      text: json['text'] as String?,
      data: json['data'] == null
          ? null
          : TermsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgreeInfoToJson(AgreeInfo instance) => <String, dynamic>{
      'text': instance.text,
      'data': instance.data,
    };

TermsData _$TermsDataFromJson(Map<String, dynamic> json) => TermsData(
      informationId: json['information_id'] as String?,
      bottom: json['bottom'] as String?,
      sortOrder: json['sort_order'] as String?,
      status: json['status'] as String?,
      languageId: json['language_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      metaTitle: json['meta_title'] as String?,
      metaDescription: json['meta_description'] as String?,
      metaKeyword: json['meta_keyword'] as String?,
      storeId: json['store_id'] as String?,
    );

Map<String, dynamic> _$TermsDataToJson(TermsData instance) => <String, dynamic>{
      'information_id': instance.informationId,
      'bottom': instance.bottom,
      'sort_order': instance.sortOrder,
      'status': instance.status,
      'language_id': instance.languageId,
      'title': instance.title,
      'description': instance.description,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
      'meta_keyword': instance.metaKeyword,
      'store_id': instance.storeId,
    };

CustomerGroup _$CustomerGroupFromJson(Map<String, dynamic> json) =>
    CustomerGroup(
      customerGroupId: json['customer_group_id'] as String?,
      approval: json['approval'] as String?,
      sortOrder: json['sort_order'] as String?,
      languageId: json['language_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CustomerGroupToJson(CustomerGroup instance) =>
    <String, dynamic>{
      'customer_group_id': instance.customerGroupId,
      'approval': instance.approval,
      'sort_order': instance.sortOrder,
      'language_id': instance.languageId,
      'name': instance.name,
      'description': instance.description,
    };

CountryData _$CountryDataFromJson(Map<String, dynamic> json) => CountryData(
      countryId: json['country_id'] as String?,
      name: json['name'] as String?,
      zone: (json['zone'] as List<dynamic>?)
          ?.map((e) => Zone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountryDataToJson(CountryData instance) =>
    <String, dynamic>{
      'country_id': instance.countryId,
      'name': instance.name,
      'zone': instance.zone,
    };

Zone _$ZoneFromJson(Map<String, dynamic> json) => Zone(
      zoneId: json['zoneId'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ZoneToJson(Zone instance) => <String, dynamic>{
      'zoneId': instance.zoneId,
      'name': instance.name,
    };
