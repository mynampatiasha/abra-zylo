// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryDataModel _$CountryDataModelFromJson(Map<String, dynamic> json) =>
    CountryDataModel(
      countryData: (json['country_data'] as List<dynamic>?)
          ?.map((e) => CountryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$CountryDataModelToJson(CountryDataModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'country_data': instance.countryData,
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
      zoneId: json['zone_id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ZoneToJson(Zone instance) => <String, dynamic>{
      'zone_id': instance.zoneId,
      'name': instance.name,
    };
