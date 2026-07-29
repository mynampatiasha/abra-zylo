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

        // Update Shopping Cart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: InkWell(
            onTap: () {
              bloc?.add(CartUpdateEvent(getQuantityJson()));
              bloc?.emit(CartScreenStateInitial());
            },
            borderRadius: BorderRadius.circular(12),
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
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF673AB7).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.refresh_outlined, color: Color(0xFF673AB7), size: 20),
                ),
                title: Text(
                  localizations?.translate(AppStringConstant.updateShoppingCart) ?? "Update Shopping Cart",
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                ),
                subtitle: Text(
                  "Recalculate items and apply latest changes",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF673AB7)),
              ),
            ),
          ),
        ),

        // Empty Cart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: InkWell(
            onTap: () {
              confirmationDialog(
                  AppStringConstant.emptyCartText,
                  context,
                  localizations,
                  AppStringConstant.areYouSureTOEmptyCart, onConfirm: () {
                bloc?.add(const EmptyCartEvent());
                bloc?.emit(CartScreenStateInitial());
              });
            },
            borderRadius: BorderRadius.circular(12),
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
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete_forever_outlined, color: Colors.grey.shade700, size: 20),
                ),
                title: Text(
                  localizations?.translate(AppStringConstant.emptyCart) ?? "Empty Cart",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.grey.shade700),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
        /*
        * Continue shopping
        * onClick: move to homepage
        * */
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoute.bottomTabBAr,
                (route) => false,
              );
            },
            borderRadius: BorderRadius.circular(12),
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
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF673AB7).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF673AB7), size: 20),
                ),
                title: Text(
                  localizations?.translate(AppStringConstant.continueShopping) ?? "Continue Shopping",
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF673AB7)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

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
