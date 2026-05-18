import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/models/orderListModel/order_list_model.dart';

abstract class OrderScreenState /*extends Equatable*/ {
  const OrderScreenState();

  /*@override
  List<Object> get props => [];*/
}

class OrderScreenInitial extends OrderScreenState {}

class OrderScreenSuccess extends OrderScreenState {
  final OrderListModel orders;
  const OrderScreenSuccess(this.orders);
}

class OrderScreenError extends OrderScreenState {
  final String message;
  const OrderScreenError(this.message);
}

class OrderDetailsSuccess extends OrderScreenState {
  final OrderDetailModel data;
  const OrderDetailsSuccess(this.data);
}
