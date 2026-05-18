import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/common_order_button.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/order_complete.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/order_review_view.dart';
import 'package:oc_demo/screens/razor_pay_payment/razor_pay_payment_flow.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/app_bar.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import 'bloc/order_review_screen_bloc.dart';
import 'bloc/order_review_screen_event.dart';
import 'bloc/order_review_screen_state.dart';

class OrderReview extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const OrderReview(this.arguments, {Key? key}) : super(key: key);

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  late AppLocalizations? _localizations;
  late bool _loading;
  CheckoutPaymentMethodModel? _paymentMethods;
  CheckoutReviewOrderModel? checkoutReviewOrderModel;
  late OrderReviewScreenBloc _bloc;
  bool isPrivacyAccepted = false;
  String paymentComment = "";
  String shippingComment =
      ""; //shipping comment passing from shipping screen as argument
  bool isShippingRequired = true;
  bool? isGuestCheckout;

  @override
  void initState() {
    shippingComment = widget.arguments?[comment];
    isShippingRequired = widget.arguments?["isShippingRequired"];
    isGuestCheckout = widget.arguments?["isGuestCheckout"];
    // isGuestCheckout=widget.arguments?["isGuestCheckout"];
    _bloc = context.read<OrderReviewScreenBloc>();
    if (isShippingRequired == false && isGuestCheckout == true) {
      _paymentMethods = CheckoutPaymentMethodModel();
      _paymentMethods?.paymentMethods = PaymentMethods();
      _paymentMethods?.paymentMethods?.paymentMethodList =
          widget.arguments?["payment_method"];
      if ((_paymentMethods?.paymentMethods?.paymentMethodList?.length ?? 0) >
          0) {
        AppSharedPref.setSelectedPaymentId(
            _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ?? "");
        _bloc.add(const LoadingEvent());
        _bloc.add(OrderReviewEvent(
            _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ?? "",
            "",
            "0"));
      }
    } else if (isShippingRequired) {
      _bloc.add(PaymentMethodEvent(shippingComment));
    } else {
      _bloc.add(const PaymentMethodEventWhileShippingNotRequired());
    }
    _loading = true;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    _clearPaymentMethod();
    super.didChangeDependencies();
  }

  void _clearPaymentMethod() async {
    await AppSharedPref.setSelectedPaymentId("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        AppStringConstant.paymentAndReview.localized(),
        context,
      ),
      body: BlocBuilder<OrderReviewScreenBloc, OrderReviewScreenState>(
        builder: (context, currentState) {
          if ((currentState is InitialState) ||
              (currentState is OrderReviewLoadingState)) {
            _loading = true;
          } else if (currentState is OrderReviewState) {
            _loading = false;
            checkoutReviewOrderModel = currentState.model;
          } else if (currentState is PaymentMethodState) {
            _loading = false;
            _paymentMethods = currentState.model;
            if ((_paymentMethods?.paymentMethods?.paymentMethodList?.length ??
                    0) >
                0) {
              AppSharedPref.setSelectedPaymentId(
                  _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ??
                      "");
              _bloc.add(const LoadingEvent());
              _bloc.add(OrderReviewEvent(
                  _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ??
                      "",
                  "",
                  "0"));
            } else {
              AppSharedPref.setSelectedPaymentId("");
            }
            if (_paymentMethods?.paymentMethods?.errorWarning?.isNotEmpty ==
                true) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showError(
                    _paymentMethods?.paymentMethods?.errorWarning ?? '',
                    context);
              });
            }
          } else if (currentState is OrderPlaceState) {
            //AppSharedPref.setCartCount("0");
            SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => OrderComplete(
                      currentState.model.success?.textMessage ?? "",
                      currentState.model.orderId.toString() ?? ""),
                ),
              );
            });
          } else if (currentState is OrderReviewScreenError) {
            _loading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(currentState.message ?? '', context);
              _bloc.emit(EmptyState());
            });
          }
          return SafeArea(child: _buildUI());
        },
      ),
    );
  }

  Widget _buildUI() => Stack(
        children: <Widget>[
          Visibility(
            visible: _paymentMethods != null,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: OrderReviewView(
                      orderReviewModel: checkoutReviewOrderModel,
                      paymentMethod: _paymentMethods,
                      localizations: _localizations,
                      onPaymentMethodChange: () async {
                        _bloc.add(OrderReviewEvent(
                            await AppSharedPref.getSelectedPaymentId(),
                            paymentComment,
                            isPrivacyAccepted ? "1" : "0"));
                      },
                      isCheckboxSelected: (value) {
                        isPrivacyAccepted = value;
                      },
                      comment: (value) {
                        paymentComment = value;
                      },
                      isShippingRequired: isShippingRequired,
                      isGuestCheckout: isGuestCheckout,
                    ),
                  ),
                ),
                commonOrderButton(
                  context,
                  _localizations,
                  getTotalAmount(),
                  () async {
                    /* if ((await AppSharedPref.getSelectedPaymentId()).isEmpty) {
                      WidgetsBinding.instance
                          ?.addPostFrameCallback((timeStamp) {
                        AlertMessage.showWarning(
                            AppStringConstant.selectPaymentMethod.localized(), context);

                      });
                      return;
                    }*/
                    if (!isPrivacyAccepted) {
                      WidgetsBinding.instance
                          ?.addPostFrameCallback((timeStamp) {
                        AlertMessage.showWarning(
                            AppStringConstant.youMustAgreeToTermsAndCondition
                                .localized(),
                            context);
                      });
                      return;
                    }
                    _paymentMethods?.paymentMethods?.paymentMethodList
                        ?.forEach((element) async {
                      // print("element is ${element.code}");
                      if (element.code ==
                          (await AppSharedPref.getSelectedPaymentId())) {
                        if (element.code == "razorpay") {
                          /// Integrated payment method
                          //  checkoutReviewOrderModel
                          AbraRazorPay.instance.initRazorPay(
                              checkoutReviewOrderModel?.continu?.razorpay,
                              onError: (response) {
                            _bloc.emit(OrderReviewScreenError(
                                _localizations?.translate(
                                    AppStringConstant.paymentFailedMsg)));
                          }, onSuccess: (response) {
                            print(
                                "Here is the Success response ${response.data.toString()}");
                            _bloc.add(const LoadingEvent());
                            _bloc.add(OrderPlaceEvent("1",
                                response.data?["razorpay_payment_id"] ?? ""));
                          });
                        } else {
                          _bloc.add(const LoadingEvent());
                          _bloc.add(const OrderPlaceEvent("1", ""));
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: _loading,
            child: const Loader(),
          ),
        ],
      );

  /*
  *
  * return total amount
  * */
  getTotalAmount() {
    String? total = (checkoutReviewOrderModel?.continu?.totals?.length ?? 0) > 2
        ? (checkoutReviewOrderModel?.continu?.totals?[2].text ?? "0")
        : checkoutReviewOrderModel?.continu?.totals?[1].text ?? "0";
    checkoutReviewOrderModel?.continu?.totals?.forEach((element) {
      if (element.title == "total" ||
          element.title == "Total" ||
          element.title == "value") {
        total = element.text;
      }
    });
    return total;
  }
}
