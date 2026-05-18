import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/cart/cart_model.dart';
import '../../../utils/helper.dart';
import '../bloc/cart_screen_bloc.dart';

class CartScreenRewardsWidget extends StatefulWidget {
  const CartScreenRewardsWidget(this.bloc, this.localizations, this.model,
      {Key? key})
      : super(key: key);

  final CartScreenBloc? bloc;
  final AppLocalizations? localizations;
  final CartModel? model;
  @override
  State<CartScreenRewardsWidget> createState() =>
      _CartScreenRewardsWidgetState();
}

class _CartScreenRewardsWidgetState extends State<CartScreenRewardsWidget> {
  late TextEditingController rewardTextController;
  double buttonPadding = 16.0;
  @override
  void initState() {
    rewardTextController = TextEditingController(text: "");
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
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          // padding: const EdgeInsets.only(left: AppSizes.size8,right: AppSizes.size8),
          padding: const EdgeInsets.only(bottom: AppSizes.size14),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListTileTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.size8),
              child: ExpansionTile(
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size8),
                initiallyExpanded: true,
                title: Text(widget.model?.reward?.headingTitle ?? "" ?? "",
                    style: const TextStyle(
                        fontSize: AppSizes.size14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w700)),
                children: <Widget>[
                  const Divider(
                    color: AppColors.darkGray,
                  ),
                  widgetSpace(0, 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.model?.reward?.entryReward ?? "" ?? ""),
                  ),
                  widgetSpace(0, 8),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: rewardTextController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(
                                  AppSizes.size16,
                                  AppSizes.size4,
                                  AppSizes.size4,
                                  AppSizes.size4),
                              hintText: widget.localizations?.translate(
                                      AppStringConstant.enterRewardsPoints) ??
                                  "",
                              hintStyle:
                                  const TextStyle(fontSize: AppSizes.size12),
                              border: const OutlineInputBorder(
                                  //  borderRadius: BorderRadius.all(Radius.zero),
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
                        const SizedBox(
                          width: AppSizes.size6,
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
                            //   backgroundColor: Theme.of(context).textTheme.titleLarge?.color,
                            //     padding: EdgeInsets.symmetric( vertical: buttonPadding),
                            //     // shape: RoundedRectangleBorder(
                            //     //     borderRadius: BorderRadius.zero
                            //     // ),
                            //     surfaceTintColor: AppColors.black),
                            onPressed: () async {
                              var reward = rewardTextController.text;
                              if (reward != "") {
                                Helper.hideSoftKeyBoard();
                                widget.bloc?.add(ApplyRewardEvent(reward));
                                widget.bloc?.emit(CartScreenStateInitial());
                                rewardTextController.text = "";
                              } else {
                                AlertMessage.showError(
                                    widget.localizations
                                            ?.translate(AppStringConstant
                                                .pleaseEnterReward)
                                            .toUpperCase() ??
                                        "",
                                    context);
                              }
                              // }
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
