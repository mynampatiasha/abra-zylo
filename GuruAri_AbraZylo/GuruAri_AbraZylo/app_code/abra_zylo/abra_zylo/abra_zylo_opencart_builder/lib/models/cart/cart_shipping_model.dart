import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'cart_shipping_model.g.dart';

@JsonSerializable()
class CartShippingModel extends BaseModel {
  int? error;
  String? message;
  List<ShippingMethod>? shippingMethod;

  CartShippingModel({this.error, this.shippingMethod, this.message});

  CartShippingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['shipping_method'] != null) {
      shippingMethod = <ShippingMethod>[];
      json['shipping_method'].forEach((v) {
        shippingMethod!.add(new ShippingMethod.fromJson(v));
      });
    }
  }
}

@JsonSerializable()
class ShippingMethod {
  String? title;
  List<Quote>? quote;
  String? sortOrder;

  ShippingMethod({this.title, this.quote, this.sortOrder});

  ShippingMethod.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['quote'] != null) {
      quote = <Quote>[];
      json['quote'].forEach((v) {
        quote!.add(new Quote.fromJson(v));
      });
    }
    sortOrder = json['sort_order'];
  }
}

@JsonSerializable()
class Quote {
  String? code;
  String? title;
  dynamic? cost;
  dynamic? taxClassId;
  String? text;
  bool? isSelected = false;

  Quote({this.code, this.title, this.cost, this.taxClassId, this.text});

  Quote.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    cost = json['cost'];
    taxClassId = json['tax_class_id'];
    text = json['text'];
  }
}
