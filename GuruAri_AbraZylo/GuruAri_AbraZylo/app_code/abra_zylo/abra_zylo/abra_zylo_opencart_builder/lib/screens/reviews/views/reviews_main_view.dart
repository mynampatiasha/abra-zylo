/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter/material.dart';
import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/rating_bar.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/reviewListModel/reviews_list_model.dart';

Widget reviewMainView(BuildContext context, List<ReviewsListData>? orders,
    AppLocalizations? localizations, ScrollController controller,
    {ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics()}) {
  return ListView.builder(
    controller: controller,
    shrinkWrap: true,
    physics: scrollPhysics,
    itemBuilder: (ctx, index) =>
        reviewItem(context, orders?[index], localizations),
    itemCount: (orders?.length ?? 0),
  );
}

Widget reviewItem(BuildContext context, ReviewsListData? item,
    AppLocalizations? localizations) {
  return Container(
    padding: const EdgeInsets.only(
        top: AppSizes.size8, left: AppSizes.size8, right: AppSizes.size8),
    margin: const EdgeInsets.only(bottom: AppSizes.size10),
    color: Theme.of(context).cardColor,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, AppRoute.productPage,
            arguments: getProductDataAttributeMap(
              item?.productName ?? "",
              item?.productId ?? "",
            ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: AppSizes.deviceWidth / 4.67,
                width: AppSizes.deviceWidth / 4.67,
                child: ImageView(
                  url: item?.image,
                ),
              ),
              const SizedBox(width: AppSizes.size8),
              SizedBox(
                width: AppSizes.deviceWidth / 1.60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoute.productPage,
                          arguments: getProductDataAttributeMap(
                            item?.productName ?? "",
                            item?.productId.toString() ?? "",
                          ),
                        );
                      },
                      child: Text(
                        item?.productName.toString() ?? " ",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(),
                      ),
                    ),
                    const SizedBox(height: AppSizes.size8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RatingBarCustom(
                          starCount: 5,
                          color: AppColors.yellow,
                          rating: double.parse(item?.rating ?? "0"),
                        ),
                        const SizedBox(width: AppSizes.size4),
                        Text(
                            '${item?.rating.toString()} ${AppStringConstant.stars}' ??
                                '',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: AppSizes.size8),
                  ],
                ),
              ),

              // Edit labelLarge
            ],
          ),
          const Icon(
            Icons.navigate_next,
            color: AppColors.lightGray,
          )
        ],
      ),
    ),
  );
}
