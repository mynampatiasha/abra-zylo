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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: false,
            iconColor: const Color(0xFF673AB7),
            collapsedIconColor: const Color(0xFF673AB7),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF673AB7).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.confirmation_number_outlined,
                color: Color(0xFF673AB7),
                size: 20,
              ),
            ),
            title: Text(
              widget.localizations?.translate(AppStringConstant.couponCode) ?? "Coupon Code",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: couponTextController,
                          decoration: InputDecoration(
                            hintText: widget.localizations?.translate(AppStringConstant.enterCoupanCode) ?? "Enter Coupon Code",
                            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF673AB7)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF673AB7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          var coupon = couponTextController.text;
                          if (coupon.isNotEmpty) {
                            Helper.hideSoftKeyBoard();
                            widget.bloc?.add(ApplyCouponEvent(coupon));
                            widget.bloc?.emit(CartScreenStateInitial());
                            couponTextController.text = "";
                          } else {
                            AlertMessage.showError(
                                widget.localizations?.translate(AppStringConstant.pleaseEnterCouponCode) ?? "",
                                context);
                          }
                        },
                        child: Text(
                          widget.localizations?.translate(AppStringConstant.apply) ?? "Apply",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
