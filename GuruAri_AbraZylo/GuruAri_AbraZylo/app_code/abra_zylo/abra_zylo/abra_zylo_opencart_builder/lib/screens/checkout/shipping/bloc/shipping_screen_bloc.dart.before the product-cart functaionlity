import 'package:bloc/bloc.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_event.dart';
import 'package:oc_demo/screens/checkout/shipping/bloc/shipping_screen_event.dart';
import 'package:oc_demo/screens/checkout/shipping/bloc/shipping_screen_state.dart';

import 'shipping_screen_repository.dart';

class ShippingScreenBloc
    extends Bloc<ShippingScreenEvent, ShippingScreenState> {
  ShippingScreenRepository? repository;

  ShippingScreenBloc({this.repository}) : super(ShippingInitialState()) {
    on<ShippingScreenEvent>(mapEventToState);
  }

  void mapEventToState(
    ShippingScreenEvent event,
    Emitter<ShippingScreenState> emit,
  ) async {
    if (event is PaymentOrBillingAddressEvent) {
      // Fetched shipping Address
      try {
        var addressModel = await repository?.getPaymentOrBillingAddress();
        if (addressModel != null) {
          emit(FetchBillingAddressState(addressModel));
        } else {
          emit(ShippingScreenError(""));
        }
      } catch (error) {
        emit(ShippingScreenError(error.toString()));
      }
    } else if (event is GuestShippingMethodEvent) {
      try {
        var carriers = await repository?.guestShippingMethod(
            event.addAddressRequest, event.function);
        if (carriers != null /*&& (carriers.error??0)==0*/) {
          emit(GuestShippingMethodState(carriers));
        } else {
          emit(ShippingScreenError(AppStringConstant.somethingWentWrong));
        }
      } catch (error) {
        emit(ShippingScreenError(error.toString()));
      }
    } else if (event is GetCheckoutShippingMethodEvent) {
      try {
        var carriers = await repository?.getShippingMethods(
            /*(event).shippingAddress, (event).addressId*/);
        if (carriers != null) {
          emit(FetchCheckoutShippingMethodState(carriers));
        } else {
          emit(ShippingScreenError(""));
        }
      } catch (error) {
        emit(ShippingScreenError(error.toString()));
      }
    } else if (event is GetShippingAddressEvent) {
      try {
        var model = await repository?.getShippingAddress();
        if (model != null) {
          emit(FetchShippingAddressState(model));
        } else {
          emit(ShippingScreenError(""));
        }
      } catch (error) {
        emit(ShippingScreenError(error.toString()));
      }
    } else if (event is ShippingLoadingEvent) {
      emit(ShippingLoadingState());
    }
  }
}
