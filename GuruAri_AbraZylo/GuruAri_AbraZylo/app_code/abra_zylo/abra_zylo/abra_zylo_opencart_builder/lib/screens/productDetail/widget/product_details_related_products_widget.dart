import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import '../Bloc/product_detail_bloc.dart';
import '../Bloc/product_detail_event.dart';
import '../Bloc/product_detail_state.dart';

class ProductDetailRelatedProductsWidget extends StatelessWidget {
  List<RelatedProduct>? relatedProducts;
  final Function(String, int)? addProductToWishList;
  ProductDetailBloc? productPageBloc;
  ProductDetailRelatedProductsWidget(
      this.relatedProducts, this.addProductToWishList, this.productPageBloc,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((relatedProducts ?? []).isNotEmpty) {
      return Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
        margin: const EdgeInsets.only(top: AppSizes.size8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
              child: Text(
                AppLocalizations.of(context)
                        ?.translate(AppStringConstant.alternateProducts) ??
                    "",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.headlineMedium!.color),
              ),
            ),
            SizedBox(
              height: AppSizes.deviceWidth / 2,
              width: AppSizes.deviceWidth,
              child: ListView.builder(
                  itemCount: relatedProducts?.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = relatedProducts![index];
                    return productCard(data, (value) {
                      addProductToWishList!(value, index);
                    }, context);
                  }),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

/*
* Related product card.
* */

  Widget productCard(RelatedProduct product, Function(String)? onWishlistTap,
      BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(AppRoute.productPage,
            arguments: getProductDataAttributeMap(
                product.name ?? '', product.productId ?? ""));
      },
      child: Container(
        width: AppSizes.deviceWidth / 3 + 20,
        child: Card(
          color: Theme.of(context).cardColor,
          // shape:  RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(0.0),
          //   // side:BorderSide(
          //   //   color: AppColors.dividerColor,
          //   //   width: 0.5,
          //   // )
          //   ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8.0, bottom: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  ImageView(
                      url: product.thumb,
                      width: AppSizes.deviceWidth / 3,
                      height: (AppSizes.deviceWidth / 2) * 0.7),
                  PositionedDirectional(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.size8),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppSizes.size16)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.background,

                                blurRadius: AppSizes.size4,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Icon(
                            product?.wishlistStatus == true
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: product?.wishlistStatus == true
                                ? AppColors.red
                                : AppColors.lightGray,
                            size: AppSizes.size16,
                          ),
                        ),
                        onTap: () async {
                          /*
                      * WishList labelLarge functionality
                      *
                      * */

                          if (await AppSharedPref.isLogin() == true) {
                            // productPageBloc?.add(AddProductToWishListEvent(
                            //   product?.productId?.toString() ?? ""));
                            // productPageBloc?.emit(ProductDetailStateInitial());
                            onWishlistTap?.call(product.productId ?? "");
                            /*setState(() {
                                print("====> ${  addedToWishlist}");
                              });*/
                          } else {
                            DialogHelper.confirmationDialog(
                                "${AppLocalizations.of(context)?.translate(AppStringConstant.signInToContinue)}",
                                context,
                                AppLocalizations.of(context),
                                onConfirm: () async {
                              Navigator.of(context).pushNamed(
                                AppRoute.login,
                                arguments:
                                    getSignInSignUpPageArgument(false, false),
                              );
                            });
                          }
                        },
                      ),
                    ),
                    bottom: 0,
                    end: 0,
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if ((product?.formattedSpecial ?? "") != "" &&
                        (product?.formattedSpecial ?? "") != "0") ...[
                      Text(
                        product?.price.toString() ?? '',
                        style: TextStyle(
                          fontSize: AppSizes.size12,
                          color:
                              Theme.of(context).textTheme.headlineMedium!.color,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(
                        width: AppSizes.size8,
                      ),
                      Text(
                        product?.formattedSpecial.toString() ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ] else ...[
                      Text(
                        product?.price ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    ]
                  ],
                ),
                Expanded(
                  child: Text(
                    "${product.name}",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
