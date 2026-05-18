import 'package:bloc/bloc.dart';
import '../../../../helper/app_shared_pref.dart';
import 'order_review_screen_event.dart';
import 'order_review_screen_repository.dart';
import 'order_review_screen_state.dart';

class OrderReviewScreenBloc
    extends Bloc<OrderReviewScreenEvent, OrderReviewScreenState> {
  OrderReviewScreenRepository? repository;

  OrderReviewScreenBloc({this.repository}) : super(const InitialState()) {
    on<OrderReviewScreenEvent>(mapEventToState);
  }

  void mapEventToState(
    OrderReviewScreenEvent event,
    Emitter<OrderReviewScreenState> emit,
  ) async {
    if (event is PaymentMethodEvent) {
      try {
        var model = await repository?.getPaymentMethods(event.comment);
        if (model != null) {
          emit(PaymentMethodState(model));
        } else {
          emit(OrderReviewScreenError(""));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    }
    if (event is PaymentMethodEventWhileShippingNotRequired) {
      try {
        var model = await repository?.getPaymentMethodWhenShippingNotRequired();
        if (model != null) {
          emit(PaymentMethodState(model));
        } else {
          emit(OrderReviewScreenError(""));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    } else if (event is OrderReviewEvent) {
      try {
        var model = await repository?.reviewOrder(
            event.paymentMethod, event.comment, event.agree);
        if (model != null) {
          emit(OrderReviewState(model));
        } else {
          emit(OrderReviewScreenError(""));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    } else if (event is LoadingEvent) {
      emit(OrderReviewLoadingState());
    } else if (event is OrderPlaceEvent) {
      try {
        var model = await repository?.placeOrder(event.state, event.paymentId);
        if (model != null) {
          AppSharedPref.setShippingAddressId("");
          AppSharedPref.setSelectedPaymentId("");
          AppSharedPref.setBillingAddressId("");
          AppSharedPref.setSelectedShippingId("");
          AppSharedPref.setCartCount("0");
          AppSharedPref.setCartAmount("0");
          AppSharedPref.setShippingAddressSameAsBilling(true);
          // AppSharedPref.setCartId("");
          emit(OrderPlaceState(model));
        } else {
          emit(OrderReviewScreenError(""));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    }
  }
}
