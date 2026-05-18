import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/checkout/checkout_confirm_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_guest_model.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';

abstract class GuestCheckoutScreenState extends Equatable {
  const GuestCheckoutScreenState();

  @override
  List<Object> get props => [];
}

class OrderReviewLoadingState extends GuestCheckoutScreenState {}

class InitialState extends GuestCheckoutScreenState {
  const InitialState();

  @override
  List<Object> get props => [];
}

class GuestCheckoutState extends GuestCheckoutScreenState {
  const GuestCheckoutState(this.model);

  final CheckoutGuestModel model;

  @override
  List<Object> get props => [model];
}

class GuestShippingAddressState extends GuestCheckoutScreenState {
  const GuestShippingAddressState(this.model);

  final CheckoutShippingAddressModel model;

  @override
  List<Object> get props => [model];
}

/*class OrderPlaceState extends GuestCheckoutScreenState {
  const OrderPlaceState(this.model);

  final CheckoutConfirmOrderModel model;

  @override
  List<Object> get props => [model];
}*/

class GuestCheckoutScreenStateError extends GuestCheckoutScreenState {
  GuestCheckoutScreenStateError(this._message);
  String? _message;
  String? get message => _message;
  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}
