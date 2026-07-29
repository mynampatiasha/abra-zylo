import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/title_separated_card.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/screens/cart/widgets/quantity_drop_down.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/order_summary.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/cart/cart_model.dart';
import '../bloc/cart_screen_bloc.dart';
import 'cart_icon_button.dart';

class CartProductItem extends StatelessWidget {
  const CartProductItem(this.product, this.localizations, this.bloc,
      {super.key});

  final Products? product;
  final AppLocalizations? localizations;
  final CartScreenBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            // Top Section: Image + Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: 90,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ImageView(
                        url: product?.thumb,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product?.name ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (product?.option != null && product!.option!.isNotEmpty)
                              GestureDetector(
                                onTap: () => openBottomSheetForProductOption(context, product?.option),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.info, color: Colors.black, size: 20),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (product?.model?.isNotEmpty ?? false)
                          Text(
                            "${localizations?.translate(AppStringConstant.model)} : ${product?.model}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          product?.price ?? "0.00",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        
                        // In Stock Badge
                        if (product?.stock != false)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check, size: 12, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  "In Stock",
                                  style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            localizations?.translate(AppStringConstant.outOfStock) ?? 'Out of Stock',
                            style: const TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Middle Section: Qty and Subtotal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text("Qty", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 36,
                    child: QuantityDropDown((value) async {
                      product?.quantity = value;
                      Map<String, String> jsonMap = {};
                      jsonMap[product?.key ?? "0"] = value.toString();
                      bloc?.add(CartUpdateEvent(json.encode(jsonMap)));
                      bloc?.emit(CartScreenStateInitial());
                    }, int.parse(product?.quantity ?? "0")),
                  ),
                  const Spacer(),
                  Text(
                    "${localizations?.translate(AppStringConstant.subtotal) ?? "Subtotal"} : ",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  Text(
                    product?.total ?? "0.00",
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade200, thickness: 1),
            
            // Bottom Section: Actions
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (await AppSharedPref.isLogin() == true) {
                          bloc?.add(AddProductToWishListEvent(product?.productId?.toString() ?? ""));
                          bloc?.emit(CartScreenStateInitial());
                        } else {
                          DialogHelper.confirmationDialog(
                              "${localizations?.translate(AppStringConstant.signInToContinue)}",
                              context,
                              localizations, onConfirm: () async {
                            Navigator.of(context).pushNamed(
                              AppRoute.login,
                              arguments: getSignInSignUpPageArgument(false, false),
                            );
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              product?.wishlistStatus == true ? Icons.favorite : Icons.favorite,
                              color: const Color(0xFF673AB7),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              localizations?.translate(AppStringConstant.moveToWishlist)?.toUpperCase() ?? "ADD TO WISH LIST",
                              style: const TextStyle(
                                color: Color(0xFF673AB7),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(width: 1, color: Colors.grey.shade200, thickness: 1),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        DialogHelper.confirmationDialog(
                            AppStringConstant.deleteItemFromCart,
                            context,
                            localizations, onConfirm: () async {
                          bloc?.add(CartScreenRemoveItemEvent(product?.key ?? "0"));
                          bloc?.emit(CartScreenStateInitial());
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.grey.shade700,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              localizations?.translate(AppStringConstant.removeItem)?.toUpperCase() ?? "REMOVE ITEM",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  void openBottomSheetForProductOption(
      BuildContext context, List<Option>? option) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => TitleSeparatedCard(
        (localizations?.translate(AppStringConstant.details) ?? ""),
        ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return customOptionItem(option?[index].name ?? "",
                  option?[index].value ?? "", context);
            },
            separatorBuilder: (BuildContext context, int index) =>
                widgetSpace(1, AppSizes.size8),
            itemCount: option?.length ?? 0),
        showDivider: false,
        asCard: false,
      ),
    );
  }
}
