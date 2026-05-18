import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_event.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_repository.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_state.dart';

class ReturnOrderBloc extends Bloc<ReturnOrderEvent, ReturnOrderState> {
  ReturnOrderRepository? repository;

  ReturnOrderBloc({this.repository}) : super(ReturnOrderInitial()) {
    on<ReturnOrderEvent>(mapEventToState);
  }

  void mapEventToState(
      ReturnOrderEvent event, Emitter<ReturnOrderState> emit) async {
    switch (event.runtimeType) {
      case ReturnOrderDataFetchEvent:
        try {
          var model = await repository?.getReturnOrderInfo(
              (event as ReturnOrderDataFetchEvent).orderId ?? "",
              (event).orderProductId ?? "");
          if (model != null) {
            emit(ReturnOrderFetchSuccess(model));
          } else {
            emit(ReturnOrderError(''));
          }
        } catch (error, _) {
          emit(ReturnOrderError(error.toString()));
        }
        break;
      case ReturnOrderSubmitEvent:
        try {
          var model = await repository?.submitReturn(
              (event as ReturnOrderSubmitEvent).orderId ?? "",
              event.orderProductId ?? "",
              event.firstname ?? "",
              event.lastname ?? "",
              event.email ?? "",
              event.telephone ?? "",
              event.date_ordered ?? "",
              event.product ?? "",
              event.model ?? "",
              event.quantity ?? "",
              event.return_reason_id ?? "",
              event.opened ?? "",
              event.comment ?? "");
          if (model != null) {
            emit(ReturnOrderSubmitSuccess(model));
          } else {
            emit(ReturnOrderError(''));
          }
        } catch (error, _) {
          emit(ReturnOrderError(error.toString()));
        }
        break;
    }
  }
}
