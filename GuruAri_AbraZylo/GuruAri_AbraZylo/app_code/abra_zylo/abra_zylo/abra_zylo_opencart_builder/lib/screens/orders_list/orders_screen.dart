import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/orderListModel/order_list_model.dart';
import 'package:oc_demo/screens/orders_list/views/order_item_list.dart';
import 'package:oc_demo/screens/orders_list/views/order_main_view.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/lottie_animation.dart';
import '../../helper/app_localizations.dart';
import '../../helper/open_bottom_model_sheet_helper.dart';
import 'bloc/order_screen_bloc.dart';
import 'bloc/order_screen_events.dart';
import 'bloc/order_screen_state.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen(this.isFromDashboard, {Key? key}) : super(key: key);
  bool isFromDashboard = false;

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations? _localizations;
  OrderScreenBloc? _orderScreenBloc;
  bool isLoading = false;
  bool isFromPagination = false;
  OrderListModel? orderList;
  List<OrderListData> recentOrders = [];
  int page = 1;
  String wkToken = "";

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _orderScreenBloc = context.read<OrderScreenBloc>();
    AppSharedPref.getWkToken().then((value) {
      wkToken = value;
      _orderScreenBloc
          ?.add(OrderScreenDataFetchEvent(wkToken, page.toString()));
    });
    _scrollController.addListener(() {
      if (!widget.isFromDashboard) paginationFunction();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.isFromDashboard)
          ? null
          : commonToolBar(
              _localizations?.translate(AppStringConstant.allOrders) ?? '',
              context),
      body: BlocBuilder<OrderScreenBloc, OrderScreenState>(
          builder: (context, currentState) {
        if (currentState is OrderScreenInitial) {
          if (!isFromPagination) {
            isLoading = true;
          }
        } else if (currentState is OrderScreenSuccess) {
          isLoading = false;
          isFromPagination = false;
          orderList = currentState.orders;
          if (page == 1) {
            recentOrders = orderList?.orderData ?? [];
          } else {
            recentOrders.addAll(orderList?.orderData ?? []);
          }
        } else if (currentState is OrderScreenError) {
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message, context);
          });
        } else if (currentState is OrderDetailsSuccess) {
          isLoading = false;
          Future.delayed(Duration.zero, () {
            if ((currentState.data.products?.length ?? 0) > 1) {
              orderItemList(
                  context, currentState.data.products ?? [], _localizations);
            } else {
              reviewBottomModalSheet(
                  context,
                  currentState.data.products?.first.name ?? '',
                  '',
                  currentState.data.products?.first.productId ?? "");
            }
          });
        }
        return _buildUI();
      }),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        if (recentOrders.isNotEmpty)
          orderMainView(context, recentOrders, _localizations, (orderId) {
            _orderScreenBloc?.add(OrderDetailsFetchEvent(orderId));
          }, _scrollController,
              scrollPhysics: widget.isFromDashboard
                  ? const AlwaysScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics()),
        Visibility(
          visible: (recentOrders.isEmpty && (!isLoading)),
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

  void paginationFunction() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        (orderList?.orderTotals ?? 0) != recentOrders.length) {
      setState(() {
        var totalPages = (int.parse(orderList?.orderTotals ?? "10") / 10);
        if (page < totalPages) {
          page++;
          if (!(widget.isFromDashboard)) {
            _orderScreenBloc
                ?.add(OrderScreenDataFetchEvent(wkToken, page.toString()));
          }
          isFromPagination = true;
        }
      });
    }
  }
}
