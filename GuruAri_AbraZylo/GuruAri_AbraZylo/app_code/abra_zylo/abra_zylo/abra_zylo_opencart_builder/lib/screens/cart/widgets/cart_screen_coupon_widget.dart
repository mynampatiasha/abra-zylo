import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../utils/helper.dart';
import '../bloc/cart_screen_bloc.dart';

class CartScreenCouponWidget extends StatefulWidget {
  const CartScreenCouponWidget(this.bloc, this.localizations, {Key? key})
      : super(key: key);

  final CartScreenBloc? bloc;
  final AppLocalizations? localizations;

  @override
  State<CartScreenCouponWidget> createState() => _CartScreenCouponWidgetState();
}

class _CartScreenCouponWidgetState extends State<CartScreenCouponWidget> {
  late TextEditingController couponTextController;
  double buttonPadding = 16.0;

  @override
  void initState() {
    couponTextController = TextEditingController(text: "");
    AppSharedPref.getLanguage().then((value) {
      if (value == "ar") {
        buttonPadding = 11.0;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: AppSizes.size8, right: AppSizes.size8),
      child: Card(
        // color: Colors.red,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: AppSizes.size14,
              left: AppSizes.size8,
              right: AppSizes.size8),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              listTileTheme: ListTileTheme.of(context).copyWith(
                dense: true,
              ),
            ),
            child: ListTileTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.size8),
              minVerticalPadding: 2,
              child: ExpansionTile(
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size8),
                initiallyExpanded: true,
                title: Text(
                    widget.localizations
                            ?.translate(AppStringConstant.couponCode) ??
                        "",
                    style: TextStyle(
                        fontSize: AppSizes.size14,
                        color:
                            Theme.of(context).textTheme.headlineMedium!.color,
                        fontWeight: FontWeight.w700)),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: const Divider(
                      color: AppColors.darkGray,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        const Divider(
                          color: AppColors.darkGray,
                        ),
                        widgetSpace(0, 8),
                        Expanded(
                          child: TextField(
                            controller: couponTextController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(
                                  AppSizes.size16,
                                  AppSizes.size4,
                                  AppSizes.size4,
                                  AppSizes.size4),
                              hintText: widget.localizations?.translate(
                                      AppStringConstant.enterCoupanCode) ??
                                  "",
                              hintStyle: TextStyle(
                                fontSize: AppSizes.size12,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .color,
                              ),
                              border: const OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                              focusedBorder: const OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                              disabledBorder: const OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                              enabledBorder: const OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: AppSizes.deviceWidth / 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                            // style: ElevatedButton.styleFrom(
                            //     backgroundColor: Theme.of(context).textTheme.titleLarge?.color,
                            //     padding: EdgeInsets.symmetric( vertical: buttonPadding),
                            //     // shape: RoundedRectangleBorder(
                            //     //     borderRadius: BorderRadius.zero
                            //     // ),
                            //     surfaceTintColor: AppColors.black),
                            onPressed: () async {
                              var coupon = couponTextController.text;
                              if (coupon != "") {
                                Helper.hideSoftKeyBoard();
                                widget.bloc?.add(ApplyCouponEvent(coupon));
                                widget.bloc?.emit(CartScreenStateInitial());
                                couponTextController.text = "";
                              } else {
                                AlertMessage.showError(
                                    widget.localizations?.translate(
                                            AppStringConstant
                                                .pleaseEnterCouponCode) ??
                                        "",
                                    context);
                              }
                            },
                            child: Text(
                              widget.localizations
                                      ?.translate(AppStringConstant.apply) ??
                                  "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
