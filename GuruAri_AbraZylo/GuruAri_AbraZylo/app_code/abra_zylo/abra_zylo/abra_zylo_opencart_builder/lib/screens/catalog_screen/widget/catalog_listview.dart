import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/product/product.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../hive/prefetch_service.dart';

class CatalogListView extends StatelessWidget {
  final List<Product>? products;
  final ScrollController? controller;
  final Function(String, int)? addProductToWishList;
  const CatalogListView(
      {this.products, this.controller, this.addProductToWishList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: AppColors.white,/*border: Border.all(color: Colors.grey[350]!)*/),
      child: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: (products?.length ?? 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == products?.length) {
            return const Padding(
              padding:
                  EdgeInsets.only(top: AppSizes.size4, bottom: AppSizes.size4
                      //  ,left:AppSizes.size24,right:AppSizes.size24
                      ),
              child: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                  width: AppSizes.size30,
                  height: AppSizes.size30,
                ),
              ),
            );
          }

          var product = products?[index];
          PrefetchService.preFetchProductDetails(product?.productId ?? '');
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.productPage,
                arguments: getProductDataAttributeMap(
                  product?.name ?? "",
                  product?.productId ?? "",
                ),
              );
            },
            child: Card(
              color: Theme.of(context).cardColor,
              // shape: const RoundedRectangleBorder(
              //     /*borderRadius: BorderRadius.only(
              //         bottomRight: Radius.circular(10),
              //         topRight: Radius.circular(10)),*/
              //     side: BorderSide(width: 0.2, color: AppColors.lightGray)),
              // elevation: 2,

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: AppSizes.size2,
                        bottom: AppSizes.size2,
                        left: AppSizes.size8,
                        right: AppSizes.size8),
                    child: Row(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: AppSizes.size8),
                            child: Center(
                              child: SizedBox(
                                width: AppSizes.catProductItemHeight,
                                child: ImageView(
                                  url: product?.thumb,
                                  height: AppSizes.categoryImageSizeMedium,
                                  width: AppSizes.categoryImageSizeMedium,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              right: AppSizes.size8,
                              bottom: AppSizes.size8,
                              child: InkWell(
                                onTap: () async {
                                  if (await AppSharedPref.isLogin()) {
                                    addProductToWishList!(
                                        product?.productId ?? "", index);
                                  } else {
                                    DialogHelper.confirmationDialog(
                                        "${AppLocalizations.of(context)?.translate(AppStringConstant.signInToContinue)}",
                                        context,
                                        AppLocalizations.of(context),
                                        onConfirm: () async {
                                      Navigator.of(context).pushNamed(
                                        AppRoute.login,
                                        arguments: getSignInSignUpPageArgument(
                                            false, false),
                                      );
                                    });
                                    /* Navigator.of(context).pushNamed(
                              AppRoute.login,
                              arguments:
                                  getSignInSignUpPageArgument(false, false),
                            );*/
                                  }
                                  // data?.wishlistStatus=isWishList ;
                                  // if (wishlistCallBack != null) {
                                  //   wishlistCallBack!(data?.productId ?? "");
                                  // }

                                  //
                                },
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
                                        offset: Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    //  data!.wishlistStatus==isWishlist
                                    product?.wishlistStatus ?? false
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: product?.wishlistStatus ?? false
                                        ? AppColors.red
                                        : AppColors.lightGray,
                                    size: AppSizes.size16,
                                  ),
                                ),
                              )),
                        ]),
                        /* ImageView(
                          url: product?.thumb,
                          width: AppSizes.deviceWidth / 3,
                          height: AppSizes.deviceWidth / 3,
                        ),*/
                        const SizedBox(width: AppSizes.size16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSizes.size4,
                                    left: AppSizes.size10,
                                    right: AppSizes.size10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${product?.price ?? ""}",
                                      style: TextStyle(
                                        decoration: product?.special == null ||
                                                product?.special == 0
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough,
                                        fontSize: AppSizes.size14,
                                        fontWeight: (product?.special != null &&
                                                (product?.special ?? 0) > 0)
                                            ? FontWeight.w400
                                            : FontWeight.w700,
                                        color: (product?.special != null &&
                                                (product?.special ?? 0) > 0)
                                            ? AppColors.darkGray
                                            : Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.color,
                                      ),
                                    ),
                                    widgetSpace(1, AppSizes.size8),
                                    if (product?.special != null &&
                                        (product?.special ?? 0) > 0)
                                      Text("${product?.formattedSpecial}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge)
                                  ],
                                  mainAxisSize: /*center ? MainAxisSize.min :*/
                                      MainAxisSize.max,
                                ),
                              ),
                              /*  Text(
                                product?.price ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimary),
                              ),*/
                              const SizedBox(height: AppSizes.size8),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSizes.size4,
                                    left: AppSizes.size10,
                                    right: AppSizes.size10),
                                child: Text(
                                  product?.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                  // style: Theme.of(context).textTheme.titleLarge
                                ),
                              ),
                              Visibility(
                                visible: ((product?.rating ?? 0) > 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                          5,
                                          (index) => _buildStar(context, index,
                                              (product?.rating ?? 0)))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[200],
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildStar(BuildContext context, int index, int rating) {
    Icon icon;
    icon = const Icon(
      Icons.star,
      color: AppColors.yellow,
      size: 16.0,
    );
    if (rating <= index) {
      icon = const Icon(
        Icons.star_border,
        color: AppColors.yellow,
        size: 16.0,
      );
    }
    return icon;
  }
}
