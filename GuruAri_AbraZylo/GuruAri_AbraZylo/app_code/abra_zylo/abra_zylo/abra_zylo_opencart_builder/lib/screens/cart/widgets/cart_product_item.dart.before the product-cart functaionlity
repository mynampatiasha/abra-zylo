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
      padding: const EdgeInsets.only(bottom: AppSizes.size8),
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  right: AppSizes.size12,
                  left: AppSizes.size12,
                  top: AppSizes.size12),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoute.productPage,
                    arguments: getProductDataAttributeMap(
                      product?.name ?? '',
                      product?.productId ?? '',
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Image and qty dropdown
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ImageView(
                                url: product?.thumb,
                                height: AppSizes.deviceHeight / 7,
                                width: AppSizes.deviceWidth / 4,
                              ),
                            ),
                            /*PositionedDirectional(
                              child: Visibility(
                                child: GestureDetector(
                                  child: const Icon(Icons.info),
                                  onTap: () {
                                    if (product?.option != null &&
                                        product?.option?.isNotEmpty == true) {
                                      openBottomSheetForProductOption(
                                          context, product?.option);
                                    }
                                  },
                                ),
                                visible: product?.option != null &&
                                    product?.option?.isNotEmpty == true,
                              ),
                              bottom: 0,
                              start: 0,
                            ),*/
                          ],
                        ),
                        SizedBox(
                          height: AppSizes.size24,
                          child: QuantityDropDown((value) async {
                            product?.quantity = value;
                          }, int.parse(product?.quantity ?? "0")),
                        ),
                      ],
                    ),

                    const SizedBox(width: AppSizes.size12),

                    // Product Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppSizes.size10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //product name

                            Text(product?.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .color,
                                        fontWeight: FontWeight.w700)),
                            //Model Text
                            if (product?.model?.isNotEmpty ?? false)
                              Row(
                                children: [
                                  Text(
                                      "${localizations?.translate(AppStringConstant.model)} : ",
                                      style: const TextStyle(
                                          color: AppColors.darkGray,
                                          fontWeight: FontWeight.w400)),
                                  Expanded(
                                    child: Text(product?.model ?? '',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .color,
                                            fontWeight: FontWeight.w700)),
                                  )
                                ],
                              ),
                            const SizedBox(height: AppSizes.size8),
                            //available rewards points  text if available
                            if (product?.reward?.isNotEmpty ?? false)
                              Text(product?.reward ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.normal)),
                            //Selected option for products if available
                            // if (product?.option?.isNotEmpty ?? false)
                            //   CartProductOptionWidget(
                            //     options: product?.option,
                            //     localizations: localizations,
                            //   ),
                            const SizedBox(height: AppSizes.size8),
                            //Price text
                            Text(product?.price ?? "0.00",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: AppSizes.size8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "${localizations?.translate(AppStringConstant.subtotal) ?? ""} : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: AppColors.darkGray,
                                          fontSize: AppSizes.size14),
                                ),
                                Text((product?.total ?? "0.00"),
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                            Visibility(
                                visible: product?.stock == false,
                                child: Column(
                                  children: [
                                    const SizedBox(height: AppSizes.size8),
                                    Text(
                                        localizations?.translate(
                                                AppStringConstant.outOfStock) ??
                                            '',
                                        style: const TextStyle(
                                            color: AppColors.red)),
                                    const SizedBox(height: AppSizes.size4),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),

                    // Edit labelLarge// comment edit labelLarge as per ui team ui enhancement isssue and add info labelLarge here
                    Visibility(
                      visible: product?.option != null &&
                          product?.option?.isNotEmpty == true,
                      child: GestureDetector(
                        child: const Icon(Icons.info),
                        onTap: () {
                          if (product?.option != null &&
                              product?.option?.isNotEmpty == true) {
                            openBottomSheetForProductOption(
                                context, product?.option);
                          }
                        },
                      ),
                    ),
                    /* InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoute.productPage,
                          arguments: getProductDataAttributeMap(
                            product?.name ?? '',
                            product?.productId ?? '',
                          ),
                        );
                      },
                      child: Visibility(
                        child: const Padding(
                          padding: EdgeInsets.all(AppSizes.size8),
                          child: Icon(
                            Icons.edit,
                            size: AppSizes.size16,
                          ),
                        ),
                        visible: product?.option != null &&
                            product?.option?.isNotEmpty == true,
                      )
                      */ /* child: const Padding(
                        padding: EdgeInsets.all(AppSizes.size8),
                        child: Icon(
                          Icons.edit,
                          size: AppSizes.size16,
                        ),
                      )*/ /*
                      ,
                    )*/
                  ],
                ),
              ),
            ),
            SizedBox(
              height: AppSizes.size8,
            ),
            const Divider(
              height: 1,
              color: AppColors.darkGray,
            ),
            /*
            * Wishlist and remove product labelLarge
            * */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //Wishlist labelLarge
                GestureDetector(
                  onTap: () async {
                    /*
                  * WishList labelLarge functionality
                  *
                  * */
                    if (await AppSharedPref.isLogin() == true) {
                      bloc?.add(AddProductToWishListEvent(
                          product?.productId?.toString() ?? ""));
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
                  child: Container(
                    height: AppSizes.size44,
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.size8),
                            child: Icon(
                              product?.wishlistStatus == true
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: product?.wishlistStatus == true
                                  ? AppColors.lightRed
                                  : Theme.of(context).iconTheme.color,
                            )),
                        Text(
                            localizations
                                    ?.translate(
                                        AppStringConstant.moveToWishlist)
                                    .toUpperCase() ??
                                "",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .color,
                                    fontSize: AppSizes.size12,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                //Remove item labelLarge
                CartIconButton(
                  leadingIcon: Icons.delete_outline,
                  title: localizations
                          ?.translate(AppStringConstant.removeItem)
                          .toUpperCase() ??
                      "",
                  onClick: () {
                    DialogHelper.confirmationDialog(
                        AppStringConstant.deleteItemFromCart,
                        context,
                        localizations, onConfirm: () async {
                      bloc?.add(CartScreenRemoveItemEvent(product?.key ?? "0"));
                      bloc?.emit(CartScreenStateInitial());
                    });
                  },
                ),
              ],
            ),
            const Divider(
              height: 1,
              color: AppColors.darkGray,
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
