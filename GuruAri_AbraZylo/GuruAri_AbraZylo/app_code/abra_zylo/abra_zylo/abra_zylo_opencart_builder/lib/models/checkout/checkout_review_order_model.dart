import 'package:json_annotation/json_annotation.dart';

import '../../screens/razor_pay_payment/model/razor_pay_model.dart';

part 'checkout_review_order_model.g.dart';

@JsonSerializable()
class CheckoutReviewOrderModel {
  @JsonKey(name: "continue")
  Continue? continu;
  String? account;
  String? logged;
  dynamic cartCount;
  @JsonKey(name: "currency_code")
  String? currencyCode;

  CheckoutReviewOrderModel({
    this.continu,
    this.account,
    this.logged,
    this.cartCount,
    this.currencyCode,
  });

  factory CheckoutReviewOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutReviewOrderModelFromJson(json);
}

@JsonSerializable()
class Continue {
  @JsonKey(name: "column_total")
  String? columnTotal;
  @JsonKey(name: "totals")
  List<Totals>? totals;
  @JsonKey(name: "order_details")
  OrderDetails? orderDetails;
  @JsonKey(name: "order_id")
  int? orderId;
  RazorPayModel? razorpay;

  Continue(
      {this.columnTotal,
      this.totals,
      this.orderDetails,
      this.orderId,
      this.razorpay});

  factory Continue.fromJson(Map<String, dynamic> json) =>
      _$ContinueFromJson(json);
}

@JsonSerializable()
class Totals {
  String? title;
  String? text;
  dynamic? value;

  Totals({this.title, this.text, this.value});

  factory Totals.fromJson(Map<String, dynamic> json) => _$TotalsFromJson(json);
}

@JsonSerializable()
class OrderDetails {
  List<OrderTotals>? totals;
  @JsonKey(name: "invoice_prefix")
  String? invoicePrefix;
  @JsonKey(name: "store_id")
  int? storeId;
  @JsonKey(name: "store_name")
  String? storeName;
  @JsonKey(name: "store_url")
  String? storeUrl;

  /*@JsonKey(name: "customer_id")
  String? customerId;
  @JsonKey(name: "customer_group_id")
  String? customerGroupId;*/
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? fax;
  @JsonKey(name: "payment_firstname")
  String? paymentFirstname = "";
  @JsonKey(name: "payment_lastname")
  String? paymentLastname = "";
  @JsonKey(name: "payment_company")
  String? paymentCompany = "";
  @JsonKey(name: "payment_address_1")
  String? paymentAddress1 = "";
  @JsonKey(name: "payment_address_2")
  String? paymentAddress2 = "";
  @JsonKey(name: "payment_city")
  String? paymentCity = "";
  @JsonKey(name: "payment_postcode")
  String? paymentPostcode = "";
  @JsonKey(name: "payment_zone")
  String? paymentZone = "";
  @JsonKey(name: "payment_zone_id")
  String? paymentZoneId = "";
  @JsonKey(name: "payment_country")
  String? paymentCountry = "";
  @JsonKey(name: "payment_country_id")
  String? paymentCountryId = "";
  @JsonKey(name: "payment_address_format")
  String? paymentAddressFormat;
  @JsonKey(name: "payment_method")
  String? paymentMethod;
  @JsonKey(name: "payment_code")
  String? paymentCode;
  @JsonKey(name: "shipping_firstname")
  String? shippingFirstname = "";
  @JsonKey(name: "shipping_lastname")
  String? shippingLastname = "";
  @JsonKey(name: "shipping_company")
  String? shippingCompany = "";
  @JsonKey(name: "shipping_address_1")
  String? shippingAddress1 = "";
  @JsonKey(name: "shipping_address_2")
  String? shippingAddress2 = "";
  @JsonKey(name: "shipping_city")
  String? shippingCity = "";
  @JsonKey(name: "shipping_postcode")
  String? shippingPostcode = "";
  @JsonKey(name: "shipping_zone")
  String? shippingZone = "";
  @JsonKey(name: "shipping_zone_id")
  String? shippingZoneId = "";
  @JsonKey(name: "shipping_country")
  String? shippingCountry = "";
  @JsonKey(name: "shipping_country_id")
  String? shippingCountryId = "";
  @JsonKey(name: "shipping_address_format")
  String? shippingAddressFormat = "";
  @JsonKey(name: "shipping_method")
  String? shippingMethod;
  @JsonKey(name: "shipping_code")
  String? shippingCode;
  @JsonKey(name: "products")
  List<Products>? products;
  String? comment;
  dynamic? total;
  @JsonKey(name: "affiliate_id")
  int? affiliateId;
  int? commission;
  int? marketingId;
  String? tracking;
  @JsonKey(name: "language_id")
  String? languageId;
  @JsonKey(name: "currency_id")
  String? currencyId;
  @JsonKey(name: "currency_code")
  String? currencyCode;
  @JsonKey(name: "currency_value")
  String? currencyValue;
  String? ip;
  String? forwardedIp;
  String? userAgent;
  String? acceptLanguage;

