import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/returnOrderListModel/return_order_list_model.dart';
import 'package:oc_demo/screens/returnOrderList/bloc/return_order_screen_bloc.dart';
import 'package:oc_demo/screens/returnOrderList/bloc/return_order_screen_events.dart';
import 'package:oc_demo/screens/returnOrderList/bloc/return_order_screen_state.dart';
import 'package:oc_demo/screens/returnOrderList/views/return_main_view.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/lottie_animation.dart';
import '../../helper/app_localizations.dart';

class ReturnOrderScreen extends StatefulWidget {
  ReturnOrderScreen({Key? key}) : super(key: key);

  @override
  _ReturnOrderScreenState createState() => _ReturnOrderScreenState();
}

class _ReturnOrderScreenState extends State<ReturnOrderScreen> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations? _localizations;
  ReturnOrderScreenBloc? _ReturnOrderScreenBloc;
  bool isLoading = false;
  bool isFromPagination = false;
  ReturnOrderListModel? returnOrders;
  List<ReturnListData> returnOrdersList = [];
  int page = 1;
  String wkToken = "";

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _ReturnOrderScreenBloc = context.read<ReturnOrderScreenBloc>();
    AppSharedPref.getWkToken().then((value) {
      wkToken = value;
      _ReturnOrderScreenBloc?.add(
          ReturnOrderScreenDataFetchEvent(page.toString()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.returnn) ?? '', context),
      body: BlocBuilder<ReturnOrderScreenBloc, ReturnOrderScreenState>(
          builder: (context, currentState) {
        if (currentState is ReturnOrderScreenInitial) {
          if (!isFromPagination) {
            isLoading = true;
          }
        } else if (currentState is ReturnOrderScreenSuccess) {
          print("---> success");
          isLoading = false;
          isFromPagination = false;
          returnOrders = currentState.returns;
          if (page == 1) {
            returnOrdersList = returnOrders?.returnData ?? [];
          } else {
            returnOrdersList.addAll(returnOrders?.returnData ?? []);
          }
        } else if (currentState is ReturnOrderScreenError) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message, context);
            print("---> Error");
          });
        }
        return _buildUI();
      }),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        if (returnOrdersList.isNotEmpty)
          returnMainView(
              context, returnOrdersList, _localizations, _scrollController,
              scrollPhysics: const AlwaysScrollableScrollPhysics()),
        Visibility(
          visible: (returnOrdersList.isEmpty && (!isLoading)),
          child: Center(
            child: LottieAnimation(
                lottiePath: AppImages.emptyOrderLottie,
                title:
                    _localizations?.translate(AppStringConstant.noOrders) ?? "",
                subtitle: _localizations
                        ?.translate(AppStringConstant.noOrdersMessage) ??
                    "",
                buttonTitle: _localizations
                        ?.translate(AppStringConstant.continueShopping) ??
                    '',
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.bottomTabBAr, (route) => false);
                }),
          ),
        ),
        Visibility(visible: isLoading, child: Loader())
      ],
    );
  }
}
