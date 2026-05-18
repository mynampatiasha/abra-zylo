import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/searchModel/search_model.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

Widget suggestionList(BuildContext context, AppLocalizations? _localizations,
    List<SearchData>? searchData) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: AppSizes.size26, bottom: AppSizes.size8),
            child: Text(
              _localizations?.translate(AppStringConstant.suggestions) ?? "",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchData?.length,
              itemBuilder: (context, index) {
                var data = searchData?[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoute.productPage,
                        arguments: getProductDataAttributeMap(
                            data?.name ?? "", data?.productId ?? ""));
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppSizes.size4,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            data?.name ?? "",
                          )),
                          const Icon(Icons.arrow_right)
                        ],
                      ),
                      SizedBox(
                        height: AppSizes.size4,
                      ),
                      Divider(),
                    ],
                  ),
                );
              }),
        ],
      ));
}
