import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/returnOrderDetailModel/return_order_detail_model.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_tableview.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../common_widgets/loader.dart';
import '../../helper/app_localizations.dart';
import 'bloc/return_order_information_screen_bloc.dart';
import 'bloc/return_order_information_screen_events.dart';
import 'bloc/return_order_information_screen_state.dart';

class ReturnOrderInformationScreen extends StatefulWidget {
  String? returnId;

  ReturnOrderInformationScreen(this.returnId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReturnOrderInformationScreenState();
  }
}

class _ReturnOrderInformationScreenState
    extends State<ReturnOrderInformationScreen> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations? _localizations;
  ReturnOrderInformationScreenBloc? _ReturnOrderInformationScreenBloc;
  bool isLoading = false;
  ReturnOrderDetailModel? returnOrders;
  String wkToken = "";
  List<String> heading = [];
  List<List<String>> dataList = [];
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _ReturnOrderInformationScreenBloc =
        context.read<ReturnOrderInformationScreenBloc>();
    AppSharedPref.getWkToken().then((value) {
      wkToken = value;
      _ReturnOrderInformationScreenBloc?.add(
          ReturnOrderInformationScreenDataFetchEvent(widget.returnId));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    heading = [
      _localizations?.translate(AppStringConstant.dateAdded) ?? "Date Added",
      _localizations?.translate(AppStringConstant.status) ?? "Status",
      _localizations?.translate(AppStringConstant.comment) ?? "Comment"
    ];

    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.returnInformation) ?? '',
          context),
      body: BlocBuilder<ReturnOrderInformationScreenBloc,
          ReturnOrderInformationScreenState>(builder: (context, currentState) {
        if (currentState is ReturnOrderInformationScreenInitial) {
          isLoading = true;
        } else if (currentState is ReturnOrderInformationScreenSuccess) {
          isLoading = false;
          returnOrders = currentState.returns;
          if (returnOrders != null) {
            for (Histories data in returnOrders?.histories ?? []) {
              dataList.add([
                data.dateAdded ?? "",
                data.status ?? "",
                data.comment ?? ""
              ]);
            }
          }
        } else if (currentState is ReturnOrderInformationScreenError) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message, context);
          });
        }
        return _buildUI();
      }),
    );
  }

  Widget _buildUI() {
    return isLoading
        ? const Loader()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.size16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  returnDetail(),
                  productInformation(),
                  reasonForReturn(),
                  // if(dataList.isNotEmpty)
                  returnHistory(),
                ],
              ),
            ),
          );
  }

  Widget returnHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDivider(),
        Text(
          _localizations?.translate(AppStringConstant.returnHistory) ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        getDivider(),
        Container(
            /*  decoration: BoxDecoration(
                border: Border.all(color: AppColors.black)),*/
            child: CommonTable(dataList, heading))
      ],
    );
  }

  Widget returnDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _localizations?.translate(AppStringConstant.returnDetails) ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        getDivider(),
        getDetailRow(
            _localizations?.translate(AppStringConstant.returnId) ?? "",
            returnOrders?.returnId),
        getDetailRow(_localizations?.translate(AppStringConstant.orderId) ?? "",
            returnOrders?.orderId),
        getDetailRow(
            _localizations?.translate(AppStringConstant.dateAdded) ?? "",
            returnOrders?.dateAdded),
        getDetailRow(
            _localizations?.translate(AppStringConstant.dateOrdered) ?? "",
            returnOrders?.dateOrdered),
      ],
    );
  }

  Widget productInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDivider(),
        Text(
          _localizations?.translate(AppStringConstant.productInformation) ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        getDivider(),
        getDetailRow(
            _localizations?.translate(AppStringConstant.productName) ?? "",
            returnOrders?.product),
        getDetailRow(_localizations?.translate(AppStringConstant.model) ?? "",
            returnOrders?.model),
        getDetailRow(
            _localizations?.translate(AppStringConstant.quantity) ?? "",
            returnOrders?.quantity),
      ],
    );
  }

  Widget reasonForReturn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDivider(),
        Text(
          _localizations?.translate(AppStringConstant.reasonForReturn) ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        getDivider(),
        getDetailRow(_localizations?.translate(AppStringConstant.reason) ?? "",
            returnOrders?.reason),
        getDetailRow(_localizations?.translate(AppStringConstant.opened) ?? "",
            returnOrders?.opened),
        getDetailRow(_localizations?.translate(AppStringConstant.comment) ?? "",
            returnOrders?.comment),
      ],
    );
  }

//---------Get Row-------------//
  Widget getDetailRow(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.size8),
      child: Row(
        children: [
          Expanded(child: Text(key)),
          Expanded(child: Text(value ?? "")),
        ],
      ),
    );
  }

//---------Get Divider-------------//
  Widget getDivider() {
    return Column(
      children: const [
        SizedBox(
          height: AppSizes.size8,
        ),
        Divider(
          height: 2,
          thickness: 2,
        ),
        SizedBox(
          height: AppSizes.size8,
        ),
      ],
    );
  }
}
