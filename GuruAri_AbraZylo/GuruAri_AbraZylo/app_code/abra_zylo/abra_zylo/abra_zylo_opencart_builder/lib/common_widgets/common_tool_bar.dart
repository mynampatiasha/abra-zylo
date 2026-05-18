import 'package:flutter/material.dart';
import 'package:oc_demo/config/theme.dart';

AppBar commonToolBar(String heading, BuildContext context,
    {bool isElevated = true, bool isLeadingEnable = false}) {
  return AppBar(
    leading: isLeadingEnable
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: MobikulTheme.iconColor,
            ))
        : const BackButton(color: MobikulTheme.iconColor),
    elevation: isElevated ? null : 0,
    title: Row(
      children: [
        Text(
          heading,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: MobikulTheme.iconColor),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
      ],
    ),
  );
}
