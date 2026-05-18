import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';

import '../../../constants/app_constants.dart';

Widget orderIdContainer(BuildContext context, OrderDetailModel? _orderModel,
    AppLocalizations? _localization) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.mediumPadding),
          topRight: Radius.circular(AppSizes.mediumPadding)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSizes.mediumPadding,
        ),
        Text(
          '${_localization?.translate(AppStringConstant.orderId)} #${_orderModel?.orderId}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.lightGray),
        ),
        const SizedBox(
          height: AppSizes.mediumPadding,
        ),
        const Divider(
          thickness: 1,
          height: 1,
        ),
      ],
    ),
  );
}

Widget orderPlaceDateContainer(BuildContext context,
    OrderDetailModel? _orderModel, AppLocalizations? _localization) {
  return Container(
      color: Theme.of(context).cardColor,
      width: AppSizes.deviceWidth,
      padding: const EdgeInsets.symmetric(
          vertical: AppSizes.mediumPadding, horizontal: AppSizes.size8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localization?.translate(AppStringConstant.placedOn) ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.lightGray),
              ),
              SizedBox(
                height: AppSizes.linePadding,
              ),
              Text(
                _orderModel?.dateAdded ?? "",
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.linePadding,
                vertical: AppSizes.linePadding),
            color: (_orderModel
                        ?.histories?[(((_orderModel.histories?.length ?? 0) > 1)
                            ? (_orderModel.histories?.length ?? 1) - 1
                            : 0)]
                        .status
                        ?.toUpperCase() ==
                    "COMPLETE")
                ? AppColors.green
                : AppColors.yellow,
            child: Text(
              _orderModel
                      ?.histories?[(((_orderModel.histories?.length ?? 0) > 1)
                          ? (_orderModel.histories?.length ?? 1) - 1
                          : 0)]
                      .status ??
                  "".toUpperCase(),
              style: TextStyle(color: AppColors.white),
            ),
          )
        ],
      ));
}
