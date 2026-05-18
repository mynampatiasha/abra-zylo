// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnOrderDetailModel _$ReturnOrderDetailModelFromJson(
        Map<String, dynamic> json) =>
    ReturnOrderDetailModel(
      returnId: json['return_id'] as String?,
      orderId: json['order_id'] as String?,
      dateOrdered: json['date_ordered'] as String?,
      dateAdded: json['date_added'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      product: json['product'] as String?,
      model: json['model'] as String?,
      quantity: json['quantity'] as String?,
      reason: json['reason'] as String?,
      opened: json['opened'] as String?,
      comment: json['comment'] as String?,
      action: json['action'],
      histories: (json['histories'] as List<dynamic>?)
          ?.map((e) => Histories.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$ReturnOrderDetailModelToJson(
        ReturnOrderDetailModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'return_id': instance.returnId,
      'order_id': instance.orderId,
      'date_ordered': instance.dateOrdered,
      'date_added': instance.dateAdded,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'telephone': instance.telephone,
      'product': instance.product,
      'model': instance.model,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'opened': instance.opened,
      'comment': instance.comment,
      'action': instance.action,
      'histories': instance.histories,
    };

Histories _$HistoriesFromJson(Map<String, dynamic> json) => Histories(
      status: json['status'] as String?,
      comment: json['comment'] as String?,
      dateAdded: json['date_added'] as String?,
    );

Map<String, dynamic> _$HistoriesToJson(Histories instance) => <String, dynamic>{
      'status': instance.status,
      'comment': instance.comment,
      'date_added': instance.dateAdded,
    };
