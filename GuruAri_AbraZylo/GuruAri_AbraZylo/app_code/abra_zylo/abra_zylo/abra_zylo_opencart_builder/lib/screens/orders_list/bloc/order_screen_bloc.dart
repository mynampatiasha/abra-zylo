import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_screen_events.dart';
import 'order_screen_repository.dart';
import 'order_screen_state.dart';

class OrderScreenBloc extends Bloc<OrderScreenEvent, OrderScreenState> {
  OrderScreenRepositoryImp? repository;

  OrderScreenBloc({this.repository}) : super(OrderScreenInitial()) {
    on<OrderScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      OrderScreenEvent event, Emitter<OrderScreenState> emit) async {
    if (event is OrderScreenDataFetchEvent) {
      emit(OrderScreenInitial());
      try {
        var model = await repository?.getOrderListFromDb(event.page);
        if (model != null) {
          emit(OrderScreenSuccess(model));
        }
        model = await repository?.getOrderList(
            event.wkToken, event.page, model?.eTag ?? "");
        if (model != null) {
          emit(OrderScreenSuccess(model));
        } else {
          emit(const OrderScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(OrderScreenError(error.toString()));
      }
    } else if (event is OrderDetailsFetchEvent) {
      emit(OrderScreenInitial());
      try {
        var model = await repository?.getOrderDetails(event.orderId);
        if (model != null) {
          emit(OrderDetailsSuccess(model));
        } else {
          emit(const OrderScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(OrderScreenError(error.toString()));
      }
    }
  }
}
