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
import '../../../constants/arguments_map.dart';
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
        child: SafeArea(
          child: Container(
            color: Theme.of(context).cardColor,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      if (await AppSharedPref.isLogin() == true) {
                        productPageBloc?.add(AddProductToWishListEvent(productId.toString()));
                        productPageBloc?.emit(ProductDetailStateInitial());
                      } else {
                        DialogHelper.wishlistConfirmationDialog(
                            "${_localizations?.translate(AppStringConstant.wishlistDesc)}",
                            "${_localizations?.translate(AppStringConstant.loginRequired)}",
                            context,
                            _localizations, onConfirm: () async {
                          Navigator.of(context).pushNamed(AppRoute.login, arguments: getSignInSignUpPageArgument(false, false, isFromProductDetail: true));
                        });
                      }
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border, color: AppColors.black, size: 22),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(width: 1.5, color: Color(0xFF673AB7)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        foregroundColor: const Color(0xFF673AB7),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (isAddedToCart) {
                          Navigator.pushNamed(context, AppRoute.cart);
                          return;
                        }
                        if (await AppSharedPref.isLogin() == true) {
                          if (await checkForRequiredCustomField()) {
                            productPageBloc?.add(AddProductToCartEvent(
                                productId.toString(),
                                quantity.toString(),
                                json.encode(selectedProductOptions).toString()));
                            productPageBloc?.emit(ProductDetailStateInitial());
                            try {
                              FacebookAppEvents().logEvent(
                                name: 'add_to_cart',
                                parameters: {'product_id': productId.toString(), 'quantity': quantity.toString()},
                              );
                            } catch (e) {}
                          } else {
                            GenericMethods.showErrorAlertMessages(context, "${_localizations?.translate(AppStringConstant.pleaseCheckRequiredField)}");
                          }
                        } else {
                          DialogHelper.wishlistConfirmationDialog(
                              "${_localizations?.translate(AppStringConstant.signInToContinue)}",
                              "${_localizations?.translate(AppStringConstant.loginRequired)}",
                              context,
                              _localizations, onConfirm: () async {
                            Navigator.of(context).pushNamed(AppRoute.login, arguments: getSignInSignUpPageArgument(false, false, isFromProductDetail: true));
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isAddedToCart ? "VIEW CART" : "ADD TO CART",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (await AppSharedPref.isLogin() == true) {
                          if (await checkForRequiredCustomField()) {
                            productPageBloc?.add(BuyNowEvent(
                                productId.toString(),
                                quantity.toString(),
                                json.encode(selectedProductOptions).toString()));
                            productPageBloc?.emit(ProductDetailStateInitial());
                          } else {
                            GenericMethods.showErrorAlertMessages(context, "${_localizations?.translate(AppStringConstant.pleaseCheckRequiredField)}");
                          }
                        } else {
                          DialogHelper.wishlistConfirmationDialog(
                              "${_localizations?.translate(AppStringConstant.signInToContinue)}",
                              "${_localizations?.translate(AppStringConstant.loginRequired)}",
                              context,
                              _localizations, onConfirm: () async {
                            Navigator.of(context).pushNamed(AppRoute.login, arguments: getSignInSignUpPageArgument(false, false, isFromProductDetail: true));
                          });
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flash_on, size: 18),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "BUY NOW",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
