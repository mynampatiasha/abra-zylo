import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/screens/home/bloc/home_screen_bloc.dart';
import 'package:oc_demo/screens/home/widgets/view_more_widget.dart';

import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';
import 'home_page_product_card.dart';

Widget homePageProductViewTypeOne(
    BuildContext? context,
    String categoryId,
    List<Product>? data,
    bool scrollable,
    String title,
    String productCategoryType) {
  int getListLength() {
    if (data == null) {
      return 0;
    } else {
      return data.length.isEven ? data.length : data.length + 1;
    }
  }

  return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (1 - (66 / AppSizes.deviceWidth)),
      ),
      itemCount: getListLength(),
      itemBuilder: (BuildContext context, int index) {
        if (index == data?.length) {
          if (data?.length.isOdd == true) {
            return viewMore(
                context,
                /*data?[index-1].productId??""*/ categoryId,
                data?[index - 1].name ?? "",
                title,
                productCategoryType);
          } else {
            return Container();
          }
        } else {
          PrefetchService.preFetchProductDetails(data![index].productId);
          return GestureDetector(
            onTap: () {},
            child: HomePageProductCard(
              data: data?[index],
            ),
          );
        }
      });
}
