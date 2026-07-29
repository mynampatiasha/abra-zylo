import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/global_data.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_constants.dart';
import '../bloc/categories_screen_bloc.dart';

class MainCategoryList extends StatefulWidget {
  const MainCategoryList(
      this.categoriesScreenBloc, this.onCategoryReselected, this.selectedIndex,
      {Key? key})
      : super(key: key);

  final int selectedIndex;
  final CategoriesScreenBloc? categoriesScreenBloc;
  final ValueChanged<String?> onCategoryReselected;

  @override
  State<MainCategoryList> createState() => _MainCategoryListState();
}

class _MainCategoryListState extends State<MainCategoryList> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  IconData _getIconForCategory(String name) {
    String lowerName = name.toLowerCase();
    if (lowerName.contains('zylo')) return Icons.shopping_bag_outlined;
    if (lowerName.contains('abra store')) return Icons.storefront_outlined;
    if (lowerName.contains('luxury')) return Icons.workspace_premium_outlined;
    if (lowerName.contains('buyers') || lowerName.contains('sellers') || lowerName.contains('vendor')) return Icons.people_outline;
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.deviceWidth / 3.2,
      height: AppSizes.deviceHeight,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: GlobalData.rootCategories?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            bool isSelected = _selectedIndex == index;
            String catName = GlobalData.rootCategories?[index].name ?? "";
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onCategoryReselected(GlobalData.rootCategories?[index].path);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF3E5F5) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getIconForCategory(catName),
                      size: 20,
                      color: isSelected ? const Color(0xFF673AB7) : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        catName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF673AB7) : Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
