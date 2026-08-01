import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/network_manager/api_client.dart';
import 'package:oc_demo/screens/profile/views/profile_detail_screen.dart';

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
    Navigator.push(context, MaterialPageRoute(builder: (_) => 
      ProfileDetailScreen(
        title: AppStringConstant.language.localized(),
        content: StatefulBuilder(
          builder: (context, changeState) {
            return Stack(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFece7f3))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name ?? "",
                                style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: selectedLanguage == item.code ? FontWeight.w700 : FontWeight.w600,
                                  fontSize: 15,
                                  color: selectedLanguage == item.code ? const Color(0xFF5232a8) : const Color(0xFF2b2540),
                                ),
                              ),
                              if (selectedLanguage == item.code)
                                const Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: Color(0xFF5232a8),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                if (isLoading) const Center(child: Loader())
              ],
            );
          },
        ),
      )
    ));
  }
}
