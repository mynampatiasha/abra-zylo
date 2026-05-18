// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutAddressModel _$CheckoutAddressModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutAddressModel(
      textAddressExisting: json['text_address_existing'] as String?,
      textAddressNew: json['text_address_new'] as String?,
      textSelect: json['text_select'] as String?,
      textNone: json['text_none'] as String?,
      textLoading: json['text_loading'] as String?,
      entryFirstname: json['entry_firstname'] as String?,
      entryLastname: json['entry_lastname'] as String?,
      entryCompany: json['entry_company'] as String?,
      entryAddress1: json['entry_address_1'] as String?,
      entryAddress2: json['entry_address_2'] as String?,
      entryPostcode: json['entry_postcode'] as String?,
      entryCity: json['entry_city'] as String?,
      entryCountry: json['entry_country'] as String?,
      entryZone: json['entry_zone'] as String?,
      buttonContinue: json['button_continue'] as String?,
      buttonUpload: json['button_upload'] as String?,
      addressId: json['address_id'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Addresses.fromJson(e as Map<String, dynamic>))
          .toList(),
      postcode: json['postcode'] as String?,
      countryId: json['country_id'] as String?,
      zoneId: json['zone_id'] as String?,
      countryData: (json['countryData'] as List<dynamic>?)
          ?.map((e) => CountryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckoutAddressModelToJson(
        CheckoutAddressModel instance) =>
    <String, dynamic>{
      'text_address_existing': instance.textAddressExisting,
      'text_address_new': instance.textAddressNew,
      'text_select': instance.textSelect,
      'text_none': instance.textNone,
      'text_loading': instance.textLoading,
      'entry_firstname': instance.entryFirstname,
      'entry_lastname': instance.entryLastname,
      'entry_company': instance.entryCompany,
      'entry_address_1': instance.entryAddress1,
      'entry_address_2': instance.entryAddress2,
      'entry_postcode': instance.entryPostcode,
      'entry_city': instance.entryCity,
      'entry_country': instance.entryCountry,
      'entry_zone': instance.entryZone,
      'button_continue': instance.buttonContinue,
      'button_upload': instance.buttonUpload,
      'address_id': instance.addressId,
      'addresses': instance.addresses,
      'postcode': instance.postcode,
      'country_id': instance.countryId,
      'zone_id': instance.zoneId,
      'countryData': instance.countryData,
    };

Addresses _$AddressesFromJson(Map<String, dynamic> json) => Addresses(
      addressId: json['address_id'] as String?,
      formatted: json['formatted'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddressesToJson(Addresses instance) => <String, dynamic>{
      'address_id': instance.addressId,
      'formatted': instance.formatted,
      'address': instance.address,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
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
      savedAddress: json['saved_address'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
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
      'saved_address': instance.savedAddress,
    };
