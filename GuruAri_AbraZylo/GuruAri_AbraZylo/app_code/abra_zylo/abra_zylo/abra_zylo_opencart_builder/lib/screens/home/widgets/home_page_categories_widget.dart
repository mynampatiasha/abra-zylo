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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shop by Categories",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // handle view all categories
                },
                child: Row(
                  children: [
                    const Text(
                      "View All ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF673AB7),
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF673AB7)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              widget.categories?.length ?? 0,
              (index) => Expanded(
                child: categoryCardCircle(widget.categories?[index], index),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget categoryCardCircle(Categories? category, int index) {
    final List<List<Color>> gradients = [
      [const Color(0xFF1E3A8A), const Color(0xFF2563EB)], // Navy-Blue
      [const Color(0xFF6D28D9), const Color(0xFF8B5CF6)], // Purple
      [const Color(0xFFBE185D), const Color(0xFFEC4899)], // Pink
      [const Color(0xFFEA580C), const Color(0xFFF97316)], // Orange
      [const Color(0xFF0F766E), const Color(0xFF14B8A6)], // Teal
      [const Color(0xFF065F46), const Color(0xFF10B981)], // Green
      [const Color(0xFF9D174D), const Color(0xFFF43F5E)], // Rose
      [const Color(0xFF1D4ED8), const Color(0xFF60A5FA)], // Blue
    ];

    // Pick icon based on category name — matches actual server categories
    IconData _iconForCategory(String? name) {
      final n = (name ?? '').toLowerCase();

      // Zylo brand (logo placeholder — closest Material icon)
      if (n.contains('zylo')) return Icons.local_mall_outlined;

      // Electronics & Gadgets
      if (n.contains('electron') || n.contains('gadget') || n.contains('tech') || n.contains('mobile') || n.contains('phone')) return Icons.phone_android_outlined;

      // Fashion / Clothing
      if (n.contains('fashion') || n.contains('cloth') || n.contains('wear') || n.contains('apparel')) return Icons.checkroom_outlined;

      // Style & Accessories / Jewelry
      if (n.contains('style') || n.contains('accessor') || n.contains('jewel') || n.contains('watch')) return Icons.diamond_outlined;

      // Home & Living / Furniture / Decor
      if (n.contains('home') || n.contains('living') || n.contains('furniture') || n.contains('decor') || n.contains('interior')) return Icons.weekend_outlined;

      // Beauty / Cosmetics / Skincare
      if (n.contains('beauty') || n.contains('cosmetic') || n.contains('makeup') || n.contains('skin') || n.contains('care')) return Icons.spa_outlined;

      // Abra Store / General store
      if (n.contains('abra') || n.contains('store') || n.contains('shop')) return Icons.shopping_bag_outlined;

      // Luxury / Premium
      if (n.contains('luxury') || n.contains('premium') || n.contains('diamond')) return Icons.diamond_outlined;

      // Buyers & Sellers / Partner / Deal
      if (n.contains('buyer') || n.contains('seller') || n.contains('partner') || n.contains('deal') || n.contains('trade')) return Icons.handshake_outlined;

      // Sports & Fitness
      if (n.contains('sport') || n.contains('fitness') || n.contains('gym') || n.contains('outdoor')) return Icons.sports_outlined;

      // Food & Grocery
      if (n.contains('food') || n.contains('grocery') || n.contains('kitchen')) return Icons.local_grocery_store_outlined;

      // Books / Education
      if (n.contains('book') || n.contains('education') || n.contains('stationery')) return Icons.menu_book_outlined;

      // Toys / Kids
      if (n.contains('toy') || n.contains('kid') || n.contains('child') || n.contains('baby')) return Icons.toys_outlined;

      // Health / Medical
      if (n.contains('health') || n.contains('medical') || n.contains('pharma')) return Icons.health_and_safety_outlined;

      // Travel / Luggage
      if (n.contains('travel') || n.contains('luggage') || n.contains('bag')) return Icons.luggage_outlined;

      // Automotive / Cars
      if (n.contains('auto') || n.contains('car') || n.contains('vehicle') || n.contains('motor')) return Icons.directions_car_outlined;

      return Icons.category_outlined; // default fallback
    }

    final gradColors = gradients[index % gradients.length];

    return GestureDetector(
      onTap: () {
        widget.moveToCategory(index, int.parse(category?.path ?? "-1"));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              // Directly show the icon — no network image (CORS blocks on web)
              child: Center(
                child: Icon(
                  _iconForCategory(category?.name),
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category?.name ?? "",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
        ),
      );
  }
}

