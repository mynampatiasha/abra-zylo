/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_and_returns_screen_events.dart';
import 'orders_and_returns_screen_repository.dart';
import 'orders_and_returns_screen_state.dart';

class OrdersAndReturnsBloc
    extends Bloc<OrdersAndReturnsEvent, OrdersAndReturnsState> {
  OrdersAndReturnsRepository? repository;

  OrdersAndReturnsBloc({this.repository})
      : super(OrdersAndReturnsInitialState()) {
    on<OrdersAndReturnsEvent>(mapEventToState);
  }
  void mapEventToState(
      OrdersAndReturnsEvent event, Emitter<OrdersAndReturnsState> emit) async {
    if (event is OrdersAndReturnsDetailsEvent) {
      emit(OrdersAndReturnsLoadingState());
      try {
        var model = await repository?.getGuestOrdersData(
            event.incrementId, event.email, event.lastName, event.zipCode);
        if (model != null) {
          emit(OrdersAndReturnsSuccessState(model));
        } else {
          emit(const OrdersAndReturnsErrorState(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(OrdersAndReturnsErrorState(error.toString()));
      }
    }
  }
}
