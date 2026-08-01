import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/views/order_heading_view.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';

Widget orderPriceDetails(OrderDetailModel model, BuildContext context,
    AppLocalizations? localizations) {
  
  List<OrderTotals> updatedTotals = [];
  double subTotalVal = 0.0;
  String currencyPrefix = "₹";
  
  for (var t in (model.totals ?? [])) {
    if ((t.title ?? '').toLowerCase().contains('sub-total')) {
      String text = t.text ?? '';
      currencyPrefix = text.replaceAll(RegExp(r'[0-9.,]'), '');
      String numStr = text.replaceAll(RegExp(r'[^0-9.]'), '');
      subTotalVal = double.tryParse(numStr) ?? 0.0;
    }
  }

  double shippingVal = subTotalVal < 499.0 ? 1.0 : 0.0;
  double totalVal = subTotalVal + shippingVal;

  bool addedShipping = false;
  
  for (var t in (model.totals ?? [])) {
    String title = t.title ?? '';
    if (title.toLowerCase().contains('sub-total')) {
      updatedTotals.add(t);
    } else if (title.toLowerCase().contains('shipping')) {
      updatedTotals.add(OrderTotals(title: title, text: '$currencyPrefix${shippingVal.toStringAsFixed(2)}'));
      addedShipping = true;
    } else if (title.toLowerCase().contains('total')) {
      if (!addedShipping) {
         updatedTotals.add(OrderTotals(title: 'Shipping', text: '$currencyPrefix${shippingVal.toStringAsFixed(2)}'));
         addedShipping = true;
      }
      updatedTotals.add(OrderTotals(title: title, text: '$currencyPrefix${totalVal.toStringAsFixed(2)}'));
    } else {
      updatedTotals.add(t);
    }
  }

  return orderHeaderLayout(
      context,
      localizations?.translate(AppStringConstant.priceDetails) ?? "",
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
        child: Column(
          children: updatedTotals
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
