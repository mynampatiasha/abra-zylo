import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppStringConstant.categories.localized(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoute.catalog,
                    arguments: categoryMap(rootCategoryId ?? "", title ?? "", ""),
                  );
                },
                child: const Text(
                  "View All >",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF673AB7),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: subcategory?.length ?? 0,
          itemBuilder: (BuildContext context, int itemIndex) {
            preFetchData(itemIndex, subcategory);
            
            return Card(
              color: Colors.white,
              elevation: 2,
              shadowColor: Colors.black12.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                        child: Container(
                          color: const Color(0xFFF9F9F9),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageView(
                              url: subcategory?[itemIndex].image ?? "",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              subcategory?[itemIndex].name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Explore Collection",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  void preFetchData(int itemIndex, List<Categories>? subcategory) {
    if (subcategory != null && itemIndex < subcategory.length) {
      PrefetchService.preFetchCategoryData(subcategory[itemIndex].path ?? '');
    }
  }
}

