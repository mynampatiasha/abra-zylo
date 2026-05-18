import 'package:bloc/bloc.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_event.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_repository.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_state.dart';

class GuestCheckoutScreenBloc
    extends Bloc<GuestCheckoutScreenEvent, GuestCheckoutScreenState> {
  GuestCheckoutScreenRepository? repository;

  GuestCheckoutScreenBloc({this.repository}) : super(const InitialState()) {
    on<GuestCheckoutScreenEvent>(mapEventToState);
  }

  void mapEventToState(
    GuestCheckoutScreenEvent event,
    Emitter<GuestCheckoutScreenState> emit,
  ) async {
    if (event is GuestCheckoutEvent) {
      try {
        var model = await repository?.guestCheckout();
        if (model != null) {
          emit(GuestCheckoutState(model));
        } else {
          emit(GuestCheckoutScreenStateError(""));
        }
      } catch (error) {
        emit(GuestCheckoutScreenStateError(error.toString()));
      }
    }
    if (event is GuestShipppingEvent) {
      try {
        var model = await repository?.guestShippingMethod(
            event.shippingAddress, event.addAddressRequest);
        if (model != null) {
          emit(GuestShippingAddressState(model));
        } else {
          emit(GuestCheckoutScreenStateError(""));
        }
      } catch (error) {
        emit(GuestCheckoutScreenStateError(error.toString()));
      }
    }
  }
}
