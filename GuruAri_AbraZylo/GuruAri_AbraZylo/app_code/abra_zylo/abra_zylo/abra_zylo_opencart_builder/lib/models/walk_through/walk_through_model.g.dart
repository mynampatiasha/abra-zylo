// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_through_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkThroughModel _$WalkThroughModelFromJson(Map<String, dynamic> json) =>
    WalkThroughModel(
      walkthroughVersion: (json['walkthroughVersion'] as num?)?.toDouble(),
      walkthroughData: (json['walkthrough_list'] as List<dynamic>?)
          ?.map((e) => WalkthroughData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$WalkThroughModelToJson(WalkThroughModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'walkthroughVersion': instance.walkthroughVersion,
      'walkthrough_list': instance.walkthroughData,
    };

WalkthroughData _$WalkthroughDataFromJson(Map<String, dynamic> json) =>
    WalkthroughData(
      json['id'] as String?,
      json['image'] as String?,
      json['title'] as String?,
      json['status'] as String?,
      json['sort_order'] as String?,
      json['description'] as String?,
    );

Map<String, dynamic> _$WalkthroughDataToJson(WalkthroughData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.name,
      'title': instance.productId,
      'status': instance.status,
      'sort_order': instance.sort_order,
      'description': instance.content,
    };
