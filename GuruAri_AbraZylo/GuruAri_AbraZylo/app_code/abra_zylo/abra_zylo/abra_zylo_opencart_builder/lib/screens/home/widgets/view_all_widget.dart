import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../../../helper/generic_methods.dart';

Widget viewAllButton(
    BuildContext context, var title, final Function onClickAction, int length) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 2,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 0.0, bottom: 0, right: 10, left: 10),
          child: Text(title ?? "",
              style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
      Expanded(
        flex: 1,
        child: Visibility(
          visible: true,
          child: Container(
              margin: const EdgeInsets.only(
                  right: AppSizes.size8, left: AppSizes.size8),
              height: AppSizes.size30,
              child: TextButton(
                onPressed: () {
                  onClickAction();
                },
                child: Text(
                  GenericMethods.getStringValue(
                          context, AppStringConstant.viewAll)
                      .toUpperCase(),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headlineMedium!.color,
                      fontSize: AppSizes.size12),
                ),
                // style: OutlinedButton.styleFrom(
                //   side: const BorderSide(
                //       width: AppSizes.size2,
                //
                //       style: BorderStyle.solid),
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                // ),
              )),
        ),
      ),
    ],
  );
}
