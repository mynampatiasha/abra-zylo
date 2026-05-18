import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/screens/category/widgets/view_all_card.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';

class CategoriesTile extends StatelessWidget {
  final List<Categories>? category;
  final String? rootCategoryId;
  final String? title;

  const CategoriesTile({
    Key? key,
    this.category,
    this.rootCategoryId,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subcategory = category;
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        AppStringConstant.categories.localized(),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      children: [
        const Divider(
          height: 1,
          color: AppColors.dividerColor,
        ),
        const SizedBox(height: AppSizes.size6),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.78,
          ),
          itemCount: (subcategory?.length ?? 0) + 1,
          itemBuilder: (BuildContext context, int itemIndex) {
            //Prefetch category data
            preFetchData(itemIndex, subcategory);
            return (itemIndex == (subcategory?.length ?? 0))
                ? ViewAllCard(title, categoryId: rootCategoryId)
                : Card(
                    //color: Colors.red,
                    color: Theme.of(context).cardColor,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    //color: Theme.of(context).cardColor,
                    child: InkWell(
                      onTap: () {
                        if (subcategory?[itemIndex].childStatus == true) {
                          Navigator.pushNamed(
                            context,
                            AppRoute.subCategory,
                            arguments: categoryMap(
                                subcategory?[itemIndex].path ?? '',
                                subcategory?[itemIndex].name ?? '',
                                ""),
                          );
                        } else {
                          Navigator.of(context).pushNamed(
                            AppRoute.catalog,
                            arguments: categoryMap(
                                subcategory?[itemIndex].path ?? "",
                                subcategory?[itemIndex].name ?? "",
                                ""),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 2,
                              child: ImageView(
                                url: subcategory?[itemIndex].image ?? "",
                                // url:"https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg",
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(height: AppSizes.size2),
                            Flexible(
                              flex: 1,
                              child: Text(
                                subcategory?[itemIndex].name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
        SizedBox(height: 30)
      ],
    );
  }

  void preFetchData(int itemIndex, List<Categories>? subcategory) {
    if (itemIndex == ((subcategory?.length ?? 0))) {
      PrefetchService.preFetchCategoryData(rootCategoryId);
    } else {
      PrefetchService.preFetchCategoryData(subcategory?[itemIndex].path ?? '');
    }
  }
}
