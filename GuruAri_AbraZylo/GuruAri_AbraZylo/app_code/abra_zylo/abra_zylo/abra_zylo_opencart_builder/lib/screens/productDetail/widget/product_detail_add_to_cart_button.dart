import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_state.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../../../constants/app_constants.dart';
import '../../../common_widgets/alert_message.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../helper/generic_methods.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';

class ProductDetailAddToCartButtonWidget extends StatelessWidget {
  AppLocalizations? _localizations;
  ProductDetailBloc? productPageBloc;
  String productId;
  int quantity;
  Map<String, dynamic>? selectedProductOptions;
  List<Option>? productOptions;
  bool isAddedToCart;

  ProductDetailAddToCartButtonWidget(this.productPageBloc, this.productId,
      this.quantity, this.selectedProductOptions, this.productOptions,
      {this.isAddedToCart = false, Key? key});

  @override
  Widget build(BuildContext context) {
    _localizations = AppLocalizations.of(context);
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
        height: AppSizes.deviceHeight / 11,
        child: Container(
          color: Theme.of(context).cardColor,
          child: Container(
            margin: const EdgeInsets.only(
                left: 15.0, right: 15, top: 12, bottom: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // <-- Radius
                          ),

                          // backgroundColor: Colors.white, // background
                          // foregroundColor: Colors.black,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: MobikulTheme.iconColor),
                      onPressed: () async {
                        if (isAddedToCart) {
                          Navigator.pushNamed(context, AppRoute.cart);
                          return;
                        }

                        //productId= await AppSharedPref.getProductId();
                        /*
                        * Add to cart labelLarge functionality
                        * */

                        /*if(await AppSharedPref.isLogin()==true){*/
                        if (await checkForRequiredCustomField()) {
                          productPageBloc?.add(AddProductToCartEvent(
                              productId.toString(),
                              quantity.toString(),
                              json.encode(selectedProductOptions).toString()));
                          productPageBloc?.emit(ProductDetailStateInitial());
                          try {
                            FacebookAppEvents().logEvent(
                              name: 'add_to_cart',
                              parameters: {
                                'product_id': productId.toString(),
                                'quantity': quantity.toString(),
                              },
                            );
                          } catch (e) {}
                          json.encode(selectedProductOptions);
                        } else {
                          GenericMethods.showErrorAlertMessages(context,
                              "${_localizations?.translate(AppStringConstant.pleaseCheckRequiredField)}");
                        }
                      } /*else {
                         DialogHelper.confirmationDialog(
                              "${_localizations?.translate(AppStringConstant.signInToContinue)}",
                              context,
                              _localizations, onConfirm: () async {
                           //Todo: need to add code to move to login screen
                           // Navigator.pushNamed(context, loginSignup, arguments: false);
                          });
                         }*/
                      // }
                      ,
                      child: Center(
                          child: Text(
                        isAddedToCart ? "View Cart" : (_localizations
                                ?.translate(AppStringConstant.addToCart) ??
                            ''),
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.size15,
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // <-- Radius
                        ),

                        // foregroundColor: Colors.white, // background
                        // backgroundColor: Colors.black, // foreground
                      ),
                      onPressed: () async {
                        /*
                        * Buy now labelLarge functionality
                        * */
                        //if(await AppSharedPref.isLogin()==true){
                        // productId= await AppSharedPref.getProductId();
                        if (await checkForRequiredCustomField()) {
                          productPageBloc?.add(BuyNowEvent(
                              productId.toString(),
                              quantity.toString(),
                              json.encode(selectedProductOptions).toString()));
                          productPageBloc?.emit(ProductDetailStateInitial());
                          json.encode(selectedProductOptions);
                        } else {
                          GenericMethods.showErrorAlertMessages(context,
                              "${_localizations?.translate(AppStringConstant.pleaseCheckRequiredField)}");
                        }
                      } /*else {
                        DialogHelper.confirmationDialog(
                        "${_localizations?.translate(AppStringConstant.signInToContinue)}",
                        context,
                        _localizations, onConfirm: () async {
                        //Todo: need to add code to move to login screen
                        // Navigator.pushNamed(context, loginSignup, arguments: false);
                        });
                        }
                      }*/
                      ,
                      child: Center(
                          child: Text(
                        _localizations?.translate(AppStringConstant.buyNow) ??
                            '',
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

/*
*
* Method to check that all custom required filled are filled or not
* if filled return true else will return false
* */
  checkForRequiredCustomField() async {
    var requiredOptionFilled = true;
    if ((productOptions?.length ?? 0) > 0) {
      if (selectedProductOptions != null &&
          (selectedProductOptions?.length ?? 0) > 0) {
        productOptions?.forEach((element) {
          if ((element.required == "1") &&
              (selectedProductOptions?.keys
                      .contains(element.productOptionId)) ==
                  false) {
            requiredOptionFilled =
                false; //value not exists return false - mean this option is not selected yet.
          }
        });
      } else {
        //No custom options selected yet so return false
        requiredOptionFilled = false;
      }
    } else if (productOptions == null &&
        await AppSharedPref.getProductHasOption()) {
      /*
      * Means product has option but in this file product option is null as this widget value is not
      * updated in some cases after getting product data.
      * this case is arise becoz this  class is for add to cart or buy now labelLarge and as per ui guideline we have to show these labelLarge at bottm navigation.
      * so this class widget render before getting data of product and when product data come from api variable are not getting updated.
      * */
      requiredOptionFilled = false;
    }
    return requiredOptionFilled;
  }

  /*
  * TODO
  * Handle login_signup for add to cart or buy now labelLarge
  *
  * */
}
