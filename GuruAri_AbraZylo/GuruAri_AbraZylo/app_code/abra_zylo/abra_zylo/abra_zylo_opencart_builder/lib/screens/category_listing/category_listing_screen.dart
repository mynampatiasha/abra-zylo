/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/category_listing/view/sub_category_view.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/image_view.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../constants/global_data.dart';
import '../../helper/app_localizations.dart';
import '../../models/homPage/home_screen_model.dart';
import '../catalog_screen/bloc/catalog_screen_bloc.dart';
import '../catalog_screen/bloc/catalog_screen_repository.dart';
import '../catalog_screen/catalog_screen.dart';
import '../category/bloc/categories_screen_bloc.dart';
import '../category/bloc/categories_screen_repository.dart';

class CategorySearchScreen extends StatefulWidget {
  const CategorySearchScreen({Key? key}) : super(key: key);

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  List<Categories>? listOfCategories;
  AppLocalizations? _localizations;

  @override
  void initState() {
    listOfCategories = GlobalData.rootCategories;
    // TODO: implement initState
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        _localizations?.translate(AppStringConstant.categories) ?? '',
        context,
        isLeadingEnable: false,
        hideCart: true,
      ),
      body: categoryView(context, listOfCategories ?? []),
    );
  }
}

Widget categoryView(BuildContext context, List<Categories>? carousel) {
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (ctx, index) => InkWell(
      onTap: () {
        if (carousel != null && carousel[index].childStatus == true) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return BlocProvider(
              create: (context) => CategoriesScreenBloc(
                repository: CategoriesScreenRepositoryImp(),
              ),
              child: SubCategoryView(
                name: carousel?[index].name,
                id: carousel?[index].path ?? "0",
              ),
            );
          }));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => CatalogScreenBloc(
                  repository: CatalogRepositoryImpl(),
                ),
                child: CatalogScreen(
                  categoryMap(carousel?[index].path ?? "0",
                      carousel?[index].name ?? "", ""),
                ),
              ),
            ),
          );
        }
      },
      child: categoryItem(context, carousel?[index]),
    ),
    separatorBuilder: (ctx, index) {
      return const SizedBox(
        height: AppSizes.size4,
        child: Divider(),
      );
    },
    itemCount: (carousel?.length ?? 0),
  );
}

Widget categoryItem(BuildContext context, Categories? item) {
  return Container(
    padding: const EdgeInsets.only(
        top: AppSizes.size8, left: AppSizes.size8, right: AppSizes.size8),
    margin: const EdgeInsets.only(bottom: AppSizes.size1),
    color: Theme.of(context).cardColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: AppSizes.categoryListingImageSize,
              width: AppSizes.categoryListingImageSize,
              child: ImageView(
                url: item?.image,
                height: AppSizes.categoryListingImageSize,
                width: AppSizes.categoryListingImageSize,
              ),
            ),
            const SizedBox(width: AppSizes.size10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("${item?.name.toString() ?? " "}",
                      style: Theme.of(context).textTheme.bodyLarge
                      // .copyWith(fontSize: AppSizes.textSizeLarge, color: AppColors.textColorPrimary),
                      ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
