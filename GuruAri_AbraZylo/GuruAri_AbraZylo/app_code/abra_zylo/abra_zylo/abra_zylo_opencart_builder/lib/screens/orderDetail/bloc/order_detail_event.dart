part of 'order_detail_screen_bloc.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object> get props => [];
}

class OrderDetailFetchEvent extends OrderDetailEvent {
  String orderId;
  OrderDetailFetchEvent(this.orderId);
}

class ReorderProductEvent extends OrderDetailEvent {
  String orderId;
  String orderProductId;
  ReorderProductEvent(this.orderId, this.orderProductId);
}
