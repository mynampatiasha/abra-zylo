import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/models/orderListModel/order_list_model.dart';
import 'package:oc_demo/models/returnOrderDetailModel/return_order_detail_model.dart';
import 'package:oc_demo/models/returnOrderListModel/return_order_list_model.dart';

abstract class ReturnOrderInformationScreenState extends Equatable {
  const ReturnOrderInformationScreenState();

  @override
  List<Object> get props => [];
}

class ReturnOrderInformationScreenInitial
    extends ReturnOrderInformationScreenState {}

class ReturnOrderInformationScreenSuccess
    extends ReturnOrderInformationScreenState {
  final ReturnOrderDetailModel returns;
  const ReturnOrderInformationScreenSuccess(this.returns);
}

class ReturnOrderInformationScreenError
    extends ReturnOrderInformationScreenState {
  final String message;
  const ReturnOrderInformationScreenError(this.message);
}
