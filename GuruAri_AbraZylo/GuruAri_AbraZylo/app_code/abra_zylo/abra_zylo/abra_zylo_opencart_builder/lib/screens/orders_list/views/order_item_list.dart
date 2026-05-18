import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';

import '../../../helper/open_bottom_model_sheet_helper.dart';

Future orderItemList(BuildContext context, List<OrderedProducts> items,
    AppLocalizations? _localizations) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Theme.of(context).cardColor,
                width: AppSizes.deviceWidth,
                padding: const EdgeInsets.all(AppSizes.size8),
                margin: const EdgeInsets.only(bottom: AppSizes.size8),
                child: Text(
                  (_localizations?.translate("Choose Product") ??
                      "".toUpperCase()),
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      reviewBottomModalSheet(context, items[index].name ?? '',
                          '', items[index].productId ?? "");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.size8),
                      margin: const EdgeInsets.only(bottom: AppSizes.size8),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Image
                          // ImageView(
                          //   // url: items[index].thumbNail,
                          //   url: "",
                          //   width: AppSizes.deviceWidth / 4,
                          // ),

                          const SizedBox(width: AppSizes.size16),

                          Expanded(
                            child: Text(items[index].name ?? ''),
                          ),

                          // Edit labelLarge
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      });
}
