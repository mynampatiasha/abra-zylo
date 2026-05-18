// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_review_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutReviewOrderModel _$CheckoutReviewOrderModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutReviewOrderModel(
      continu: json['continue'] == null
          ? null
          : Continue.fromJson(json['continue'] as Map<String, dynamic>),
      account: json['account'] as String?,
      logged: json['logged'] as String?,
      cartCount: json['cartCount'],
      currencyCode: json['currency_code'] as String?,
    );

Map<String, dynamic> _$CheckoutReviewOrderModelToJson(
        CheckoutReviewOrderModel instance) =>
    <String, dynamic>{
      'continue': instance.continu,
      'account': instance.account,
      'logged': instance.logged,
      'cartCount': instance.cartCount,
      'currency_code': instance.currencyCode,
    };

Continue _$ContinueFromJson(Map<String, dynamic> json) => Continue(
      columnTotal: json['column_total'] as String?,
      totals: (json['totals'] as List<dynamic>?)
          ?.map((e) => Totals.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDetails: json['order_details'] == null
          ? null
          : OrderDetails.fromJson(
              json['order_details'] as Map<String, dynamic>),
      orderId: json['order_id'] as int?,
      razorpay: json['razorpay'] == null
          ? null
          : RazorPayModel.fromJson(json['razorpay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContinueToJson(Continue instance) => <String, dynamic>{
      'column_total': instance.columnTotal,
      'totals': instance.totals,
      'order_details': instance.orderDetails,
      'order_id': instance.orderId,
      'razorpay': instance.razorpay,
    };

Totals _$TotalsFromJson(Map<String, dynamic> json) => Totals(
      title: json['title'] as String?,
      text: json['text'] as String?,
      value: json['value'],
    );

Map<String, dynamic> _$TotalsToJson(Totals instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'value': instance.value,
    };

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
      totals: (json['totals'] as List<dynamic>?)
          ?.map((e) => OrderTotals.fromJson(e as Map<String, dynamic>))
          .toList(),
      invoicePrefix: json['invoice_prefix'] as String?,
      storeId: json['store_id'] as int?,
      storeName: json['store_name'] as String?,
      storeUrl: json['store_url'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      fax: json['fax'] as String?,
      paymentFirstname: json['payment_firstname'] as String?,
      paymentLastname: json['payment_lastname'] as String?,
      paymentCompany: json['payment_company'] as String?,
      paymentAddress1: json['payment_address_1'] as String?,
      paymentAddress2: json['payment_address_2'] as String?,
      paymentCity: json['payment_city'] as String?,
      paymentPostcode: json['payment_postcode'] as String?,
      paymentZone: json['payment_zone'] as String?,
      paymentZoneId: json['payment_zone_id'] as String?,
      paymentCountry: json['payment_country'] as String?,
      paymentCountryId: json['payment_country_id'] as String?,
      paymentAddressFormat: json['payment_address_format'] as String?,
      paymentMethod: json['payment_method'] as String?,
      paymentCode: json['payment_code'] as String?,
      shippingFirstname: json['shipping_firstname'] as String?,
      shippingLastname: json['shipping_lastname'] as String?,
      shippingCompany: json['shipping_company'] as String?,
      shippingAddress1: json['shipping_address_1'] as String?,
      shippingAddress2: json['shipping_address_2'] as String?,
      shippingCity: json['shipping_city'] as String?,
      shippingPostcode: json['shipping_postcode'] as String?,
      shippingZone: json['shipping_zone'] as String?,
      shippingZoneId: json['shipping_zone_id'] as String?,
      shippingCountry: json['shipping_country'] as String?,
      shippingCountryId: json['shipping_country_id'] as String?,
      shippingAddressFormat: json['shipping_address_format'] as String?,
      shippingMethod: json['shipping_method'] as String?,
      shippingCode: json['shipping_code'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Products.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: json['comment'] as String?,
      total: json['total'],
      affiliateId: json['affiliate_id'] as int?,
      commission: json['commission'] as int?,
      marketingId: json['marketingId'] as int?,
      tracking: json['tracking'] as String?,
      languageId: json['language_id'] as String?,
      currencyId: json['currency_id'] as String?,
      currencyCode: json['currency_code'] as String?,
      currencyValue: json['currency_value'] as String?,
      ip: json['ip'] as String?,
      forwardedIp: json['forwardedIp'] as String?,
      userAgent: json['userAgent'] as String?,
      acceptLanguage: json['acceptLanguage'] as String?,
    );

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'totals': instance.totals,
      'invoice_prefix': instance.invoicePrefix,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'store_url': instance.storeUrl,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'telephone': instance.telephone,
      'fax': instance.fax,
      'payment_firstname': instance.paymentFirstname,
      'payment_lastname': instance.paymentLastname,
      'payment_company': instance.paymentCompany,
      'payment_address_1': instance.paymentAddress1,
      'payment_address_2': instance.paymentAddress2,
      'payment_city': instance.paymentCity,
      'payment_postcode': instance.paymentPostcode,
      'payment_zone': instance.paymentZone,
      'payment_zone_id': instance.paymentZoneId,
      'payment_country': instance.paymentCountry,
      'payment_country_id': instance.paymentCountryId,
      'payment_address_format': instance.paymentAddressFormat,
      'payment_method': instance.paymentMethod,
      'payment_code': instance.paymentCode,
      'shipping_firstname': instance.shippingFirstname,
      'shipping_lastname': instance.shippingLastname,
      'shipping_company': instance.shippingCompany,
      'shipping_address_1': instance.shippingAddress1,
      'shipping_address_2': instance.shippingAddress2,
      'shipping_city': instance.shippingCity,
      'shipping_postcode': instance.shippingPostcode,
      'shipping_zone': instance.shippingZone,
      'shipping_zone_id': instance.shippingZoneId,
      'shipping_country': instance.shippingCountry,
      'shipping_country_id': instance.shippingCountryId,
      'shipping_address_format': instance.shippingAddressFormat,
      'shipping_method': instance.shippingMethod,
      'shipping_code': instance.shippingCode,
      'products': instance.products,
      'comment': instance.comment,
      'total': instance.total,
      'affiliate_id': instance.affiliateId,
      'commission': instance.commission,
      'marketingId': instance.marketingId,
      'tracking': instance.tracking,
      'language_id': instance.languageId,
      'currency_id': instance.currencyId,
      'currency_code': instance.currencyCode,
      'currency_value': instance.currencyValue,
      'ip': instance.ip,
      'forwardedIp': instance.forwardedIp,
      'userAgent': instance.userAgent,
      'acceptLanguage': instance.acceptLanguage,
    };

OrderTotals _$OrderTotalsFromJson(Map<String, dynamic> json) => OrderTotals(
      code: json['code'] as String?,
      title: json['title'] as String?,
      value: json['value'],
      sortOrder: json['sort_order'] as String?,
    );

Map<String, dynamic> _$OrderTotalsToJson(OrderTotals instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'value': instance.value,
      'sort_order': instance.sortOrder,
    };

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      productId: json['product_id'] as String?,
      name: json['name'] as String?,
      model: json['model'] as String?,
      option: (json['option'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      download: (json['download'] as List<dynamic>?)
          ?.map((e) => Download.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'] as String?,
      subtract: json['subtract'] as String?,
      price: json['price'],
      total: json['total'],
      priceText: json['price_text'] as String?,
      totalText: json['total_text'] as String?,
      tax: json['tax'],
      reward: json['reward'],
      dominantColor: json['dominant_color'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'model': instance.model,
      'option': instance.option,
      'download': instance.download,
      'quantity': instance.quantity,
      'subtract': instance.subtract,
      'price': instance.price,
      'total': instance.total,
      'price_text': instance.priceText,
      'total_text': instance.totalText,
      'tax': instance.tax,
      'reward': instance.reward,
      'dominant_color': instance.dominantColor,
      'image': instance.image,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      productOptionId: json['product_option_id'] as String?,
      productOptionValueId: json['product_option_value_id'] as String?,
      optionId: json['option_id'] as String?,
      optionValueId: json['option_value_id'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'product_option_id': instance.productOptionId,
      'product_option_value_id': instance.productOptionValueId,
      'option_id': instance.optionId,
      'option_value_id': instance.optionValueId,
      'name': instance.name,
      'value': instance.value,
      'type': instance.type,
    };

Download _$DownloadFromJson(Map<String, dynamic> json) => Download(
      downloadId: json['download_id'] as String?,
      name: json['name'] as String?,
      filename: json['filename'] as String?,
      mask: json['mask'] as String?,
    );

Map<String, dynamic> _$DownloadToJson(Download instance) => <String, dynamic>{
      'download_id': instance.downloadId,
      'name': instance.name,
      'filename': instance.filename,
      'mask': instance.mask,
    };
