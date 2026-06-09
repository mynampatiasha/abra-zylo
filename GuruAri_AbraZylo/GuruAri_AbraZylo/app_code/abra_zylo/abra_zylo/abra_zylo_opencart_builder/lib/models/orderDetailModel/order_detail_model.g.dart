// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailModel _$OrderDetailModelFromJson(Map<String, dynamic> json) =>
    OrderDetailModel(
      invoiceNo: json['invoice_no'] as String?,
      orderId: json['order_id'] as String?,
      dateAdded: json['date_added'] as String?,
      paymentAddress: json['payment_address'] as String?,
      paymentMethod: json['payment_method'] as String?,
      shippingAddress: json['shipping_address'] as String?,
      shippingMethod: json['shipping_method'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => OrderedProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: (json['totals'] as List<dynamic>?)
          ?.map((e) => OrderTotals.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: json['comment'] as String?,
      histories: (json['histories'] as List<dynamic>?)
          ?.map((e) => OrderHistories.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'],
      boyName: json['boy_name'] as String?,
      boyImage: json['boy_image'] as String?,
      boyId: json['boy_id'] as String?,
      boyVehicle: json['boy_vehicle'] as String?,
      boyVehicleType: json['boy_vehicle_type'] as String?,
      boyTelephone: json['boy_telephone'] as String?,
      deliveryCode: json['delivery_code'] as String?,
      warehouseDetails: json['order_picked'] == null
          ? null
          : WarehouseDetails.fromJson(
              json['order_picked'] as Map<String, dynamic>),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$OrderDetailModelToJson(OrderDetailModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'invoice_no': instance.invoiceNo,
      'order_id': instance.orderId,
      'date_added': instance.dateAdded,
      'payment_address': instance.paymentAddress,
      'payment_method': instance.paymentMethod,
      'shipping_address': instance.shippingAddress,
      'shipping_method': instance.shippingMethod,
      'products': instance.products,
      'totals': instance.totals,
      'comment': instance.comment,
      'histories': instance.histories,
      'error': instance.error,
      'boy_name': instance.boyName,
      'boy_image': instance.boyImage,
      'boy_id': instance.boyId,
      'boy_vehicle': instance.boyVehicle,
      'boy_vehicle_type': instance.boyVehicleType,
      'boy_telephone': instance.boyTelephone,
      'delivery_code': instance.deliveryCode,
      'order_picked': instance.warehouseDetails,
    };

OrderedProducts _$OrderedProductsFromJson(Map<String, dynamic> json) =>
    OrderedProducts(
      productId: json['product_id'] as String?,
      name: json['name'] as String?,
      orderProductId: json['order_product_id'] as String?,
      model: json['model'] as String?,
      option: (json['option'] as List<dynamic>?)
          ?.map((e) => OrderOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'] as String?,
      price: json['price'] as String?,
      total: json['total'] as String?,
    );

Map<String, dynamic> _$OrderedProductsToJson(OrderedProducts instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'order_product_id': instance.orderProductId,
      'model': instance.model,
      'option': instance.option,
      'quantity': instance.quantity,
      'price': instance.price,
      'total': instance.total,
    };

OrderOption _$OrderOptionFromJson(Map<String, dynamic> json) => OrderOption(
      name: json['name'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$OrderOptionToJson(OrderOption instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

OrderTotals _$OrderTotalsFromJson(Map<String, dynamic> json) => OrderTotals(
      title: json['title'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$OrderTotalsToJson(OrderTotals instance) =>
    <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
    };

OrderHistories _$OrderHistoriesFromJson(Map<String, dynamic> json) =>
    OrderHistories(
      dateAdded: json['date_added'] as String?,
      status: json['status'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$OrderHistoriesToJson(OrderHistories instance) =>
    <String, dynamic>{
      'date_added': instance.dateAdded,
      'status': instance.status,
      'comment': instance.comment,
    };

WarehouseDetails _$WarehouseDetailsFromJson(Map<String, dynamic> json) =>
    WarehouseDetails(
      pickup_status: json['pickup_status'] as String?,
      address: json['address'] as String?,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
    );

Map<String, dynamic> _$WarehouseDetailsToJson(WarehouseDetails instance) =>
    <String, dynamic>{
      'pickup_status': instance.pickup_status,
      'address': instance.address,
      'lat': instance.lat,
      'lon': instance.lon,
    };
