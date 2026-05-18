// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardModel _$RewardModelFromJson(Map<String, dynamic> json) => RewardModel(
      rewardData: (json['rewardData'] as List<dynamic>?)
          ?.map((e) => RewardData.fromJson(e as Map<String, dynamic>))
          .toList(),
      rewardsTotal: json['rewardsTotal'] as String?,
      rewardText: json['rewardText'] as String?,
      totalPoints: json['totalPoints'] as int?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$RewardModelToJson(RewardModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'rewardData': instance.rewardData,
      'rewardsTotal': instance.rewardsTotal,
      'rewardText': instance.rewardText,
      'totalPoints': instance.totalPoints,
    };

RewardData _$RewardDataFromJson(Map<String, dynamic> json) => RewardData(
      orderId: json['order_id'] as String?,
      points: json['points'] as String?,
      description: json['description'] as String?,
      dateAdded: json['date_added'] as String?,
    );

Map<String, dynamic> _$RewardDataToJson(RewardData instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'points': instance.points,
      'description': instance.description,
      'date_added': instance.dateAdded,
    };
