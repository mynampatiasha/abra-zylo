import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/network_manager/api_client.dart';

import '../../../common_widgets/bottom_sheet.dart';
import '../../../common_widgets/common_tool_bar.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/global_data.dart';
import '../../../helper/app_restart.dart';
import '../../../helper/app_shared_pref.dart';

void requestForSellerBottomSheet(BuildContext context) async {
  /*var availableLanguages = await AppSharedPref.getAvailableLanguages();
  var selectedLanguage = await AppSharedPref.getLanguage();


  void updateLanguage(StateSetter stateSetter, String code) async {
    stateSetter(() {
      isLoading = true;
    });
    var model = await ApiClient()
        .updateLanguage(await AppSharedPref.getWkToken(), code);
    if (model.error == 0) {
      AppSharedPref.setCustomerLanguage(code);
      AppRestart.rebirth(context);
    }
  }*/

  /* if (availableLanguages != null &&
      (availableLanguages.languages ?? []).isNotEmpty) {*/
  showMyModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (ctx) => Scaffold(
      appBar: commonToolBar(
          AppLocalizations.of(context)
                  ?.translate(AppStringConstant.toBecomeSeller) ??
              "",
          context,
          isLeadingEnable: true),
      body: StatefulBuilder(
        builder: (context, changeState) {
          return Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("title",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineSmall)),
              TextField(
                onChanged: (searchKey) {
                  print(searchKey);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)
                          ?.translate(AppStringConstant.searchManufacture) ??
                      "search manufacture",
                  hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
              ),
              widgetSpace(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("title",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineSmall)),
              TextField(
                onChanged: (searchKey) {
                  print(searchKey);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)
                          ?.translate(AppStringConstant.searchManufacture) ??
                      "search manufacture",
                  hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
              ),
              widgetSpace(),
              commonButton(context, () {}, "Submit")
            ],
          );
        },
      ),
    ),
  );
  // }
}
