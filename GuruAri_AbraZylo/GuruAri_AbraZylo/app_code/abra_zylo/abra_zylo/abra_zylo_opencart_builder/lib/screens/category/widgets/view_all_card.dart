import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/hive/prefetch_service.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';

class ViewAllCard extends StatelessWidget {
  final String? categoryId;
  final String? title;

  const ViewAllCard(this.title, {this.categoryId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoute.catalog,
          arguments: categoryMap(categoryId ?? "", title ?? "", ""),
        );
      },
      child: Card(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/view-all.png'),
            /*ImageView(
              url: "",
              height: AppSizes.categoryImageSizeSmall,
              fit: BoxFit.cover,
            )*/
            const SizedBox(height: AppSizes.size8),
            Text(
              AppStringConstant.viewAll.localized(),
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineMedium!.color,
                fontWeight: FontWeight.w700,
                fontSize: AppSizes.size12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