  OrderDetails(
      {this.totals,
      this.invoicePrefix,
      this.storeId,
      this.storeName,
      this.storeUrl,
      /*this.customerId,
      this.customerGroupId,*/
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.fax,
      this.paymentFirstname,
      this.paymentLastname,
      this.paymentCompany,
      this.paymentAddress1,
      this.paymentAddress2,
      this.paymentCity,
      this.paymentPostcode,
      this.paymentZone,
      this.paymentZoneId,
      this.paymentCountry,
      this.paymentCountryId,
      this.paymentAddressFormat,
      this.paymentMethod,
      this.paymentCode,
      this.shippingFirstname,
      this.shippingLastname,
      this.shippingCompany,
      this.shippingAddress1,
      this.shippingAddress2,
      this.shippingCity,
      this.shippingPostcode,
      this.shippingZone,
      this.shippingZoneId,
      this.shippingCountry,
      this.shippingCountryId,
      this.shippingAddressFormat,
      this.shippingMethod,
      this.shippingCode,
      this.products,
      this.comment,
      this.total,
      this.affiliateId,
      this.commission,
      this.marketingId,
      this.tracking,
      this.languageId,
      this.currencyId,
      this.currencyCode,
      this.currencyValue,
      this.ip,
      this.forwardedIp,
      this.userAgent,
      this.acceptLanguage});

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);
}

@JsonSerializable()
class OrderTotals {
  String? code;
  String? title;
  dynamic value;
  @JsonKey(name: "sort_order")
  String? sortOrder;

  OrderTotals({this.code, this.title, this.value, this.sortOrder});

  factory OrderTotals.fromJson(Map<String, dynamic> json) =>
      _$OrderTotalsFromJson(json);
}

@JsonSerializable()
class Products {
  @JsonKey(name: "product_id")
  String? productId;
  String? name;
  String? model;
  List<Option>? option;
  List<Download>? download;
  String? quantity;
  String? subtract;
  dynamic price;
  dynamic total;
  @JsonKey(name: "price_text")
  String? priceText;
  @JsonKey(name: "total_text")
  String? totalText;
  dynamic? tax;
  dynamic? reward;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? image;

  Products(
      {this.productId,
      this.name,
      this.model,
      this.option,
      this.download,
      this.quantity,
      this.subtract,
      this.price,
      this.total,
      this.priceText,
      this.totalText,
      this.tax,
      this.reward,
      this.dominantColor,
      this.image});

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);
}

@JsonSerializable()
class Option {
  @JsonKey(name: "product_option_id")
  String? productOptionId;
  @JsonKey(name: "product_option_value_id")
  String? productOptionValueId;
  @JsonKey(name: "option_id")
  String? optionId;
  @JsonKey(name: "option_value_id")
  String? optionValueId;
  String? name;
  String? value;
  String? type;

  Option(
      {this.productOptionId,
      this.productOptionValueId,
      this.optionId,
      this.optionValueId,
      this.name,
      this.value,
      this.type});

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}

@JsonSerializable()
class Download {
  @JsonKey(name: "download_id")
  String? downloadId;
  String? name;
  String? filename;
  String? mask;

  Download({this.downloadId, this.name, this.filename, this.mask});

  factory Download.fromJson(Map<String, dynamic> json) =>
      _$DownloadFromJson(json);
}
