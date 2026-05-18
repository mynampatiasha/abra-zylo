import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'order_detail_screen_repository.dart';

part 'order_detail_event.dart';

part 'order_detail_screen_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  OrderDetailRepository? repository;

  OrderDetailsBloc({this.repository}) : super(OrderDetailInitial()) {
    on<OrderDetailEvent>(mapEventToState);
  }

  @override
  void mapEventToState(
      OrderDetailEvent event, Emitter<OrderDetailState> emit) async {
    if (event is OrderDetailFetchEvent) {
      try {
        var model = await repository?.getOrderDetails(event.orderId);
        if (model != null) {
          emit(OrderDetailSuccess(model));
        } else {
          emit(OrderDetailError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(OrderDetailError(error.toString()));
      }
    } else if (event is ReorderProductEvent) {
      try {
        var model = await repository?.reorderProduct(
            event.orderId ?? "", event.orderProductId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToCartStateSuccess(model));
        } else {
          emit(OrderDetailError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(OrderDetailError(error.toString()));
      }
    }
  }
}
