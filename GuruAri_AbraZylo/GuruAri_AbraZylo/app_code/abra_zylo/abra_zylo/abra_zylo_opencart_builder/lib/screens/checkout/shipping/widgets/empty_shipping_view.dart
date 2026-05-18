import 'package:flutter/material.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';

class EmptyShippingView extends StatelessWidget {
  const EmptyShippingView(this.onAddAddressSuccess, this.localizations,
      {Key? key})
      : super(key: key);

  final ValueChanged<bool> onAddAddressSuccess;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size8,
            vertical: AppSizes.size16,
          ),
          child: Text(
              localizations?.translate(AppStringConstant.somethingWentWrong) ??
                  ""),
        ),
        const Divider(height: 0),
        TextButton.icon(
          onPressed: () {
            onAddAddressSuccess(true);
          },
          icon: const Icon(Icons.refresh),
          label: Text((localizations?.translate(AppStringConstant.retry) ?? "")
              .toUpperCase()),
          style: TextButton.styleFrom(
            minimumSize: Size(AppSizes.deviceWidth, AppSizes.size40),
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}
