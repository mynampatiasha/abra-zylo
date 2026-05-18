import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/returnOrderListModel/return_order_list_model.dart';

Widget returnMainView(BuildContext context, List<ReturnListData>? orders,
    AppLocalizations? localizations, ScrollController controller,
    {ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics()}) {
  return ListView.separated(
    controller: controller,
    shrinkWrap: true,
    physics: scrollPhysics,
    itemBuilder: (ctx, index) =>
        returnOrderItem(context, orders?[index], localizations),
    separatorBuilder: (ctx, index) => Container(),
    itemCount: (orders?.length ?? 0),
  );
}

Widget returnOrderItem(BuildContext context, ReturnListData? item,
    AppLocalizations? localizations) {
  return Container(
    padding: const EdgeInsets.only(
        top: AppSizes.size12, left: AppSizes.size8, right: AppSizes.size8),
    margin: const EdgeInsets.only(bottom: AppSizes.size8),
    // color: Theme.of(context).cardColor,
    child: Card(
      //color: Colors.lightBlueAccent,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.size14,
                right: AppSizes.size14,
                top: AppSizes.size18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "#${item?.name.toString() ?? " "}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSizes.size8),
                        // statusContainer(context, item?.status ?? ''),
                        const SizedBox(height: AppSizes.size8),
                        const Text(
                          "Order date",
                        ),
                        const SizedBox(height: AppSizes.size4),
                        Text(
                          item?.dateAdded ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: AppSizes.size8),
                        const Text(
                          "Order Id",
                        ),
                        const SizedBox(height: AppSizes.size4),
                        Text(
                          item?.orderId ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: AppSizes.size8),
                        const Text(
                          "Return id",
                        ),
                        const SizedBox(height: AppSizes.size4),
                        Text(
                          item?.returnId ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: AppSizes.size8),
                      ],
                    ),
                  ),
                ),

                statusContainer(context, item?.status ?? ''),

                // Edit labelLarge
              ],
            ),
          ),
          const Divider(
            thickness: 1.5,
            color: AppColors.lightGray,
          ),
          TextButton(
            // style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.returnDetail,
                  arguments: item?.returnId ?? "");
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  Text(
                      "View Details".toUpperCase()
                          // localizations?.translate(
                          //         AppStringConstant.viewDetail.toUpperCase())
                          ??
                          "",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)
                      //?.copyWith(color: Theme.of(context).

                      ),
                ],
              ),
            ),
          ),
          // style: ElevatedButton.styleFrom(
          //   padding: EdgeInsets.zero,
          //   primary: Theme.of(context).colorScheme.onPrimary,
          //   // shape: RoundedRectangleBorder(
          //   //     borderRadius: BorderRadius.zero
          //   // ),
          // ),
          //),
        ],
      ),
    ),
  );
}

Widget statusContainer(BuildContext context, String status) {
  return Container(
    color: containerColor(status),
    padding: const EdgeInsets.symmetric(
        vertical: AppSizes.size8, horizontal: AppSizes.size8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Text(
          status,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.white),
        )),
      ],
    ),
  );
}

Color containerColor(String status) {
  switch (status.toUpperCase()) {
    case 'COMPLETE':
      return AppColors.green;
    default:
      return AppColors.yellow;
  }
}
