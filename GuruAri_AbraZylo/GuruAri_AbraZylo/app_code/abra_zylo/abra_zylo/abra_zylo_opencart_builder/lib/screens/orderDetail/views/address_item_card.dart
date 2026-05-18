import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../constants/app_constants.dart';

Widget addressItemWithHeading(
    BuildContext context, String title, String address,
    {Widget? addressList,
    Widget? actions,
    bool? showDivider,
    bool? isElevated,
    VoidCallback? callback}) {
  return Card(
    elevation: (isElevated ?? true) ? AppSizes.linePadding : 0,
    child: Container(
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.size8,
                top: AppSizes.size8,
                right: AppSizes.size8,
                bottom: 0.0),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.lightGray),
            ),
          ),
          if (showDivider ?? false)
            const Divider(
              thickness: 1,
              height: 1,
            ),
          addressList ??
              addressItemCard(address, context,
                  actions: actions, isElevated: isElevated, callback: callback)
        ],
      ),
    ),
  );
}

Widget addressItemCard(String address, BuildContext context,
    {Widget? actions, bool? isElevated, VoidCallback? callback}) {
  return Card(
    color: Theme.of(context).cardColor,
    elevation: (isElevated ?? true) ? AppSizes.linePadding : 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: AppSizes.size8,
              top: 0.0,
              right: AppSizes.size8,
              bottom: 0.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (callback != null) ? callback : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Html(data: address)),
                // Text(address),
                if (callback != null)
                  const Icon(
                    Icons.navigate_next,
                    color: AppColors.lightGray,
                  )
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 0.5,
          height: 0.5,
        ),
        if (actions != null) actions,
      ],
    ),
  );
}
