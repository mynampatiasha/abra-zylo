import 'package:equatable/equatable.dart';

abstract class OrderReviewScreenEvent extends Equatable {
  const OrderReviewScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends OrderReviewScreenEvent {
  const LoadingEvent();

  @override
  List<Object> get props => [];
}

class OrderReviewEvent extends OrderReviewScreenEvent {
  OrderReviewEvent(this.paymentMethod, this.comment, this.agree);
  String paymentMethod, comment, agree;

  @override
  List<Object> get props => [];
}

class PaymentMethodEvent extends OrderReviewScreenEvent {
  PaymentMethodEvent(this.comment);
  String comment;

  @override
  List<Object> get props => [];
}

class PaymentMethodEventWhileShippingNotRequired
    extends OrderReviewScreenEvent {
  const PaymentMethodEventWhileShippingNotRequired();

  @override
  List<Object> get props => [];
}

class OrderPlaceEvent extends OrderReviewScreenEvent {
  const OrderPlaceEvent(this.state, this.paymentId);
  final String paymentId;
  final String state;

  @override
  List<Object> get props => [state];
}

class FetchApiDetails extends OrderReviewScreenEvent {}
