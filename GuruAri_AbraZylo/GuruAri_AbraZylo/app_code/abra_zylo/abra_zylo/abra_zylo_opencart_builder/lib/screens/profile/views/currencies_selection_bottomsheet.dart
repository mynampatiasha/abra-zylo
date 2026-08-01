import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import 'package:oc_demo/common_widgets/bottom_sheet.dart';
import 'package:oc_demo/common_widgets/common_tool_bar.dart';
import 'package:oc_demo/screens/profile/views/profile_detail_screen.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_restart.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../network_manager/api_client.dart';
import '../../../constants/global_data.dart';

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
    Navigator.push(context, MaterialPageRoute(builder: (_) => 
      ProfileDetailScreen(
        title: AppStringConstant.currency.localized(),
        content: StatefulBuilder(
          builder: (context, changeState) {
            return Stack(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: availableCurrencies.currencies?.length,
                    itemBuilder: (context, index) {
                      var item = availableCurrencies.currencies?[index];
                      if (item == null) {
                        return Container();
                      }
                      return InkWell(
                        onTap: () async {
                          if (selectedCurrency != item.code) {
                            updateCurrency(changeState, item.code ?? "");
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
                                item.title ?? "",
                                style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: selectedCurrency == item.code ? FontWeight.w700 : FontWeight.w600,
                                  fontSize: 15,
                                  color: selectedCurrency == item.code ? const Color(0xFF5232a8) : const Color(0xFF2b2540),
                                ),
                              ),
                              if (selectedCurrency == item.code)
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
