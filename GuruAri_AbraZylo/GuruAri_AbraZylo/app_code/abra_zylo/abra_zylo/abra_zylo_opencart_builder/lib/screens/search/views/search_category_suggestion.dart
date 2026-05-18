import 'package:flutter/cupertino.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/global_data.dart';

import '../../../models/homPage/home_screen_model.dart';

Widget getSearchCategorySuggestion(List<Categories>? categories) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: (categories ?? [])
          .map((e) => Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoute.category, arguments: {
                      "selectedIndex":
                          GlobalData.rootCategories?.indexOf(e) ?? 0,
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.size8),
                    margin:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.size8),
                        color: AppColors.black),
                    child: Text(
                      e.name ?? "",
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                );
              }))
          .toList(),
    ),
  );
}
