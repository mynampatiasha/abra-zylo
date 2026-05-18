import 'package:flutter/material.dart';
import 'package:oc_demo/screens/home/bloc/home_screen_bloc.dart';

import '../../../constants/app_constants.dart';
import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';
import 'home_page_product_card.dart';

Widget homePageProductViewTypeThree(BuildContext context, List<Product>? data) {
  List<Widget> customViews = [];
  if (data?.length == 1) {
    customViews.add(SizedBox(
      height: (AppSizes.deviceWidth / 2) + 32,
      width: AppSizes.deviceWidth - (AppSizes.size15),
      child: HomePageProductCard(
        data: data?[0],
      ),
    ));
  } else {
    for (int i = 0; i < (data?.length ?? 0); i++) {
      if ((i + 1) % 3 == 0) {
        PrefetchService.preFetchProductDetails(data?[i].productId);
        customViews.add(SizedBox(
          height: (AppSizes.deviceWidth / 2) + 32,
          width: AppSizes.deviceWidth - (AppSizes.size15),
          child: HomePageProductCard(
            data: data?[i],
          ),
        ));
        i++;
      } else {
        if (i == 0) {
          continue;
        }
        customViews.add(Row(
          children: [
            SizedBox(
              width: (AppSizes.deviceWidth / 2) - 10,
              height: (AppSizes.deviceWidth / 2) + 32,
              child: HomePageProductCard(
                data: data?[i - 1],
              ),
            ),
            SizedBox(
              width: (AppSizes.deviceWidth / 2) - 10,
              height: (AppSizes.deviceWidth / 2) + 32,
              child: HomePageProductCard(
                data: data?[i],
              ),
            )
          ],
        ));
      }
    }
  }
  return Column(children: customViews);
}
