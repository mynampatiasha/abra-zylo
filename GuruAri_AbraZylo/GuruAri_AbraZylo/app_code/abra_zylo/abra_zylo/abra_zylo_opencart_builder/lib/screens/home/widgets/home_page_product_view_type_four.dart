import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';
import 'home_page_product_card.dart';

Widget homePageProductViewTypeFour(BuildContext context, List<Product> data) {
  var totalDeviceWidth =
      AppSizes.deviceWidth - ((AppSizes.size8 + AppSizes.size8));
  var totalHeight = AppSizes.deviceHeight / 1.8;
  return Row(
    children: [
      SizedBox(
        width: totalDeviceWidth * 0.6,
        child: Column(
          children: [
            SizedBox(
              height: totalHeight / 2,
              child: HomePageProductCard(
                data: data[0],
              ),
            ),
            SizedBox(
              height: totalHeight / 2,
              child: HomePageProductCard(
                data: data[1],
              ),
            )
          ],
        ),
      ),
      SizedBox(
        width: totalDeviceWidth * 0.4,
        child: Column(
          children: [
            SizedBox(
              height: totalHeight / 3,
              child: HomePageProductCard(
                data: data[2],
              ),
            ),
            SizedBox(
              height: totalHeight / 3,
              child: HomePageProductCard(
                data: data[3],
              ),
            ),
            SizedBox(
              height: totalHeight / 3,
              child: HomePageProductCard(
                data: data[4],
              ),
            )
          ],
        ),
      )
    ],
  );
}
