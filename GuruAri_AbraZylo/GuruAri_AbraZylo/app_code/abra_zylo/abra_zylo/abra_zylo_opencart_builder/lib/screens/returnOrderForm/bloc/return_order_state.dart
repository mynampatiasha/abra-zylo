import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/orderDetailModel/return_order_request.dart';

abstract class ReturnOrderState extends Equatable {
  const ReturnOrderState();

  @override
  List<Object> get props => [];
}

class ReturnOrderInitial extends ReturnOrderState {}

class ReturnOrderFetchSuccess extends ReturnOrderState {
  final ReturnOrderRequest model;

  const ReturnOrderFetchSuccess(this.model);

  @override
  List<Object> get props => [];
}

class ReturnOrderSubmitSuccess extends ReturnOrderState {
  final BaseModel model;

  const ReturnOrderSubmitSuccess(this.model);

  @override
  List<Object> get props => [];
}

class ReturnOrderError extends ReturnOrderState {
  ReturnOrderError(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}
