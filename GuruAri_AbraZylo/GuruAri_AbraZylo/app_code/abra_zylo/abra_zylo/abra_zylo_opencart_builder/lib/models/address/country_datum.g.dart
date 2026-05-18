// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryDatum _$CountryDatumFromJson(Map<String, dynamic> json) => CountryDatum(
      countryId: json['country_id'] as String?,
      name: json['name'] as String?,
      zone: (json['zone'] as List<dynamic>?)
          ?.map((e) => Zone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountryDatumToJson(CountryDatum instance) =>
    <String, dynamic>{
      'country_id': instance.countryId,
      'name': instance.name,
      'zone': instance.zone,
    };
