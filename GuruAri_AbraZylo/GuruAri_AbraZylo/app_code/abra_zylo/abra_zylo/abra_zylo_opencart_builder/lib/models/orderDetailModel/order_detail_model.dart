import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';
part 'order_detail_model.g.dart';

@JsonSerializable()
class OrderDetailModel extends BaseModel {
  @JsonKey(name: "invoice_no")
  String? invoiceNo;
  @JsonKey(name: "order_id")
  String? orderId;
  @JsonKey(name: "date_added")
  String? dateAdded;
  @JsonKey(name: "payment_address")
  String? paymentAddress;
  @JsonKey(name: "payment_method")
  String? paymentMethod;
  @JsonKey(name: "shipping_address")
  String? shippingAddress;
  @JsonKey(name: "shipping_method")
  String? shippingMethod;
  List<OrderedProducts>? products;
  // List<Null>? vouchers;
  List<OrderTotals>? totals;
  String? comment;
  List<OrderHistories>? histories;
  dynamic error;
  @JsonKey(name: "boy_name")
  String? boyName;
  @JsonKey(name: "boy_image")
  String? boyImage;
  @JsonKey(name: "boy_id")
  String? boyId;
  @JsonKey(name: "boy_vehicle")
  String? boyVehicle;
  @JsonKey(name: "boy_vehicle_type")
  String? boyVehicleType;
  @JsonKey(name: "boy_telephone")
  String? boyTelephone;
  @JsonKey(name: "delivery_code")
  String? deliveryCode;
  @JsonKey(name: "order_picked")
  WarehouseDetails? warehouseDetails;

  OrderDetailModel(
      {this.invoiceNo,
      this.orderId,
      this.dateAdded,
      this.paymentAddress,
      this.paymentMethod,
      this.shippingAddress,
      this.shippingMethod,
      this.products,
      // this.vouchers,
      this.totals,
      this.comment,
      this.histories,
      this.error,
      this.boyName,
      this.boyImage,
      this.boyId,
      this.boyVehicle,
      this.boyVehicleType,
      this.boyTelephone,
      this.deliveryCode,
      this.warehouseDetails});
  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailModelToJson(this);
}

@JsonSerializable()
class OrderedProducts {
  @JsonKey(name: "product_id")
  String? productId;
  String? name;
  @JsonKey(name: "order_product_id")
  String? orderProductId;
  String? model;
  List<OrderOption>? option;
  String? quantity;
  String? price;
  String? total;

  OrderedProducts(
      {this.productId,
      this.name,
      this.orderProductId,
      this.model,
      this.option,
      this.quantity,
      this.price,
      this.total});

  factory OrderedProducts.fromJson(Map<String, dynamic> json) =>
      _$OrderedProductsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderedProductsToJson(this);
}

@JsonSerializable()
class OrderOption {
  String? name;
  String? value;

  OrderOption({this.name, this.value});

  factory OrderOption.fromJson(Map<String, dynamic> json) =>
      _$OrderOptionFromJson(json);

  Map<String, dynamic> toJson() => _$OrderOptionToJson(this);
}

@JsonSerializable()
class OrderTotals {
  String? title;
  String? text;

  OrderTotals({this.title, this.text});

  factory OrderTotals.fromJson(Map<String, dynamic> json) =>
      _$OrderTotalsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTotalsToJson(this);
}

@JsonSerializable()
class OrderHistories {
  @JsonKey(name: "date_added")
  String? dateAdded;
  String? status;
  String? comment;

  OrderHistories({this.dateAdded, this.status, this.comment});

  factory OrderHistories.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoriesFromJson(json);

  Map<String, dynamic> toJson() => _$OrderHistoriesToJson(this);
}

@JsonSerializable()
class WarehouseDetails {
  final String? pickup_status;
  final String? address;

  final String? lat;

  final String? lon;

  const WarehouseDetails({
    this.pickup_status,
    this.address,
    this.lat,
    this.lon,
  });

  factory WarehouseDetails.fromJson(Map<String, dynamic> json) =>
      _$WarehouseDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseDetailsToJson(this);
}
