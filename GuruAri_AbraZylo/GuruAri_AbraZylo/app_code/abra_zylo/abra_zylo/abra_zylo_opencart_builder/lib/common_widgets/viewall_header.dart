import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import '../constants/app_routes.dart';

class ViewAllHeader extends StatelessWidget {
  const ViewAllHeader(this.title, this.catalogId, {Key? key}) : super(key: key);

  final String? title;
  final String? catalogId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size4, vertical: AppSizes.size4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              AppStringConstant.bestProduct.localized(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoute.catalog,
                  arguments: categoryMap(catalogId ?? "", title ?? "", ""),
                );
              },
              // style: OutlinedButton.styleFrom(
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              //   side: const BorderSide(
              //     width: AppSizes.size2,
              //     color: AppColors.black,
              //   ),
              // ),
              child: Text(AppStringConstant.viewAll.localized().toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineMedium!.color,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSizes.size12,
                  )
                  // style: Theme.of(context).textTheme.titleLarge
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
