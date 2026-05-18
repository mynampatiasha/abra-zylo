import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/checkout/checkout_guest_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_event.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_state.dart';
import 'package:oc_demo/screens/checkout/guest/guest_checkout_billing_address_form.dart';

import 'bloc/guest_checkout_bloc.dart';
import 'guest_Shipping_address_form.dart';

class GuestCheckoutAddressWidget extends StatefulWidget {
  const GuestCheckoutAddressWidget({super.key});

  @override
  State<GuestCheckoutAddressWidget> createState() =>
      _GuestCheckoutAddressWidgetState();
}

class _GuestCheckoutAddressWidgetState
    extends State<GuestCheckoutAddressWidget> {
  late bool _isLoading;
  bool? _checked;
  bool? _openScreenForShippingAddress;

  CheckoutGuestModel? checkoutGuestModel;
  CheckoutShippingAddressModel? checkoutShippingAddressModel;
  GuestCheckoutScreenBloc? _bloc;

  @override
  void initState() {
    _openScreenForShippingAddress = false;
    _checked = true;
    _isLoading = true;
    _bloc = context.read<GuestCheckoutScreenBloc>();

    _bloc?.add(const GuestCheckoutEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        AppStringConstant.guestCheckout.localized(),
        context,
      ),
      body: BlocBuilder<GuestCheckoutScreenBloc, GuestCheckoutScreenState>(
        builder: (context, state) {
          if (state is InitialState) {
            _isLoading = true;
          } else if (state is GuestCheckoutState) {
            _isLoading = false;
            checkoutGuestModel = state.model;
          } else if (state is GuestShippingAddressState) {
            _openScreenForShippingAddress = true;
            _isLoading = false;
            checkoutShippingAddressModel = state.model;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              /* setState(() {
              });*/
            });
          } else if (state is GuestCheckoutScreenStateError) {
            _isLoading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(state.message ?? '', context);
            });
          }
          return buildsUI();
        },
      ),
    );
  }

  Widget buildsUI() {
    return Stack(
      children: <Widget>[
        ((_openScreenForShippingAddress ?? false) == false)
            ? GuestCheckoutBillingAddressForm(
                (_openScreenForShippingAddress ?? false)
                    ? checkoutShippingAddressModel
                            ?.shippingAddress?.countryData ??
                        []
                    : checkoutGuestModel?.guestData?.countryData ?? [],
                (request, addressValue) {
                  if (_checked == true) {
                    //saveGuest
                    Navigator.of(context).pushNamed(AppRoute.shipping,
                        arguments: getShippingPageArgument(
                            request, AppConstant.saveGuest, true,
                            address: addressValue));
                  } else {
                    _bloc?.add(GuestShipppingEvent(
                        checkoutGuestModel?.shippingRequired == true
                            ? "1"
                            : "0",
                        request));
                    _bloc?.emit(const InitialState());
                    // _bloc?.add(const LoadingEvent());
                  }
                },
                (value) {
                  _checked = value;
                },
                _checked,
              )
            : GuestCheckoutShippingAddressForm(
                checkoutGuestModel?.guestData?.countryData ?? [],
                (request, addressValue) {
                Navigator.of(context).pushNamed(AppRoute.shipping,
                    arguments: getShippingPageArgument(
                        request, AppConstant.saveGuestShipping, true,
                        address: addressValue));
              }),
        Visibility(
          visible: _isLoading,
          child: const Loader(),
        ),
      ],
    );
  }
}
