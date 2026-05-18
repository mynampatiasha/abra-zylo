import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/checkout/checkout_payment_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_method_model.dart';

abstract class ShippingScreenState extends Equatable {
  const ShippingScreenState();

  @override
  List<Object> get props => [];
}

class ShippingLoadingState extends ShippingScreenState {}

class ShippingInitialState extends ShippingScreenState {}

/*
* State to fetch shipping address from server
* */
class FetchShippingAddressState extends ShippingScreenState {
  const FetchShippingAddressState(this.model);

  final CheckoutShippingAddressModel model;

  @override
  List<Object> get props => [model];
}

/*
* State to fetch payment billing address from server
* */
class FetchBillingAddressState extends ShippingScreenState {
  const FetchBillingAddressState(this.model);

  final CheckoutPaymentAddressModel model; // Billing address model

  @override
  List<Object> get props => [model];
}

/*
* State to fetch available shipping method.
*
* */
class FetchCheckoutShippingMethodState extends ShippingScreenState {
  const FetchCheckoutShippingMethodState(this.model);

  final CheckoutShippingMethodModel model;

  @override
  List<Object> get props => [model];
}

/*
* State to fetch shipping address from server for guest user.
* */
class GuestShippingMethodState extends ShippingScreenState {
  const GuestShippingMethodState(this.model);

  final CheckoutShippingMethodModel model;

  @override
  List<Object> get props => [model];
}

/*
* Shipping state error state
* */
class ShippingScreenError extends ShippingScreenState {
  ShippingScreenError(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}
