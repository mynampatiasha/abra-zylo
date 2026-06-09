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
    // FORCE AUTO-SELECT FIRST SHIPPING METHOD
    if (widget.checkoutShippingMethodModel?.shippingMethods?.shippingMethodList?.isNotEmpty == true) {
      final methods = widget.checkoutShippingMethodModel!.shippingMethods!.shippingMethodList!;
      if (methods.isNotEmpty && methods[0].quote?.isNotEmpty == true) {
        if (selectedShippingMethodId == null || selectedShippingMethodId!.isEmpty) {
          selectedShippingMethodId = methods[0].quote![0].code;
          AppSharedPref.setSelectedShippingId(selectedShippingMethodId ?? "");
        }
      }
    }

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
            Visibility(
              visible: false, // Flipkart style: hide duplicate shipping address switch
              child: TitleSeparatedCard(
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
            ),
            if (widget.shippingRequired == true) ...[
              Visibility(
                visible: false, // Flipkart style: auto-select and hide shipping method
                child: _shippingMethod(),
              ),
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
            Visibility(
              visible: false,
              child: _shippingMethod(),
            ),
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

  Widget _shippingCard(int type) => Padding(
        padding: const EdgeInsets.all(AppSizes.size16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Deliver to:",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                InkWell(
                  onTap: () async {
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.size12, vertical: AppSizes.size6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(AppSizes.size4),
                    ),
                    child: Text(
                      "CHANGE",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.size12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.size12),
            Text(
              type == 0 ? getSelectedAddress(0) : getSelectedAddress(1),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: AppSizes.size14, height: 1.4),
            ),
          ],
        ),
      );

  Widget _shippingMethod() => Card(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.size16, vertical: AppSizes.size16),
              child: Text(
                "Delivery Options",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
    if ((selectedShippingMethodId == null || selectedShippingMethodId == "") && quote != null && quote.isNotEmpty) {
      selectedShippingMethodId = quote[0].code;
      AppSharedPref.setSelectedShippingId(selectedShippingMethodId ?? "");
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = quote?[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8, vertical: AppSizes.size4),
          child: RadioListTile<String?>(
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            activeColor: Theme.of(context).primaryColor,
            visualDensity: const VisualDensity(horizontal: -4.0),
            title: Text(
                (item?.title ?? "") + (item?.text != null ? "  (" + item!.text! + ")" : ""),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: AppSizes.size14, fontWeight: FontWeight.w500)),
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
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: quote?.length ?? 0,
    );
  }
}
