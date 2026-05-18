import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/return_order_request.dart';
import 'package:oc_demo/screens/returnOrderForm/widget/return_order_form.dart';
import '../../common_widgets/alert_message.dart';
import 'bloc/return_order_bloc.dart';
import 'bloc/return_order_event.dart';
import 'bloc/return_order_state.dart';

class ReturnOrderProductScreen extends StatefulWidget {
  const ReturnOrderProductScreen(this.arguments, {super.key});
  final Map<String, dynamic>? arguments;

  @override
  State<ReturnOrderProductScreen> createState() =>
      _ReturnOrderProductScreenState();
}

class _ReturnOrderProductScreenState extends State<ReturnOrderProductScreen> {
  late bool _isLoading;

  ReturnOrderRequest? _orderDetailModel;

  ReturnOrderBloc? _bloc;

  @override
  void initState() {
    _isLoading = true;
    _bloc = context.read<ReturnOrderBloc>();
    _bloc?.add(ReturnOrderDataFetchEvent(
        widget.arguments?[orderId], widget.arguments?[productIdKey]));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        AppStringConstant.productReturn.localized(),
        context,
      ),
      body: BlocBuilder<ReturnOrderBloc, ReturnOrderState>(
        builder: (context, state) {
          if (state is ReturnOrderInitial) {
            _isLoading = true;
          } else if (state is ReturnOrderFetchSuccess) {
            _isLoading = false;
            print("---Govind---> ${widget.arguments?[productIdKey]}");
            _orderDetailModel = state.model;
          } else if (state is ReturnOrderSubmitSuccess) {
            _isLoading = false;
            if (state.model.error == 0) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.of(context).pop();
                AlertMessage.showSuccess(state.model.message ?? '', context);
              });
            }
            if (state.model.error == 1) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showWarning(state.model.message ?? '', context);
              });
            }
          } else if (state is ReturnOrderError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              AlertMessage.showSuccess(state.message ?? '', context);
            });
          }
          return buildUI();
        },
      ),
    );
  }

  Widget buildUI() {
    return Stack(
      children: <Widget>[
        if (_orderDetailModel?.error == 0)
          ReturnOrderForm(
              _orderDetailModel, widget.arguments?[productIdKey], _bloc),
        Visibility(
          visible: _isLoading,
          child: const Loader(),
        ),
      ],
    );
  }
}
