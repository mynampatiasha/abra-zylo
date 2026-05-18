import 'package:flutter/material.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../utils/helper.dart';
import '../bloc/cart_screen_bloc.dart';

class CartScreenVoucherWidget extends StatefulWidget {
  const CartScreenVoucherWidget(this.bloc, this.localizations, {Key? key})
      : super(key: key);

  final CartScreenBloc? bloc;
  final AppLocalizations? localizations;

  @override
  State<CartScreenVoucherWidget> createState() =>
      _CartScreenVoucherWidgetState();
}

class _CartScreenVoucherWidgetState extends State<CartScreenVoucherWidget> {
  late TextEditingController voucherTextController;
  double buttonPadding = 16.0;
  @override
  void initState() {
    voucherTextController = TextEditingController(text: "");
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
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        color: Theme.of(context).cardColor,
        // color: Colors.white,
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
              child: ExpansionTile(
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size8),
                initiallyExpanded: true,
                title: Text(
                    widget.localizations
                            ?.translate(AppStringConstant.voucherCode) ??
                        "",
                    style: TextStyle(
                        fontSize: AppSizes.size14,
                        color:
                            Theme.of(context).textTheme.headlineMedium!.color,
                        fontWeight: FontWeight.w700)),
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Divider(
                      color: AppColors.darkGray,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            style: const TextStyle(fontSize: AppSizes.size14),
                            controller: voucherTextController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(
                                  AppSizes.size16,
                                  AppSizes.size4,
                                  AppSizes.size4,
                                  AppSizes.size4),
                              hintText: widget.localizations?.translate(
                                      AppStringConstant.enterVoucherCode) ??
                                  "",
                              hintStyle: TextStyle(
                                fontSize: AppSizes.size12,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .color,
                              ),
                              border: const OutlineInputBorder(
                                  //  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                              focusedBorder: const OutlineInputBorder(
                                  //  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                              disabledBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                              enabledBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                color: AppColors.darkGray,
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                            //   backgroundColor: Theme.of(context).textTheme.titleLarge?.color,
                            //     padding: EdgeInsets.symmetric( vertical: buttonPadding),
                            //     // shape: RoundedRectangleBorder(
                            //     //     borderRadius: BorderRadius.zero
                            //     // ),
                            //     surfaceTintColor: AppColors.black),
                            onPressed: () async {
                              var voucher = voucherTextController.text;

                              if (voucher != "") {
                                Helper.hideSoftKeyBoard();
                                widget.bloc?.add(ApplyVoucherEvent(voucher));
                                widget.bloc?.emit(CartScreenStateInitial());
                                voucherTextController.text = "";
                              } else {
                                AlertMessage.showError(
                                    widget.localizations?.translate(
                                            AppStringConstant
                                                .pleaseEnterVoucherCode) ??
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
                  ),

                  //    SizedBox(height:8)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
