import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/generic_methods.dart';

Widget buildReachBottomView(
    BuildContext context, ScrollController _scrollController) {
  return Container(
    width: AppSizes.deviceWidth,
    margin: const EdgeInsets.symmetric(vertical: AppSizes.size8),
    padding: const EdgeInsets.only(
        top: AppSizes.size15, bottom: (AppSizes.size15 + AppSizes.size15)),
    // color: AppColors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          GenericMethods.getStringValue(
              context, AppStringConstant.youHaveReachedToTheBottomOfThePage),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        widgetSpace(),
        TextButton(
            onPressed: () {
              _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            child: Text(GenericMethods.getStringValue(
                context, AppStringConstant.backToTop))),
      ],
    ),
  );
}
