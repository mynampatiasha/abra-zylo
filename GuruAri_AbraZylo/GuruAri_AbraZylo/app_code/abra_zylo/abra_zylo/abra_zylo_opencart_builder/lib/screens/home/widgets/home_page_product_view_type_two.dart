import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/hive/prefetch_service.dart';
import 'package:oc_demo/screens/home/bloc/home_screen_bloc.dart';
import 'package:oc_demo/screens/home/widgets/view_more_widget.dart';

import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';
import 'home_page_product_card.dart';

Widget homePageProductViewTypeTwo(BuildContext context, String categoryId,
    List<Product>? data, String title, String productCategoryType) {
  return SizedBox(
    height: (AppSizes.deviceWidth / 1.65),
    child: Padding(
      padding:
          const EdgeInsets.only(left: AppSizes.size8, right: AppSizes.size10),
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          if (index == data?.length) {
            return viewMore(
                context,
                categoryId /*data[index - 1].productId ?? ""*/,
                data?[index - 1].name ?? "",
                title,
                productCategoryType);
          } else {
            PrefetchService.preFetchProductDetails(data?[index].productId);
            return GestureDetector(
              onTap: () {},
              child: HomePageProductCard(
                data: data?[index],
              ),
            );
            // return Container();
          }
        },
        separatorBuilder: (BuildContext context, int index) =>
            widgetSpace(1, 0),
      ),
    ),
  );
}
