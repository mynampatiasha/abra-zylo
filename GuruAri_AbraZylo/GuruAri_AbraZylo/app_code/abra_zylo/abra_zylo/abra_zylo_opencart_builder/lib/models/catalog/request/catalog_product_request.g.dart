// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_product_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatalogProductRequest _$CatalogProductRequestFromJson(
        Map<String, dynamic> json) =>
    CatalogProductRequest(
      page: json['page'] as String?,
      limit: json['limit'] as String?,
      width: json['width'] as String?,
      path: json['path'] as String?,
      id: json['id'] as String?,
      sort: json['sort'] as String?,
      order: json['order'] as String?,
      filter: json['filter'] as String?,
      token: json['wk_token'] as String?,
      manufactureId: json['manufacture_id'] as String?,
    );

Map<String, dynamic> _$CatalogProductRequestToJson(
        CatalogProductRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'width': instance.width,
      'path': instance.path,
      'id': instance.id,
      'sort': instance.sort,
      'order': instance.order,
      'filter': instance.filter,
      'wk_token': instance.token,
      'manufacture_id': instance.manufactureId,
    };
