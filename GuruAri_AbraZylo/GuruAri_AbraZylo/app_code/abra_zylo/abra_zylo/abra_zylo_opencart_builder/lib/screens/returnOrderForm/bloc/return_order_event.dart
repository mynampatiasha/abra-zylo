import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/address/add_address_request.dart';

abstract class ReturnOrderEvent extends Equatable {
  const ReturnOrderEvent();

  @override
  List<Object> get props => [];
}

class ReturnOrderDataFetchEvent extends ReturnOrderEvent {
  String? orderId, orderProductId;

  ReturnOrderDataFetchEvent(this.orderId, this.orderProductId);

  @override
  List<Object> get props => [];
}

class ReturnOrderSubmitEvent extends ReturnOrderEvent {
  String? orderId,
      orderProductId,
      firstname,
      lastname,
      email,
      telephone,
      date_ordered,
      product,
      model,
      quantity,
      return_reason_id,
      opened,
      comment;

  ReturnOrderSubmitEvent(
      this.orderId,
      this.orderProductId,
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.date_ordered,
      this.product,
      this.model,
      this.quantity,
      this.return_reason_id,
      this.opened,
      this.comment);

  @override
  List<Object> get props => [];
}
