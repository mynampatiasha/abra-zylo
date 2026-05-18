import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import '../../../constants/app_constants.dart';
import '../../../models/downloadProductModel/download_product_model.dart';
import '../../../network_manager/download_file.dart';

Widget downloadProductItem(
    BuildContext context, DownloadData? item, AppLocalizations? localizations) {
  Widget getListItem(String key, String value) {
    return Row(
      children: [
        Expanded(child: Text(key)),
        const Text(":"),
        Expanded(
            child: Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        )),
      ],
    );
  }

  return Container(
    padding: const EdgeInsets.only(
        top: AppSizes.size8, left: AppSizes.size8, right: AppSizes.size8),
    margin: const EdgeInsets.only(bottom: AppSizes.size8),
    color: Theme.of(context).cardColor,
    child: Card(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.size8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "${localizations?.translate(AppStringConstant.orderId) ?? ""} #${item?.orderId.toString() ?? " "}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      //Download functionality
                      Download().downloadProduct(item, context);
                    },
                    icon: const Icon(Icons.download)),
                // Edit labelLarge
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            getListItem(localizations?.translate(AppStringConstant.name) ?? "",
                item?.name ?? ""),
            const SizedBox(
              height: AppSizes.size14,
            ),
            getListItem(localizations?.translate(AppStringConstant.sizee) ?? "",
                item?.size ?? ""),
            const SizedBox(
              height: AppSizes.size14,
            ),
            getListItem(
                localizations?.translate(AppStringConstant.dateAdded) ?? "",
                item?.dateAdded ?? ""),
          ],
        ),
      ),
    ),
  );
}
