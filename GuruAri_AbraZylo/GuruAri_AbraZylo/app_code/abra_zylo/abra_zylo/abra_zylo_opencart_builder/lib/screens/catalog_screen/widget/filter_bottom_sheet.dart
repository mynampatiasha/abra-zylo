import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/catalog/filter.dart';
import 'package:oc_demo/models/catalog/filter_group.dart';
import 'package:oc_demo/screens/catalog_screen/widget/checkbox_tile.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet(this.filters, this.onFilter, this.selectedFilters,
      {super.key});
  final List<FilterGroup>? filters;
  final VoidCallback onFilter;
  final String? selectedFilters;

  @override
  Widget build(BuildContext context) {
    print("selected filter is  >>>${selectedFilters}");
    return Column(
      children: <Widget>[
        AppBar(
          elevation: 0,
          title: Text(
            AppStringConstant.filterBy.localized().toUpperCase(),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          automaticallyImplyLeading: false,
          // Uncomment this if you require a close labelLarge
          // leading: const CloseButton(),
          actions: <Widget>[
            TextButton(
              onPressed: onFilter,
              child: Text(
                AppStringConstant.apply.localized(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, idx) {
              return _listElement(
                "${filters?.elementAt(idx).name}",
                filters?.elementAt(idx).filter,
                context,
              );
            },
            itemCount: filters?.length ?? 0,
          ),
        ),
      ],
    );
  }

  Widget _listElement(
    String title,
    List<Filter>? filter,
    BuildContext context,
  ) {
    if (selectedFilters != null) {
      var filters = selectedFilters!.split(",");
      filter?.forEach((element) {
        print("filter items are ${filter}");
        if (filters.contains(element.filterId)) element.selected = true;
      });
    }
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "Roboto"),
          ),
          StatefulBuilder(
            builder: (ctx, setState) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) =>
                  CheckboxTile(filter?.elementAt(index), () {
                setState(() {});
              }),
              itemCount: filter?.length ?? 0,
            ),
          )
        ],
      ),
    );
  }
}
