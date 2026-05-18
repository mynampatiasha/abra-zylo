// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveImageModel _$SaveImageModelFromJson(Map<String, dynamic> json) =>
    SaveImageModel(
      message: json['message'] as String?,
      error: json['error'] as int?,
      success: json['success'] as int?,
    );

Map<String, dynamic> _$SaveImageModelToJson(SaveImageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'error': instance.error,
      'success': instance.success,
    };
