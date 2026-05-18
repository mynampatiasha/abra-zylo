import 'package:flutter/material.dart';
import 'package:oc_demo/models/checkout/checkout_address_model.dart';

import '../../../../common_widgets/common_outlined_button.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../helper/app_shared_pref.dart';

class ChangeAddress extends StatelessWidget {
  const ChangeAddress(this.localizations, this.checkoutAddress, this.type,
      this.isShippingAddressSameAsBillingAddress,
      {this.onAddressUpdate, Key? key})
      : super(key: key);
  final AppLocalizations? localizations;
  final CheckoutAddressModel? checkoutAddress;
  final int type;
  final bool isShippingAddressSameAsBillingAddress;
  final VoidCallback? onAddressUpdate;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var address = checkoutAddress?.addresses?[index];
        return Container(
          margin: const EdgeInsets.all(AppSizes.size6),
          decoration: BoxDecoration(
            border: Border.all(),
          ),

          child: /* GestureDetector(
            onTap: () {
              if (type == 0) {
                AppSharedPref.setBillingAddressId(address?.addressId ?? "0");

              } else {
                AppSharedPref.setShippingAddressId(address?.addressId ?? "0");
              }
              if (onAddressUpdate != null) {
                onAddressUpdate!();
              }
              Navigator.of(context).pop(true);
            },
            child: */
              Padding(
                  padding: const EdgeInsets.all(AppSizes.size8),
                  child: Column(
                    children: [
                      Text(address?.formatted ?? ""),
                      SizedBox(
                        height: AppSizes.size8,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: commonButton(context, () async {
                          print(
                              "pankj ${isShippingAddressSameAsBillingAddress}");
                          if (type == 0) {
                            AppSharedPref.setBillingAddressId(
                                address?.addressId ?? "0");
                            if (isShippingAddressSameAsBillingAddress) {
                              AppSharedPref.setShippingAddressId(
                                  address?.addressId ?? "0");
                            }
                          } else {
                            AppSharedPref.setShippingAddressId(
                                address?.addressId ?? "0");
                          }
                          if (onAddressUpdate != null) {
                            onAddressUpdate!();
                          }
                          Navigator.of(context).pop(true);
                        },
                            localizations?.translate(
                                    AppStringConstant.selectThisAddress) ??
                                "",
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            textColor: AppColors.white,
                            width: AppSizes.deviceWidth / 2.5,
                            height: AppSizes.deviceHeight / 24),
                      ),
                    ],
                  )),
          // ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: AppSizes.size8);
      },
      itemCount: checkoutAddress?.addresses?.length ?? 0,
    );
  }
}
