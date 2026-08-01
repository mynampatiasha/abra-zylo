import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/common_tool_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/bloc/order_detail_screen_bloc.dart';
import 'package:oc_demo/screens/orderDetail/views/delivery_boy_info.dart';
import 'package:oc_demo/screens/orderDetail/views/order_heading_view.dart';
import 'package:oc_demo/screens/orderDetail/views/order_id_date_view.dart';
import 'package:oc_demo/screens/orderDetail/views/order_item_card.dart';
import 'package:oc_demo/screens/orderDetail/views/order_price_details.dart';
import 'package:oc_demo/screens/orderDetail/views/order_shipping_payment_info.dart';
import 'package:oc_demo/screens/addReview/add_review_screen.dart';
import 'package:oc_demo/screens/addReview/bloc/add_review_screen_bloc.dart';
import 'package:oc_demo/screens/addReview/bloc/add_review_screen_repository.dart';

class OrderDetails extends StatefulWidget {
  String orderId;

  OrderDetails(this.orderId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailState();
  }
}

class _OrderDetailState extends State<OrderDetails> {
  AppLocalizations? _localizations;
  bool isLoading = false;
  OrderDetailModel? _orderModel;
  OrderDetailsBloc? _orderBloc;

  @override
  void initState() {
    super.initState();

    _orderBloc = context.read<OrderDetailsBloc>();
    _orderBloc?.add(OrderDetailFetchEvent(widget.orderId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.itemOrdered) ?? "",
          context,
          isElevated: false),
      body: BlocBuilder<OrderDetailsBloc, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailInitial) {
            isLoading = true;
          } else if (state is OrderDetailSuccess) {
            isLoading = false;
            _orderModel = state.model;
          } else if (state is AddProductToCartStateSuccess) {
            isLoading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showSuccess(state.baseModel.message ?? '', context);
              Navigator.pushNamed(context, AppRoute.cart);
            });
          } else if (state is OrderDetailError) {
            isLoading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(state.message ?? '', context);
            });
          }
          return /*isLoading ? Loader() :*/ buildUI();
        },
      ),
    );
  }

  Widget buildUI() {
    return SafeArea(
      child: Stack(
        children: [
          if (_orderModel != null)
            Container(
              width: AppSizes.deviceWidth,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.mediumPadding),
                      topRight: Radius.circular(AppSizes.mediumPadding)),
                  border: Border.all(color: AppColors.background)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  orderIdContainer(context, _orderModel, _localizations),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          orderPlaceDateContainer(
                              context, _orderModel, _localizations),
                          if (['PENDING', 'PROCESSING'].contains((_orderModel?.histories?.isNotEmpty == true ? _orderModel!.histories!.last.status : '')?.toUpperCase()))
                            trackingStrip((_orderModel?.histories?.isNotEmpty == true ? _orderModel!.histories!.last.status : '') ?? ''),
                          const SizedBox(
                            height: AppSizes.normalPadding,
                          ),
                          orderedItemList(),
                          const SizedBox(
                            height: AppSizes.normalPadding,
                          ),
                          orderPriceDetails(_orderModel ?? OrderDetailModel(),
                              context, _localizations),
                          const SizedBox(
                            height: AppSizes.normalPadding,
                          ),
                          if (_orderModel?.shippingAddress?.isNotEmpty ==
                                  true ||
                              _orderModel?.paymentAddress?.isNotEmpty == true)
                            shippingPaymentInfo(
                                context, _localizations, _orderModel),
                          if (_orderModel?.boyId?.isNotEmpty == true &&
                              _orderModel?.boyName?.isNotEmpty == true) ...[
                            const SizedBox(
                              height: AppSizes.normalPadding,
                            ),
                            deliveryBoyInfo(
                                context, _localizations, _orderModel)
                          ]
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          Visibility(visible: isLoading, child: const Loader())
        ],
      ),
    );
  }

  Widget orderedItemList() {
    return orderHeaderLayout(
        context,
        '${_orderModel?.products?.length} ${_localizations?.translate(AppStringConstant.itemsOrdered)}',
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
          child: ListView.builder(
              itemCount: _orderModel?.products?.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    orderItemCard(
                        _orderModel?.products?[index] ?? OrderedProducts(),
                        context,
                        _localizations),
                    const Divider(
                      thickness: 1,
                      height: 1,
                    ),
                    actionContainer(
                      context,
                      () {
                        Navigator.of(context).pushNamed(
                          AppRoute.returnProduct,
                          arguments: getProductReturnMap(
                              _orderModel?.products?[index].productId ?? "",
                              _orderModel?.orderId ?? ""),
                        );
                      },
                      () {
                        _orderBloc?.add(ReorderProductEvent(
                            _orderModel?.orderId ?? "",
                            _orderModel?.products?[index].orderProductId ??
                                ""));
                        _orderBloc?.emit(OrderDetailInitial());
                      },
                      titleRight: _localizations
                          ?.translate(AppStringConstant.addToCart),
                      titleLeft: _localizations
                          ?.translate(AppStringConstant.returnOrder),
                      iconRight: Icons.add_shopping_cart,
                      iconLeft: Icons.assignment_return_outlined,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => AddReviewScreenBloc(repository: AddReviewRepositoryImp()),
                                  child: AddReviewScreen(
                                    _orderModel?.products?[index].name ?? '',
                                    '',
                                    _orderModel?.products?[index].productId ?? ""
                                  ),
                                )
                              )
                            );
                          },
                          icon: const Icon(Icons.star_border, size: 18),
                          label: const Text("Write a Review", style: TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFf4f0fb),
                            foregroundColor: const Color(0xFF5232a8),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      thickness: 1,
                      height: 1,
                    ),
                  ],
                );
              }),
        ));
  }
  
  Widget trackingStrip(String status) {
    bool isProcessing = status.toUpperCase() == 'PROCESSING';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Shipment Progress", style: TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF2b2540))),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTrackStep("Pending", true),
              Expanded(child: Container(height: 2, color: isProcessing ? const Color(0xFF5232a8) : const Color(0xFFece7f3))),
              _buildTrackStep("Processing", isProcessing),
              Expanded(child: Container(height: 2, color: const Color(0xFFece7f3))),
              _buildTrackStep("Shipped", false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackStep(String label, bool active) {
    return Column(
      children: [
        Container(
          width: 20, height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? const Color(0xFF5232a8) : Colors.white,
            border: Border.all(color: active ? const Color(0xFF5232a8) : const Color(0xFFece7f3), width: 2)
          ),
          child: active ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontFamily: 'Karla', fontSize: 11, color: active ? const Color(0xFF5232a8) : const Color(0xFF8f889c))),
      ],
    );
  }
}


Widget actionContainer(
    BuildContext context, VoidCallback leftCallback, VoidCallback rightCallback,
    {IconData? iconLeft,
    IconData? iconRight,
    String? titleLeft,
    String? titleRight}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
    child: Row(
      children: [
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: leftCallback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconLeft ?? Icons.edit,
                    size: AppSizes.size16,
                  ),
                  const SizedBox(
                    width: AppSizes.size4,
                  ),
                  Text((titleLeft ?? '').toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            )),
        Container(
          color: Colors.grey,
          height: AppSizes.size20,
          width: 1,
        ),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: rightCallback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconRight ?? Icons.add,
                    size: AppSizes.size16,
                  ),
                  const SizedBox(
                    width: AppSizes.size4,
                  ),
                  Text(
                      // _localizations?.translate(AppStringConstant.newAddress) ??
                      (titleRight ?? "").toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            )),
      ],
    ),
  );
}
