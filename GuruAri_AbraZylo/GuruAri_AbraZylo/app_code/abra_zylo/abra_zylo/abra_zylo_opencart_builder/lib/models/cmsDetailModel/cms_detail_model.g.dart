// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cms_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CmsDetailModel _$CmsDetailModelFromJson(Map<String, dynamic> json) =>
    CmsDetailModel(
      error: json['error'] as int?,
      informationId: json['information_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CmsDetailModelToJson(CmsDetailModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'information_id': instance.informationId,
      'title': instance.title,
      'description': instance.description,
    };
