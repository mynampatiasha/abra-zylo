import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_constants.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/product/product.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem(this.product, this.addToWishList, this.imageSize,
      {Key? key, this.center = false})
      : super(key: key);

  final Product product;
  final bool center;
  final Function(String) addToWishList;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.catProductItemHeight,
      //color: AppColors.white,
      // padding: const EdgeInsets.only(left:AppSizes.size8,right:AppSizes.size8),
      //  decoration: BoxDecoration(color: AppColors.white,border: Border.all(color: AppColors.dividerColor!)),
      child: Card(
        margin: const EdgeInsets.all(AppSizes.size6),
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment:
              center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            /* Expanded(
              child: Center(
                child: SizedBox(
                  width: AppSizes.catProductItemHeight,
                  child: ImageView(
                    url: product.thumb,
                    height: AppSizes.categoryImageSizeMedium,
                    width: AppSizes.categoryImageSizeMedium,
                  ),
                ),
              ),
            ),*/

            Stack(children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: AppSizes.size8),
                child: Center(
                  child: SizedBox(
                    width: AppSizes.catProductItemHeight,
                    child: ImageView(
                      url: product.thumb,
                      height: imageSize,
                      width: imageSize,
                    ),
                  ),
                ),
              ),
              Positioned(
                  right: AppSizes.size8,
                  top: AppSizes.size8,
                  child: InkWell(
                    onTap: () async {
                      if (await AppSharedPref.isLogin()) {
                        addToWishList(product.productId ?? "");
                      } else {
                        DialogHelper.confirmationDialog(
                            "${AppLocalizations.of(context)?.translate(AppStringConstant.signInToContinue)}",
                            context,
                            AppLocalizations.of(context), onConfirm: () async {
                          Navigator.of(context).pushNamed(
                            AppRoute.login,
                            arguments:
                                getSignInSignUpPageArgument(false, false),
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(AppSizes.size16)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.background,
                            blurRadius: AppSizes.size4,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Icon(
                        //  data!.wishlistStatus==isWishlist
                        product.wishlistStatus ?? false
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: product.wishlistStatus ?? false
                            ? AppColors.red
                            : AppColors.lightGray,
                        size: AppSizes.size16,
                      ),
                    ),
                  )),
            ]),
            const SizedBox(height: AppSizes.size4),
            Visibility(
              visible: ((product?.rating ?? 0) > 0),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        5,
                        (index) => _buildStar(
                            context, index, (product?.rating ?? 0)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: AppSizes.size8,
                  left: AppSizes.size10,
                  right: AppSizes.size10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: center ? MainAxisSize.min : MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "${product.price}",
                      style: TextStyle(
                        decoration:
                            product.special == null || product.special == 0
                                ? TextDecoration.none
                                : TextDecoration.lineThrough,
                        fontWeight:
                            (product.special != null && product.special! > 0)
                                ? FontWeight.w400
                                : FontWeight.w700,
                        fontSize: AppSizes.size14,
                        color: (product.special != null && product.special! > 0)
                            ? Theme.of(context).textTheme.titleLarge?.color
                            : Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  widgetSpace(1, AppSizes.size8),
                  if (product.special != null && product.special! > 0)
                    Flexible(
                        child: Text(
                      "${product.formattedSpecial}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ))
                ],
              ),
            ),
            const SizedBox(height: AppSizes.size4),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: AppSizes.size0,
                  left: AppSizes.size10,
                  right: AppSizes.size10),
              child: Text(
                "${product.name}",
                style: const TextStyle(
                  fontSize: AppSizes.size14,
                  // color: Theme.of(context).colorScheme.onPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: center ? TextAlign.center : TextAlign.start,
              ),
            )
          ],
        ),
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
