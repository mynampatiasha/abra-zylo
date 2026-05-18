/*
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/constants/global_data.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/generic_methods.dart';
import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageCategories extends StatefulWidget {
  const HomePageCategories(this.categories,this.moveToCategory, {Key? key}) : super(key: key);

  final List<Categories>? categories;
  final Function(int) moveToCategory;

  @override
  _HomePageCategoriesState createState() => _HomePageCategoriesState();
}

class _HomePageCategoriesState extends State<HomePageCategories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: AppSizes.size10, top: AppSizes.size10,right: AppSizes.size10,bottom: 0.0),
          child: Text(
              GenericMethods.getStringValue(
                  context, AppStringConstant.categories),
    style: Theme.of(context).textTheme.headlineMedium),
        ),
        widgetSpace(0, AppSizes.size16),
        Container(
            padding: const EdgeInsets.only(
                left: */
/*AppSizes.size8*/ /*
0,
                top: AppSizes.size2,
                right: */
/*AppSizes.size8*/ /*
0),
            width: AppSizes.deviceWidth,
            height: AppSizes.deviceHeight / 5.5,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories?.length,
                itemBuilder: (context, index) {
                  var data=widget.categories?[index];
                  PrefetchService.preFetchCategoryData(data?.path);
                  // PrefetchService.preFetchCategoryProduct(data?.path);
                  return categoryCardCircle(widget.categories?[index], index);
                }))
      ],
    );
  }

  Widget categoryCardCircle(Categories? category, int index) {
    return GestureDetector(
        onTap: () {
            var index = GlobalData.rootCategories?.indexOf(category!);
            widget.moveToCategory(index ?? 0);
        },
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Container(
                  width: AppSizes.deviceWidth / 5.5,
                  height: AppSizes.deviceWidth / 5.5,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: AppColors.lightGray),
                  child: CircleAvatar(
                    backgroundColor:AppColors.white ,
                    backgroundImage: NetworkImage(category?.image ?? ''),
                  ),
                ),
                const SizedBox(
                  height:AppSizes.size6,),
                SizedBox(
                    width: AppSizes.deviceWidth / 4.75,
                    child: Text(
                      category?.name ?? "",
                      style: Theme.of(context).textTheme.bodySmall?.
                      copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize:12
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ))
              ],
            )));
  }
}
*/
//
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/constants/global_data.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/generic_methods.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageCategories extends StatefulWidget {
  const HomePageCategories(this.title, this.categories, this.moveToCategory,
      {Key? key})
      : super(key: key);

  final List<Categories>? categories;
  final String title;
  final Function(int, int) moveToCategory;

  @override
  _HomePageCategoriesState createState() => _HomePageCategoriesState();
}

class _HomePageCategoriesState extends State<HomePageCategories> {
  @override
  void initState() {
    GlobalData.carouselCategory = widget.categories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: AppSizes.size8, top: AppSizes.size16),
          child: Text(
              widget.title ?? ""
              /*GenericMethods.getStringValue(
                  context, AppStringConstant.categories)*/
              ,
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        widgetSpace(0, AppSizes.size16),
        Container(
            // color: Colors.red,
            padding: const EdgeInsets.only(
                left: AppSizes.size8,
                top: AppSizes.size8,
                right: AppSizes.size8),
            width: AppSizes.deviceWidth,
            height: AppSizes.deviceHeight / 7,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories?.length,
                itemBuilder: (context, index) {
                  return categoryCardCircle(widget.categories?[index], index);
                }))
      ],
    );
  }

  Widget categoryCardCircle(Categories? category, int index) {
    return GestureDetector(
        onTap: () {
          // var index = GlobalData.rootCategories?.indexOf(category!);
          //  var index = ca.indexOf(category!);
          widget.moveToCategory(index ?? 0, int.parse(category?.path ?? "-1"));
        },
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Container(
                  width: AppSizes.deviceWidth / 6,
                  height: AppSizes.deviceWidth / 6,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(ApiConstant.imageUrl(category?.image ?? '')),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                    width: AppSizes.deviceWidth / 4,
                    child: Text(
                      category?.name ?? "",
                      style: const TextStyle(fontSize: 11),
                      //  style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ))
              ],
            )));
  }
}
