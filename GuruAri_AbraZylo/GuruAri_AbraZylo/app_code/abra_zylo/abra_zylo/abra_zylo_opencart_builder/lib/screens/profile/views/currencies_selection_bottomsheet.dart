import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import '../../../common_widgets/bottom_sheet.dart';
import '../../../common_widgets/common_tool_bar.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_restart.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../network_manager/api_client.dart';

void showCurrenciesBottomSheet(BuildContext context) async {
  var availableCurrencies = await AppSharedPref.getAvailableCurrencies();
  var selectedCurrency = await AppSharedPref.getCurrency();
  bool isLoading = false;

  void updateCurrency(StateSetter stateSetter, String code) async {
    stateSetter(() {
      isLoading = true;
    });
    var model = await ApiClient()
        .updateCurrency(await AppSharedPref.getWkToken(), code);
    if (model.error == 0) {
      AppSharedPref.setCurrency(code);
      AppRestart.rebirth(context);
    }
  }

  if (availableCurrencies != null &&
      (availableCurrencies.currencies ?? []).isNotEmpty) {
    showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Scaffold(
        appBar: commonToolBar(AppStringConstant.language.localized(), context,
            isLeadingEnable: true),
        body: StatefulBuilder(
          builder: (context, updateState) {
            return Stack(
              children: [
                ListView.builder(
                    itemCount: availableCurrencies.currencies?.length,
                    itemBuilder: (context, index) {
                      var item = availableCurrencies.currencies?[index];
                      if (item == null) {
                        return Container();
                      }
                      return InkWell(
                        onTap: () {
                          if (selectedCurrency != item.code) {
                            updateCurrency(updateState, item.code ?? "");
                          }
                        },
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(AppSizes.size16),
                          child: Text(
                            item.title ?? "",
                            style: selectedCurrency == item.code
                                ? Theme.of(context).textTheme.headlineSmall
                                : null,
                          ),
                        ),
                      );
                    }),
                if (isLoading) Center(child: Loader())
              ],
            );
          },
        ),
      ),
    );
  }
}
