import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/global_data.dart';

import '../../../models/homPage/home_screen_model.dart';

Widget getSearchCategorySuggestion(List<Categories>? categories) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: (categories ?? [])
          .map((e) => Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoute.category, arguments: {
                      "selectedIndex":
                          GlobalData.rootCategories?.indexOf(e) ?? 0,
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF673AB7).withOpacity(0.08),
                      border: Border.all(color: const Color(0xFF673AB7).withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      e.name ?? "",
                      style: const TextStyle(
                        color: Color(0xFF673AB7),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }))
          .toList(),
    ),
  );
}
