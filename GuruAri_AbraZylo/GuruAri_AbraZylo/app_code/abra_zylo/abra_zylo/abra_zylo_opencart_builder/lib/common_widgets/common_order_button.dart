import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../constants/app_constants.dart';
import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';

Widget commonOrderButton(BuildContext context, AppLocalizations? _localizations,
    String amount, VoidCallback onPressed,
    {Color color = MobikulTheme.accentColor,
    String title = AppStringConstant.proceed}) {
  return Container(
    height: 60,
    color: Theme.of(context).cardColor,
    padding: const EdgeInsets.only(left: AppSizes.size8, right: AppSizes.size8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _localizations?.translate(AppStringConstant.amountToBePaid) ??
                    "",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: AppSizes.size12, color: AppColors.darkGray),
              ),
              Text(amount,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        Expanded(
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.size12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  // shape: const RoundedRectangleBorder(
                  //
                  //     borderRadius: BorderRadius.zero
                ),
                elevation: 0,
              ),
              // style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              //       // backgroundColor: MaterialStatePropertyAll(Colors.black),
              //       padding: MaterialStateProperty.all<EdgeInsets>(
              //           const EdgeInsets.all(AppSizes.size12)),
              //     ),
              child: Text(
                (_localizations?.translate(title) ?? "").toUpperCase(),
              )

              // ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric( vertical: AppSizes.size16),
              //     // shape: const RoundedRectangleBorder(
              //     //     borderRadius: BorderRadius.zero
              //     // ),
              //     elevation: 0,
              //     primary: color),
              ),
        )
      ],
    ),
  );
}
