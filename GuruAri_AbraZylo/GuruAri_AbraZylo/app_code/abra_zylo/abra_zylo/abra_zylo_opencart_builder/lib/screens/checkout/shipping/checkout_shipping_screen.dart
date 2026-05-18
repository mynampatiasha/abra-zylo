import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/checkout/checkout_payment_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_method_model.dart';
import 'package:oc_demo/screens/checkout/shipping/widgets/checkout_shipping_details_widgets.dart';
import 'package:oc_demo/screens/checkout/shipping/widgets/empty_shipping_view.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/app_bar.dart';
import '../../../common_widgets/common_order_button.dart';
import '../../../common_widgets/loader.dart';
import '../../../common_widgets/lottie_animation.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/global_data.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import 'bloc/shipping_screen_bloc.dart';
import 'bloc/shipping_screen_event.dart';
import 'bloc/shipping_screen_state.dart';

class CheckoutShippingScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const CheckoutShippingScreen(this.arguments, {Key? key}) : super(key: key);

//guestShippingData
  @override
  CheckoutShippingScreenState createState() => CheckoutShippingScreenState();
}

class CheckoutShippingScreenState extends State<CheckoutShippingScreen> {
  late ShippingScreenBloc? _bloc;
  late AppLocalizations? _localizations;
  late bool _loading;
  bool isAPICalling = false;
  CheckoutPaymentAddressModel? checkoutBillingAddressModel;
  CheckoutShippingMethodModel? checkoutShippingMethodModel;
  CheckoutShippingAddressModel? checkoutShippingAddressModel;
  String? shippingComment = "";

  //for guest checkout case
  AddAddressRequest? guestShippingAddressRequest;
  String? shippingFunction = "";
  bool? isGuestCheckout;
  String? guestAddress;

