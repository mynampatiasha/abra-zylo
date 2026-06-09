import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:oc_demo/models/checkout/checkout_payment_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_method_model.dart';

import '../../../../common_widgets/bottom_sheet.dart';
import '../../../../common_widgets/common_tool_bar.dart';
import '../../../../common_widgets/title_separated_card.dart';
import '../../../../common_widgets/widget_space.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../helper/app_shared_pref.dart';
import '../../../cart/widgets/cart_icon_button.dart';
import 'checkout_shipping_change_address.dart';

class ShippingView extends StatefulWidget {
  ShippingView({
    required this.checkoutShippingAddressModel,
    required this.checkoutShippingMethodModel,
    required this.checkoutBillingAddressModel,
    required this.updateCarrier,
    required this.onAddAddressSuccess,
    this.isGuestCheckout,
    this.comment,
    this.shippingRequired,
    this.savedAddress = "",
    Key? key,
  }) : super(key: key);

  final CheckoutShippingAddressModel? checkoutShippingAddressModel;
  final CheckoutShippingMethodModel? checkoutShippingMethodModel;
  final CheckoutPaymentAddressModel? checkoutBillingAddressModel;
  final ValueChanged<bool> updateCarrier;
  final ValueChanged<bool> onAddAddressSuccess;
  final Function(String)? comment;
  bool? isGuestCheckout;
  bool? shippingRequired;
  String? savedAddress;

  @override
  State<ShippingView> createState() => _ShippingViewState();
}

class _ShippingViewState extends State<ShippingView> {
  String? selectedShippingAddressId = "";
  String? selectedBillingAddressId = "";
  String? selectedShippingMethodId = "";
  bool _checked = true;
  AppLocalizations? localizations;

  @override
  void initState() {
    /* _checked = true;*/
    AppSharedPref.isShippingAddressSameAsBilling().then((value) {
      _checked = value;
      getShippingAndBillingAddressID();
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if ((widget.isGuestCheckout ?? false) ==
            false /*widget.checkoutShippingMethodModel?.account!="guest"*/) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
            child: Card(
                color: Theme.of(context).cardColor, child: _shippingCard(0)),
          ),
          // Billing Address
          if ((widget.checkoutBillingAddressModel?.shippingRequired == null ||
              widget.checkoutBillingAddressModel?.shippingRequired ==
                  true)) ...[
            TitleSeparatedCard(
              (localizations?.translate(AppStringConstant.shippingAddress) ??
                  ""),
              Padding(
                padding: const EdgeInsets.all(AppSizes.size8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          (localizations?.translate(
                                  AppStringConstant.sameAsBilling) ??
                              ""),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        // Switch(
                        //   activeColor: Colors.white,
                        //   activeTrackColor: Colors.black,
                        //   inactiveTrackColor: Colors.black,
                        //   onChanged: (bool value) {
                        //     setState(() {
                        //       _checked = value;
                        //       AppSharedPref.setShippingAddressSameAsBilling(
                        //           value);
                        //       if (_checked == true) {
                        //         selectedShippingAddressId =
                        //             selectedBillingAddressId;
                        //         AppSharedPref.setShippingAddressId(
                        //             selectedBillingAddressId ?? "");
                        //         widget.updateCarrier(false);
                        //       }
                        //     });
                        //   },
                        //   value: _checked,
                        // ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: FlutterSwitch(
                            width: 50.0,
                            height: 25.0,
                            toggleSize: 20.0,
                            activeColor: Colors.black,
                            inactiveColor: Colors.white,
                            activeToggleColor: Colors.white,
                            inactiveToggleColor: Colors.black,
                            onToggle: (bool value) {
                              setState(() {
                                _checked = value;
                                AppSharedPref.setShippingAddressSameAsBilling(
                                    value);
                                if (_checked == true) {
                                  selectedShippingAddressId =
                                      selectedBillingAddressId;
                                  AppSharedPref.setShippingAddressId(
                                      selectedBillingAddressId ?? "");
                                  widget.updateCarrier(false);
                                }
                              });
                            },
                            value: _checked,
                          ),
                        ),
                      ],
                    ),
                    if (!_checked) _shippingCard(1),
                  ],
                ),
              ),
            ),
            if (widget.shippingRequired == true) ...[
              _shippingMethod(),
              // TitleSeparatedCard(
              //   (localizations?.translate(AppStringConstant.comment) ?? ""),
              //   Padding(
              //     padding:
              //         const EdgeInsets.only(bottom: 8.0, right: 10, left: 10),
              //     child: TextField(
              //       onChanged: widget.comment,
              //       decoration: InputDecoration(
              //         contentPadding: const EdgeInsets.symmetric(
              //           vertical: AppSizes.size4,
              //           horizontal: AppSizes.size8,
              //         ),
              //         hintText:
              //             localizations?.translate(AppStringConstant.comment) ??
              //                 "",
              //         hintStyle: const TextStyle(fontSize: AppSizes.size12),
              //         border:
              //             const OutlineInputBorder(gapPadding: AppSizes.size0),
              //       ),
              //     ),
              //   ),
              //   showDivider: false,
              //   asCard: false,
              // )
            ]
          ],
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
            child: Card(child: guestShipping(widget.savedAddress)),
          ),
          if (widget.shippingRequired == true) ...[
            _shippingMethod(),
            TitleSeparatedCard(
              (localizations?.translate(AppStringConstant.shippingComment) ??
                  ""),
              TextField(
                onChanged: widget.comment,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSizes.size4,
                    horizontal: AppSizes.size8,
                  ),
                  hintText:
                      localizations?.translate(AppStringConstant.comment) ?? "",
                  hintStyle: const TextStyle(fontSize: AppSizes.size12),
                  border: const OutlineInputBorder(gapPadding: AppSizes.size0),
                ),
              ),
            )
          ]
        ],
      ],
    );
  }

