import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/hive/prefetch_service.dart';
import 'package:oc_demo/screens/home/widgets/home_page_product_view_type_five.dart';
import 'package:oc_demo/screens/home/widgets/home_page_product_view_type_four.dart';
import 'package:oc_demo/screens/home/widgets/home_page_product_view_type_one.dart';
import 'package:oc_demo/screens/home/widgets/home_page_product_view_type_three.dart';
import 'package:oc_demo/screens/home/widgets/home_page_product_view_type_two.dart';
import 'package:oc_demo/screens/home/widgets/view_all_widget.dart';

import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/global_data.dart';
import '../../../models/homPage/home_screen_model.dart';

Widget homePageProductCollection(BuildContext context, List<Product>? data,
    String title, /*String productCategoryType,*/ String carouselId) {
  print(">>>>>>>>>>${data?.length}");
  return Padding(
    padding: const EdgeInsets.only(
        left: AppSizes.size4, right: AppSizes.size4 /*,top:AppSizes.size8 */),
    child: Column(
      children: [
        viewAllButton(context, title, () {
          Navigator.of(context).pushNamed(
            AppRoute.catalog,
            arguments: categoryMap(
              carouselId,
              title,
              /*   productCategoryType*/ GlobalData.home_page_carousel ?? "",
              false,
            ),
          );
        }, data?.length ?? 0),
        widgetSpace(0, AppSizes.size16),
        buildRandomProductViews(context, data, carouselId, title,
            GlobalData.home_page_carousel ?? ""),
        widgetSpace(0, AppSizes.size16),
      ],
    ),
  );
}

Widget buildRandomProductViews(BuildContext context, List<Product>? data,
    String catalogId, String title, String productCategoryType) {
  //return  homePageProductViewTypeOne(context, data,false);
  Random random = Random();
  // int viewType = random.nextInt(3) + 1;
  int viewType = 1;
  switch (viewType) {
    case 1:
      return homePageProductViewTypeTwo(
          context, catalogId, data, title, productCategoryType);
    case 2:
      // return homePageProductViewTypeThree(context, data);
      return homePageProductViewTypeFive(
          context, data, catalogId, title, productCategoryType);

    case 3:
      return homePageProductViewTypeFive(
          context, data, catalogId, title, productCategoryType);
    /* if ((data?.length ?? 0) >= 5) {
        return homePageProductViewTypeFour(context, data ?? []);
      } else {
        return homePageProductViewTypeFive(context, data);
      }*/
    default:
      //return homePageProductViewTypeOne(context, catalogId,data,false,title,productCategoryType);
      return homePageProductViewTypeFive(
          context, data, catalogId, title, productCategoryType);
  }
}
