import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/network_manager/api_client.dart';

import '../../../common_widgets/bottom_sheet.dart';
import '../../../common_widgets/common_tool_bar.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/global_data.dart';
import '../../../helper/app_restart.dart';
import '../../../helper/app_shared_pref.dart';

void showLanguageBottomSheet(BuildContext context) async {
  var availableLanguages = await AppSharedPref.getAvailableLanguages();
  var selectedLanguage = await AppSharedPref.getLanguage();
  bool isLoading = false;

  void updateLanguage(StateSetter stateSetter, String code) async {
    stateSetter(() {
      isLoading = true;
    });
    var model = await ApiClient()
        .updateLanguage(await AppSharedPref.getWkToken(), code);
    if (model.error == 0) {
      // AppSharedPref.setIsArabicApp(false);
      AppSharedPref.setCustomerLanguage("en");
      AppRestart.rebirth(context);
    }
  }

  if (availableLanguages != null &&
      (availableLanguages.languages ?? []).isNotEmpty) {
    showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Scaffold(
        appBar: commonToolBar(AppStringConstant.language.localized(), context,
            isLeadingEnable: true),
        body: StatefulBuilder(
          builder: (context, changeState) {
            return Stack(
              children: [
                ListView.builder(
                    itemCount: availableLanguages.languages?.length,
                    itemBuilder: (context, index) {
                      var item = availableLanguages.languages?[index];
                      if (item == null) {
                        return Container();
                      }
                      return InkWell(
                        onTap: () async {
                          if (selectedLanguage != item.code) {
                            GlobalData.selectedLanguage = item.code ?? "";
                            updateLanguage(changeState, item.code ?? "");
                          }
                        },
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(AppSizes.size16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name ?? "",
                                style: selectedLanguage == item.code
                                    ? Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold)
                                    : null,
                              ),
                              selectedLanguage == item.code
                                  ? Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.black,
                                    )
                                  : SizedBox(),
                            ],
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
