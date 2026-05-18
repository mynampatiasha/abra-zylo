// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      addressId: json['address_id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      company: json['company'] as String?,
      address1: json['address_1'] as String?,
      address2: json['address_2'] as String?,
      postcode: json['postcode'] as String?,
      city: json['city'] as String?,
      zoneId: json['zone_id'] as String?,
      zone: json['zone'] as String?,
      zoneCode: json['zone_code'] as String?,
      countryId: json['country_id'] as String?,
      country: json['country'] as String?,
      isoCode2: json['iso_code_2'] as String?,
      isoCode3: json['iso_code_3'] as String?,
      addressFormat: json['address_format'] as String?,
      customField: json['custom_field'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'address_id': instance.addressId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'company': instance.company,
      'address_1': instance.address1,
      'address_2': instance.address2,
      'postcode': instance.postcode,
      'city': instance.city,
      'zone_id': instance.zoneId,
      'zone': instance.zone,
      'zone_code': instance.zoneCode,
      'country_id': instance.countryId,
      'country': instance.country,
      'iso_code_2': instance.isoCode2,
      'iso_code_3': instance.isoCode3,
      'address_format': instance.addressFormat,
      'custom_field': instance.customField,
    };
