import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/views/order_heading_view.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';

Widget orderPriceDetails(OrderDetailModel model, BuildContext context,
    AppLocalizations? localizations) {
  return orderHeaderLayout(
      context,
      localizations?.translate(AppStringConstant.priceDetails) ?? "",
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
        child: Column(
          children: (model.totals ?? [])
              .map((e) =>
                  orderPriceDetailsItem(e.title ?? "", e.text ?? "", context))
              .toList(),
        ),
      ));
}

Widget orderPriceDetailsItem(String key, String value, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          key,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}