/*addShippingMethodView(){

}*/
  getShippingAndBillingAddressID() {
    if (_checked == true) {
      AppSharedPref.getBillingAddressId().then((value) {
        setState(() {
          selectedBillingAddressId = value;
          selectedShippingAddressId = value;
        });
      });
    } else {
      AppSharedPref.getShippingAddressId().then((value) {
        setState(() {
          selectedShippingAddressId = value;
        });
      });

      AppSharedPref.getBillingAddressId().then((value) {
        setState(() {
          selectedBillingAddressId = value;
        });
      });
    }
    //to get selected shipping method
    AppSharedPref.getSelectedShippingId().then((value) {
      setState(() {
        selectedShippingMethodId = value;
      });
    });
  }

  String getSelectedAddress(int type) {
    var address = "";
    if (type == 0) {
      if (selectedBillingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddBillingAddress) ??
            "";
      } else {
        widget.checkoutBillingAddressModel?.paymentAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedBillingAddressId) {
            address = element.formatted ?? "";
          }
        });
      }
    } else {
      if (selectedShippingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddShippingAddress) ??
            "";
      } else {
        widget.checkoutShippingAddressModel?.shippingAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedShippingAddressId) {
            address = element.formatted ?? "";
          } /*
          else if(selectedShippingAddressId=="0" && selectedBillingAddressId!="0" && element.addressId == selectedBillingAddressId ){
          address = element.formatted ?? "";
        }
        */
          // });
        });
      }
    }

    print("pankaj " + address + selectedShippingAddressId!);
    return address;
  }

  Widget guestShipping(String? savedAddress) => Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.size8, vertical: AppSizes.size16),
            child: Text(
              localizations?.translate(AppStringConstant.guestShipping) ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(savedAddress ?? ""),
          )
        ],
      );

  Widget _shippingCard(int type) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (type == 0) // ) For billing address and 1 for shipping address
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.size8, vertical: AppSizes.size16),
              child: Text(
                type == 0
                    ? (localizations
                            ?.translate(AppStringConstant.billingAddress) ??
                        "")
                    : (localizations
                            ?.translate(AppStringConstant.shippingAddress) ??
                        ""),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          const SizedBox(
            height: 8,
          ),
          const Divider(height: 0),
          ListTile(
            title: Text(
              type == 0 ? getSelectedAddress(0) : getSelectedAddress(1),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: AppSizes.size14),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: AppSizes.size18,
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.all(AppSizes.size8),
            onTap: () async {
              var addressId = "";
              if (type == 0) {
                addressId = await AppSharedPref.getBillingAddressId();
              } else {
                addressId = await AppSharedPref.getShippingAddressId();
              }

              Navigator.of(context)
                  .pushNamed(AppRoute.addEditAddress,
                      arguments:
                          addressId == "0" ? null : {"addressId": addressId})
                  .then((value) {
                // var success = value["success"];
                if (value == true) {
                  widget.onAddAddressSuccess(true);
                } else {
                  widget.onAddAddressSuccess(false);
                }
              });
            },
          ),
          const Divider(height: 0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: CartIconButton(
                  leadingIcon: Icons.edit,
                  title: (localizations
                          ?.translate(AppStringConstant.changeAddress) ??
                      ""),
                  onClick: () async {
                    var result = await showMyModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => Scaffold(
                        appBar: commonToolBar(
                            (localizations?.translate(
                                    AppStringConstant.selectAddress) ??
                                ""),
                            context,
                            isElevated: true),
                        body: ChangeAddress(
                            localizations,
                            (type == 0)
                                ? widget
                                    .checkoutBillingAddressModel?.paymentAddress
                                : widget.checkoutShippingAddressModel
                                    ?.shippingAddress,
                            type,
                            _checked, onAddressUpdate: () {
                          getShippingAndBillingAddressID();
                        }),
                      ),
                    );
                    if (result != null) {
                      if (type == 0) {
                        widget.updateCarrier(true);
                      } else if (type == 1) {
                        widget.updateCarrier(false);
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: CartIconButton(
                  leadingIcon: Icons.add,
                  title:
                      (localizations?.translate(AppStringConstant.newAddress) ??
                          ""),
                  onClick: () {
                    Navigator.of(context)
                        .pushNamed(AppRoute.addEditAddress)
                        .then((value) {
                      if (value == true) {
                        widget.onAddAddressSuccess(true);
                      } else {
                        widget.onAddAddressSuccess(false);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );

  Widget _shippingMethod() => Card(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.size8, vertical: AppSizes.size16),
              child: Text(
                (localizations?.translate(AppStringConstant.shippingMethods) ??
                    ""),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 0),
            widget.checkoutShippingMethodModel?.shippingMethods == null
                ? Padding(
                    padding: const EdgeInsets.all(AppSizes.size16),
                    child: Text(
                      (localizations
                              ?.translate(AppStringConstant.noShippingMethod) ??
                          " No Shipping Method available"),
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => shippingMethodList(widget
                        .checkoutShippingMethodModel
                        ?.shippingMethods
                        ?.shippingMethodList?[index]
                        .quote),
                    separatorBuilder: (BuildContext context, int index) =>
                        widgetSpace(1, AppSizes.size8),
                    itemCount: widget.checkoutShippingMethodModel
                            ?.shippingMethods?.shippingMethodList?.length ??
                        0,
                  ),
          ],
        ),
      );

  Widget shippingMethodList(List<Quote>? quote) {
    // if(selectedShippingMethodId==""){
    //   selectedShippingMethodId = quote?[0].code;
    // }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = quote?[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSizes.size8),
              child: Text(
                "${item?.title}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile<String?>(
              contentPadding: const EdgeInsets.all(0),
              dense: true,
              visualDensity: const VisualDensity(horizontal: -4.0),
              title: Text(
                  quote?[index].title ??
                      "" + "  (" + (quote?[index].text!)! + ")",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: AppSizes.size16)),
              value: item?.code,
              groupValue: selectedShippingMethodId,
              onChanged: (value) async {
                setState(() {
                  selectedShippingMethodId = value;
                });
                await AppSharedPref.setSelectedShippingId(
                    selectedShippingMethodId ?? "");
              },
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: quote?.length ?? 0,
    );
  }
}
