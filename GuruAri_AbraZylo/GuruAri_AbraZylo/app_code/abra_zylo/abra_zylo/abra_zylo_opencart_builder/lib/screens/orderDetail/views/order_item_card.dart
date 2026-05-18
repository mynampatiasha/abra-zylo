import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';

Widget orderItemCard(OrderedProducts item, BuildContext context,
    AppLocalizations? _localization) {
  return Container(
    color: Theme.of(context).cardColor,
    padding: const EdgeInsets.only(top: AppSizes.normalPadding),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*   Expanded(
            flex: 1,
            child: Stack(children: <Widget>[
              ImageView(
                url: */ /*item.thumbNail*/ /*"",
                height: (AppSizes.deviceWidth / 2.5),
              ),
            ]),
          ),
          const SizedBox(
            width: AppSizes.size8,
          ),*/
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.linePadding),
                  child: Text(item.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                itemDetailView(
                    '${_localization?.translate(AppStringConstant.model)}',
                    item.model ?? '',
                    context),
                itemDetailView(
                    '${_localization?.translate(AppStringConstant.price)}',
                    item.price ?? '',
                    context),
                itemDetailView(
                    '${_localization?.translate(AppStringConstant.qty)}',
                    item.quantity.toString(),
                    context),
                /*itemDetailView(
                    '${_localization?.translate(AppStringConstant.subtotal)}',
                    item.price ?? '',
                    context),*/
                const SizedBox(
                  height: AppSizes.size8,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget itemDetailView(String key, String value, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: AppSizes.linePadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            key,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}
