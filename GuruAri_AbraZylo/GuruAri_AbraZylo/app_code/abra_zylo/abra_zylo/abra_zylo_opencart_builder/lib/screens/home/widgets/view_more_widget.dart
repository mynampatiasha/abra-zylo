import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/arguments_map.dart';
import '../../../constants/global_data.dart';
import '../../../helper/generic_methods.dart';

Widget viewMore(BuildContext context, String categoryID, String categoryName,
    String title, String productType) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRoute.catalog,
        arguments: categoryMap(
          categoryID,
          title ?? "",
          GlobalData.home_page_carousel ?? "",
          /*productType ?? "",*/
          false,
        ),
      );
    },
    // child: Card(
    //   color: Theme.of(context).cardColor,
    //   child: SizedBox(
    //       height: ((  AppSizes.deviceWidth / 2.5) - 8) - 3,
    //       width: AppSizes.deviceWidth / 2,
    //       // decoration: BoxDecoration(
    //       //     border: Border.all(
    //       //       color: Colors.grey.shade200,
    //       //     )),
    //       child: Center(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             const Icon(Icons.arrow_right,size: 30,),
    //             const SizedBox(
    //               height: AppSizes.size8,
    //             ),
    //             Text(
    //               GenericMethods.getStringValue(context,AppStringConstant.viewAll),
    //               style:Theme.of(context).textTheme.titleLarge,
    //             )
    //           ],
    //         ),
    //       )),
    // ),
  );
}