  @override
  void initState() {
    guestShippingAddressRequest = widget.arguments?[guestShippingData];
    shippingFunction = widget.arguments?[guestShippingFunction];
    isGuestCheckout = widget.arguments?["isGuestCheckout"];
    guestAddress = widget.arguments?["isGuestAddress"];
    _bloc = context.read<ShippingScreenBloc>();
    if (isGuestCheckout == false) {
      _bloc?.add(const PaymentOrBillingAddressEvent());
    } else {
      _bloc?.add(GuestShippingMethodEvent(
          addAddressRequest: guestShippingAddressRequest ?? AddAddressRequest(),
          function: shippingFunction ?? ""));
    }
    _loading = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        AppStringConstant.shipping.localized(),
        context,
      ),
      body: BlocBuilder<ShippingScreenBloc, ShippingScreenState>(
        builder: (context, currentState) {
          if ((currentState is ShippingLoadingState) ||
              (currentState is ShippingInitialState)) {
            _loading = true;
          } else if (currentState is FetchBillingAddressState) {
            checkoutBillingAddressModel = currentState.model;
            //   _loading = false;
            AppSharedPref.setBillingAddressId(
                checkoutBillingAddressModel?.paymentAddress?.addressId ?? "");
            if ((checkoutBillingAddressModel?.paymentAddress?.addressId! !=
                    "0") &&
                checkoutBillingAddressModel?.paymentAddress != null &&
                checkoutBillingAddressModel?.shippingRequired == true) {
              _bloc?.add(const ShippingLoadingEvent());
              _bloc?.add(const GetShippingAddressEvent());
            } else {
              _loading = false;
            }
          } else if (currentState is FetchCheckoutShippingMethodState) {
            _loading = false;
            checkoutShippingMethodModel = currentState.model;
          } else if (currentState is GuestShippingMethodState) {
            _loading = false;
            checkoutShippingMethodModel = currentState.model;
          } else if (currentState is FetchShippingAddressState) {
            checkoutShippingAddressModel = currentState.model;

            if ((checkoutShippingAddressModel?.shippingAddress?.addressId ??
                    0) ==
                "0") {
              AppSharedPref.getBillingAddressId().then((value) {
                AppSharedPref.setShippingAddressId(value);
                _bloc?.add(const GetCheckoutShippingMethodEvent());
              });
            } else {
              AppSharedPref.setShippingAddressId(
                  checkoutShippingAddressModel?.shippingAddress?.addressId ??
                      "");
              _bloc?.add(const GetCheckoutShippingMethodEvent());
            }
          } else if (currentState is ShippingScreenError) {
            _loading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(currentState.message ?? '', context);
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
            visible: _loading == false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // use this condition to allign view on top or centre
                if (isGuestCheckout == true) ...[
                  Expanded(
                    child: shippingScreenView(),
                  ),
                ] else ...[
                  Expanded(
                    child: shippingScreenView(),
                  ),
                ],

                commonOrderButton(
                  context,
                  _localizations,
                  GlobalData.cartTotal,
                  () async {
                    if (((checkoutBillingAddressModel
                                    ?.paymentAddress?.addressId! ==
                                "0") &&
                            checkoutShippingAddressModel?.shippingAddress ==
                                null) // if payment address is not null but adrees id is 0 means there is no address of user it is new created user so no need to show error

                        ) {
                      WidgetsBinding.instance
                          ?.addPostFrameCallback((timeStamp) {
                        AlertMessage.showWarning(
                            AppStringConstant.pleaseAddAddress.localized(),
                            context);
                      });
                      return;
                    } else if ((await AppSharedPref.getSelectedShippingId())
                            .isEmpty &&
                        ((checkoutBillingAddressModel != null &&
                                    checkoutBillingAddressModel
                                            ?.shippingRequired ==
                                        true) ||
                                (checkoutShippingMethodModel != null &&
                                    checkoutShippingMethodModel
                                            ?.shippingRequired ==
                                        true)) ==
                            true) {
                      WidgetsBinding.instance
                          ?.addPostFrameCallback((timeStamp) {
                        AlertMessage.showWarning(
                            AppStringConstant.selectShippingMethod.localized(),
                            context);
                      });
                      return;
                    }
                    Navigator.of(context).pushNamed(AppRoute.orderReview,
                        arguments: orderReviewScreenMap(
                            shippingComment ?? "",
                            isGuestCheckout == true
                                ? (checkoutShippingMethodModel
                                        ?.shippingRequired ??
                                    false)
                                : (checkoutBillingAddressModel
                                        ?.shippingRequired ??
                                    true),
                            isGuestCheckout ?? false,
                            checkoutShippingMethodModel
                                    ?.shippingMethods?.paymentMethodList ??
                                []));
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: _loading,
            child: Loader(),
          ),
        ],
      );

  Widget shippingScreenView() {
    return (checkoutBillingAddressModel?.paymentAddress != null &&
            checkoutBillingAddressModel?.paymentAddress?.addressId! != "0" &&
            checkoutBillingAddressModel?.shippingRequired == false)
        ? SingleChildScrollView(
            child: ShippingView(
                checkoutShippingAddressModel: checkoutShippingAddressModel,
                checkoutShippingMethodModel: checkoutShippingMethodModel,
                checkoutBillingAddressModel: checkoutBillingAddressModel,
                updateCarrier: (value) async {
                  _bloc?.add(const ShippingLoadingEvent());
                  if (value) {
                    /// true means billing address have change.
                    _bloc?.add(const GetShippingAddressEvent());
                  } else {
                    _bloc?.add(const GetCheckoutShippingMethodEvent());
                  }
                },
                onAddAddressSuccess: (value) {
                  if (value) {
                    _bloc?.add(const ShippingLoadingEvent());
                    _bloc?.add(const PaymentOrBillingAddressEvent());
                  }
                },
                comment: (value) {
                  shippingComment = value;
                },
                isGuestCheckout: isGuestCheckout,
                shippingRequired: checkoutBillingAddressModel?.shippingRequired,
                savedAddress: guestAddress),
          )
        : ((checkoutBillingAddressModel?.paymentAddress == null &&
                    isGuestCheckout ==
                        false) //if payment address show error (not for guest shipping)
                ||
                (checkoutBillingAddressModel?.paymentAddress?.addressId! !=
                        "0" &&
                    checkoutShippingAddressModel?.shippingAddress == null &&
                    isGuestCheckout ==
                        false) // if payment address is not null but adrees id is 0 means there is no address of user it is new created user so no need to show error
            /*((checkoutBillingAddressModel?.paymentAddress == null
                                || checkoutShippingAddressModel?.shippingAddress == null)
                                && isGuestCheckout == false)*/
            ) //if end

            ? Center(
                child: EmptyShippingView(
                  (value) {
                    if (value) {
                      _bloc?.add(const ShippingLoadingEvent());
                      if (isGuestCheckout == true) {
                        _bloc?.add(GuestShippingMethodEvent(
                            addAddressRequest: guestShippingAddressRequest ??
                                AddAddressRequest(),
                            function: shippingFunction ?? ""));
                      } else {
                        _bloc?.add(const PaymentOrBillingAddressEvent());
                      }
                    }
                  },
                  _localizations,
                ),
              ) //else
            : (checkoutBillingAddressModel?.paymentAddress != null &&
                    (checkoutBillingAddressModel?.paymentAddress?.addresses ==
                            null ||
                        checkoutBillingAddressModel
                                ?.paymentAddress?.addresses?.length ==
                            0) &&
                    isGuestCheckout == false)
                ? //iff
                Center(
                    child: LottieAnimation(
                      lottiePath: AppImages.emptyAddressLottie,
                      title: _localizations
                              ?.translate(AppStringConstant.noAddress) ??
                          "",
                      subtitle: _localizations
                              ?.translate(AppStringConstant.noAddressMessage) ??
                          "",
                      buttonTitle: _localizations
                              ?.translate(AppStringConstant.addNewAddress) ??
                          "",
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoute.addEditAddress)
                            .then((value) {
                          if (value == true) {
                            _bloc?.add(const ShippingLoadingEvent());
                            _bloc?.add(const PaymentOrBillingAddressEvent());
                          }
                        });
                      },
                    ),
                  )
                : SingleChildScrollView(
                    child: ShippingView(
                        checkoutShippingAddressModel:
                            checkoutShippingAddressModel,
                        checkoutShippingMethodModel:
                            checkoutShippingMethodModel,
                        checkoutBillingAddressModel:
                            checkoutBillingAddressModel,
                        updateCarrier: (value) async {
                          _bloc?.add(const ShippingLoadingEvent());
                          if (value) {
                            /// true means billing address have change.
                            _bloc?.add(const GetShippingAddressEvent());
                          } else {
                            _bloc?.add(const GetCheckoutShippingMethodEvent());
                          }
                        },
                        onAddAddressSuccess: (value) {
                          if (value) {
                            _bloc?.add(const ShippingLoadingEvent());
                            _bloc?.add(const PaymentOrBillingAddressEvent());
                          }
                        },
                        comment: (value) {
                          shippingComment = value;
                        },
                        isGuestCheckout: isGuestCheckout,
                        shippingRequired: isGuestCheckout == true
                            ? checkoutShippingMethodModel?.shippingRequired
                            : checkoutBillingAddressModel?.shippingRequired ??
                                true,
                        savedAddress: guestAddress),
                  );
  }
}
