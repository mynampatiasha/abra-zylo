import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/arguments_map.dart';

import '../../../constants/app_routes.dart';
import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';

class SubCategoryListItem extends StatelessWidget {
  const SubCategoryListItem(this.categories, {Key? key}) : super(key: key);

  final List<Categories>? categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        PrefetchService.preFetchCategoryData(categories?[index]?.path);
        return Card(
          shape: const RoundedRectangleBorder(),
          child: ListTile(
            title: Text(
              categories?[index].name ?? "",
              style: TextStyle(
                fontSize: AppSizes.size14,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            trailing: categories?[index].childStatus == true
                ? const Icon(
                    Icons.arrow_forward_ios,
                    size: AppSizes.size16,
                  )
                : null,
            onTap: () {
              if (categories?[index].childStatus == true) {
                // Navigator.of(context).pushNamed(routeName)
                Navigator.pushNamed(
                  context,
                  AppRoute.subCategory,
                  arguments: categoryMap(categories?[index].path ?? '',
                      categories?[index].name ?? '', ""),
                );
              } else {
                Navigator.of(context).pushNamed(
                  AppRoute.catalog,
                  arguments: categoryMap(categories?[index].path ?? "",
                      categories?[index].name ?? "", ""),
                );
              }
            },
          ),
        );
      },
      itemCount: categories?.length ?? 0,
    );
  }
}
