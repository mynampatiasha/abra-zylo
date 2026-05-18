import 'package:equatable/equatable.dart';

abstract class OrderScreenEvent extends Equatable {
  const OrderScreenEvent();

  @override
  List<Object> get props => [];
}

class OrderScreenDataFetchEvent extends OrderScreenEvent {
  final String wkToken;
  final String page;
  const OrderScreenDataFetchEvent(this.wkToken, this.page);
}

class OrderDetailsFetchEvent extends OrderScreenEvent {
  final String orderId;
  const OrderDetailsFetchEvent(this.orderId);
}
