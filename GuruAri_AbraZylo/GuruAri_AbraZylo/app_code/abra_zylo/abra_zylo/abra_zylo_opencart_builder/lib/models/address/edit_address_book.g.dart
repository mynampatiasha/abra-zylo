// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_address_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditAddressBook _$EditAddressBookFromJson(Map<String, dynamic> json) =>
    EditAddressBook(
      gdprStatus: json['gdpr_status'] as int? ?? 101,
      gdprContent: json['gdpr_content'] as String?,
      gdprRequestStatus: json['gdpr_request_status'] as int? ?? 101,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      countryId: json['store_country_id'] as String?,
      defaultValue: json['default'] as int?,
      countryData: (json['countryData'] as List<dynamic>?)
          ?.map((e) => CountryDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$EditAddressBookToJson(EditAddressBook instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'gdpr_status': instance.gdprStatus,
      'gdpr_content': instance.gdprContent,
      'gdpr_request_status': instance.gdprRequestStatus,
      'data': instance.data,
      'store_country_id': instance.countryId,
      'default': instance.defaultValue,
      'countryData': instance.countryData,
    };
