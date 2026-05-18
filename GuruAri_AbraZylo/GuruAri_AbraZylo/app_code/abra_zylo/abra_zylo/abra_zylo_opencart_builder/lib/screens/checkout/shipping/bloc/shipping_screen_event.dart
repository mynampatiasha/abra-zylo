import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/address/add_address_request.dart';

abstract class ShippingScreenEvent extends Equatable {
  const ShippingScreenEvent();

  @override
  List<Object> get props => [];
}

class ShippingLoadingEvent extends ShippingScreenEvent {
  const ShippingLoadingEvent();

  @override
  List<Object> get props => [];
}

/*
* Event for billing or payment  address
* */
class PaymentOrBillingAddressEvent extends ShippingScreenEvent {
  const PaymentOrBillingAddressEvent();

  @override
  List<Object> get props => [];
}

/*
*event for shipping address
* */
class GetShippingAddressEvent extends ShippingScreenEvent {
  const GetShippingAddressEvent(
      /* {required this.addressId, required this.paymentAddress}*/);

  //final String addressId, paymentAddress;

  @override
  List<Object> get props => [];
}

/*
* event for shipping Methods
* */
class GetCheckoutShippingMethodEvent extends ShippingScreenEvent {
  const GetCheckoutShippingMethodEvent();
  @override
  List<Object> get props => [/*addressId, shippingAddress*/];
}

/*
* event for shipping Methods
* */
class GuestShippingMethodEvent extends ShippingScreenEvent {
  GuestShippingMethodEvent(
      {required this.addAddressRequest, required this.function});
  AddAddressRequest addAddressRequest;
  String function;
  @override
  List<Object> get props => [/*addressId, shippingAddress*/];
}
