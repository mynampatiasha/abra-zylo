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
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, -4),
          blurRadius: 10,
        )
      ],
    ),
    child: SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _localizations?.translate(AppStringConstant.amountToBePaid) ?? "Amount to be paid",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(amount,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    )),
                Text(
                  "(Inclusive of all taxes)",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (_localizations?.translate(title) ?? "PROCEED TO CHECKOUT").toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                    ],
                  )
              ),
            ),
          )
        ],
      ),
    ),
  );
}
