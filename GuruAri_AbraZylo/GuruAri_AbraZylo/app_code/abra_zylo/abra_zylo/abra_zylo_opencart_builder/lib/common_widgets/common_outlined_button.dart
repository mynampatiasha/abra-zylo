import 'package:flutter/material.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/screens/splash/splash_screen.dart';

import '../constants/app_constants.dart';

Widget commonButton(BuildContext context, VoidCallback onPressed, String text,
    {double? width,
    double? height,
    Color? textColor,
    Color? backgroundColor,
    Color? borderSideColor}) {
  borderSideColor ??= Theme.of(context).colorScheme.onPrimary;
  return ElevatedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
        //shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: BorderSide(
          //color: borderSideColor,
          width: AppSizes.size2,
          style: BorderStyle.solid,
          color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
        ),
        minimumSize: Size((width != null) ? width : AppSizes.deviceWidth,
            (height != null) ? height : AppSizes.deviceHeight / 16),
        backgroundColor: backgroundColor
        //   Theme.of(context).colorScheme.onPrimary

        ),
    child: Text(
      text,
      // style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor
      style: TextStyle(
          color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
    ),
  );
}
