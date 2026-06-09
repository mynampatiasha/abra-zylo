import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/checkout/checkout_confirm_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';

abstract class OrderReviewScreenState extends Equatable {
  const OrderReviewScreenState();

  @override
  List<Object> get props => [];
}

class OrderReviewLoadingState extends OrderReviewScreenState {}

class InitialState extends OrderReviewScreenState {
  const InitialState();

  @override
  List<Object> get props => [];
}

class OrderReviewState extends OrderReviewScreenState {
  const OrderReviewState(this.model);

  final CheckoutReviewOrderModel model;

  @override
  List<Object> get props => [model];
}

class PaymentMethodState extends OrderReviewScreenState {
  const PaymentMethodState(this.model);

  final CheckoutPaymentMethodModel model;

  @override
  List<Object> get props => [model];
}

class OrderPlaceState extends OrderReviewScreenState {
  const OrderPlaceState(this.model);

  final CheckoutConfirmOrderModel model;

  @override
  List<Object> get props => [model];
}

class OrderReviewScreenError extends OrderReviewScreenState {
  OrderReviewScreenError(this._message);
  String? _message;
  String? get message => _message;
  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}

class EmptyState extends OrderReviewScreenState {}
