import 'package:equatable/equatable.dart';

import '../../../../models/address/add_address_request.dart';

abstract class GuestCheckoutScreenEvent extends Equatable {
  const GuestCheckoutScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends GuestCheckoutScreenEvent {
  const LoadingEvent();

  @override
  List<Object> get props => [];
}

class GuestCheckoutEvent extends GuestCheckoutScreenEvent {
  const GuestCheckoutEvent();
  @override
  List<Object> get props => [];
}

class GuestShipppingEvent extends GuestCheckoutScreenEvent {
  GuestShipppingEvent(this.shippingAddress, this.addAddressRequest);
  AddAddressRequest addAddressRequest;
  String shippingAddress;
  @override
  List<Object> get props => [];
}
/*class PaymentMethodEventWhileShippingNotRequired extends GuestCheckoutScreenEvent {
  const PaymentMethodEventWhileShippingNotRequired();

  @override
  List<Object> get props => [];
}
class OrderPlaceEvent extends GuestCheckoutScreenEvent {
  const OrderPlaceEvent(this.state);

  final String state;

  @override
  List<Object> get props => [state];
}*/
