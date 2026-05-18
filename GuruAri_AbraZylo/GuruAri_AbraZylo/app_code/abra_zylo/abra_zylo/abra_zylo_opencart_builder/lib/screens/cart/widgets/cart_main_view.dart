import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import 'package:oc_demo/screens/cart/widgets/cart_screen_coupon_widget.dart';
import 'package:oc_demo/screens/cart/widgets/cart_screen_rewards_widget.dart';
import 'package:oc_demo/screens/cart/widgets/cart_screen_voucher_widget.dart';
import 'package:oc_demo/screens/cart/widgets/price_details.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../bloc/cart_screen_bloc.dart';
import 'cart_icon_button.dart';
import 'cart_product_item.dart';

class CartMainView extends StatelessWidget {
  const CartMainView(this.model, this.localizations, this.bloc, {Key? key})
      : super(key: key);

  final CartModel? model;
  final AppLocalizations? localizations;
  final CartScreenBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // products list view
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.size16),
              child: Container(
                // color:Colors.red,
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size8, vertical: AppSizes.size8),
                      //Total product in cart view
                      child: Text(
                          "${model?.cart?.totalProducts} ${(localizations?.translate(AppStringConstant.items) ?? "").toUpperCase()}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .color,
                                  fontWeight: FontWeight.w600)),
                    ),
                    const Divider(thickness: AppSizes.size1),
                  ],
                ),
              ),
            ),

            //Cart product list view
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) => CartProductItem(
                  model?.cart?.products?[index], localizations, bloc),
              itemCount: (model?.cart?.products?.length ?? 0),
            ),
            /* GestureDetector(
              onTap:() {
                bloc?.add(const GetCountryDataEvent());
                bloc?.emit(CartScreenStateInitial());
              },
              child: Text(
                  "Estimat shipping and taxes "
                         ,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
*/
            //Cart Voucher View
            if (model?.cart?.voucherStatus == 1)
              CartScreenVoucherWidget(bloc, localizations),
            //cart coupon view
            if (model?.cart?.couponStatus == 1)
              CartScreenCouponWidget(bloc, localizations),
            //cart reward view
            if (model?.reward != null &&
                (model?.reward?.headingTitle?.isNotEmpty ?? false))
              CartScreenRewardsWidget(bloc, localizations, model),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 10),
          child: Container(
            decoration: BoxDecoration(
              // /color: Colors.red,
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: AppSizes.size10),
                  child: Container(
                    // width: MediaQuery.of(context).size.width*0.05,
                    // color: Colors.amber,
                    child: Image.asset(
                      "assets/icons/editbutton.png",
                      height: 22,
                      width: 18,
                      color: Theme.of(context).textTheme.headlineMedium!.color,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      bloc?.add(const GetCountryDataEvent());
                      bloc?.emit(CartScreenStateInitial());
                    },
                    child: Text(
                        localizations
                                ?.translate(
                                    AppStringConstant.estimateShippingTax)
                                .toUpperCase() ??
                            "",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .color,
                            fontSize: AppSizes.size12,
                            fontWeight: FontWeight.bold)))

                //assets/icons/
                // CartIconButton(
                //   // leadingIcon: Icons.edit_square,
                //   title: localizations
                //           ?.translate(AppStringConstant.estimateShippingTax)
                //           .toUpperCase() ??
                //       "",
                //   onClick: () {
                //     bloc?.add(const GetCountryDataEvent());
                //     bloc?.emit(CartScreenStateInitial());
                //   },
                // ),
              ],
            ),
          ),
        ),

        /*    Update cart Button
    * Onclick: cart will update
    * */

        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: CartIconButton(
              leadingIcon: Icons.update,
              title: localizations
                      ?.translate(AppStringConstant.updateShoppingCart)
                      .toUpperCase() ??
                  "",
              onClick: () {
                bloc?.add(CartUpdateEvent(getQuantityJson()));
                bloc?.emit(CartScreenStateInitial());
              },
            ),
          ),
        ),

        /*
        * Empty cart labelLarge view
        * on click: all product will remove from cart
        * */
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: CartIconButton(
              leadingIcon: Icons.delete_forever,
              title:
                  localizations?.translate(AppStringConstant.emptyCart) ?? "",
              onClick: () {
                confirmationDialog(
                    AppStringConstant.emptyCartText,
                    context,
                    localizations,
                    AppStringConstant.areYouSureTOEmptyCart, onConfirm: () {
                  bloc?.add(const EmptyCartEvent());
                  bloc?.emit(CartScreenStateInitial());
                });
              },
            ),
          ),
        ),
        /*
        * Continue shopping labelLarge view
        * onClick: move to homepage
        * */
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: CartIconButton(
              leadingIcon: Icons.arrow_forward,
              title: localizations
                      ?.translate(AppStringConstant.continueShopping) ??
                  "",
              onClick: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  /*MaterialPageRoute(
                            builder: (context) => const BottomTabbarWidget(),
                          ),*/
                  AppRoute.bottomTabBAr,
                  (route) => false,
                );
                // Navigator.pushNamed(context, navBar);
              },
            ),
          ),
        ),

        //Price details view
        PriceDetails(
          totals: model?.cart?.totals,
          localizations: localizations,
        ),
      ],
    );
  }

/*
*
* Method will return a json as a string of quantity as value and item/product id as key to update the cart.
* */
  String getQuantityJson() {
    Map<String, String> jsonMap = {};
    model?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] = element.quantity ?? "0";
    });
    return json.encode(jsonMap);
  }

  confirmationDialog(String text, BuildContext context,
      AppLocalizations? localizations, String subText,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // shape:  RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(0.0),
        // ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations?.translate(text) ?? "",
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: AppSizes.size16)),
            const SizedBox(
              height: AppSizes.size8,
            ),
            Text(localizations?.translate(subText) ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: AppSizes.size14)),
          ],
        ),

        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              AppStringConstant.cancel.localized().toUpperCase(),
              // style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: AppSizes.size14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStringConstant.ok.localized().toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white, fontSize: AppSizes.size14),
              ),
            ),
            style: OutlinedButton.styleFrom(

                // shape:RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(0.0),
                // ),
                backgroundColor: MobikulTheme.primaryColor),
          ),
        ],
      ),
    );
  }
}
