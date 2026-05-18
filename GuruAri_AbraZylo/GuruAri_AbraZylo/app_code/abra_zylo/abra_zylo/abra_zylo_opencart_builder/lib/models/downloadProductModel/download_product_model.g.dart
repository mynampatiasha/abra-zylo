// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadProductModel _$DownloadProductModelFromJson(
        Map<String, dynamic> json) =>
    DownloadProductModel(
      error: json['error'] as int?,
      downloadData: (json['downloadData'] as List<dynamic>?)
          ?.map((e) => DownloadData.fromJson(e as Map<String, dynamic>))
          .toList(),
      downloadsTotal: json['downloadsTotal'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$DownloadProductModelToJson(
        DownloadProductModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'error': instance.error,
      'downloadData': instance.downloadData,
      'downloadsTotal': instance.downloadsTotal,
    };

DownloadData _$DownloadDataFromJson(Map<String, dynamic> json) => DownloadData(
      orderId: json['order_id'] as String?,
      dateAdded: json['date_added'] as String?,
      name: json['name'] as String?,
      size: json['size'] as String?,
      downloadId: json['download_id'] as String?,
      file: json['file'] as String?,
      extension: json['extension'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$DownloadDataToJson(DownloadData instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'date_added': instance.dateAdded,
      'name': instance.name,
      'size': instance.size,
      'download_id': instance.downloadId,
      'file': instance.file,
      'extension': instance.extension,
      'url': instance.url,
    };
