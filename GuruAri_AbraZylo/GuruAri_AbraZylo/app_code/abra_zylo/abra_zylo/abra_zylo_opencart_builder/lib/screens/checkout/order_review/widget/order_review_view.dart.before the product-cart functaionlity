import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/payment_methods_list.dart';

import '../../../../common_widgets/privacy_policy_checkbox_widget.dart';
import '../../../../common_widgets/title_separated_card.dart';
import '../../../../common_widgets/widget_space.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import 'order_summary.dart';

class OrderReviewView extends StatelessWidget {
  OrderReviewView(
      {this.onPaymentMethodChange,
      this.orderReviewModel,
      this.paymentMethod,
      this.localizations,
      this.isCheckboxSelected,
      this.comment,
      this.isShippingRequired,
      this.isGuestCheckout,
      Key? key})
      : super(key: key);
  final VoidCallback? onPaymentMethodChange;
  final CheckoutReviewOrderModel? orderReviewModel;
  final CheckoutPaymentMethodModel? paymentMethod;
  final AppLocalizations? localizations;
  final Function(bool)? isCheckboxSelected;
  final Function(String)? comment;
  final bool? isShippingRequired;
  bool? isGuestCheckout;

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isGuestCheckout == false /*paymentMethod?.account!="guest"*/) ...[
          TitleSeparatedCard(
              (localizations?.translate(AppStringConstant.shippingInfo) ?? ""),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (isShippingRequired ?? false)
                    SizedBox(
                      width: AppSizes.deviceWidth,
                      child: TitleSeparatedCard(
                        (localizations?.translate(
                                AppStringConstant.shippingAddress) ??
                            ""),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: AppSizes.size10, right: AppSizes.size10),
                            child: _getFormattedShippingAddress(
                                orderReviewModel?.continu?.orderDetails ??
                                    OrderDetails())),
                        showDivider: false,
                        asCard: false,
                      ),
                    ),
                  SizedBox(
                    width: AppSizes.deviceWidth,
                    child: TitleSeparatedCard(
                      (localizations
                              ?.translate(AppStringConstant.billingAddress) ??
                          ""),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: AppSizes.size10, right: AppSizes.size10),
                          child: _getFormattedBillingAddress(
                              orderReviewModel?.continu?.orderDetails ??
                                  OrderDetails())),
                      showDivider: false,
                      asCard: false,
                    ),
                  ),
                  if (isShippingRequired ?? false)
                    SizedBox(
                      width: AppSizes.deviceWidth,
                      child: TitleSeparatedCard(
                        (localizations
                                ?.translate(AppStringConstant.shippingMethod) ??
                            ""),
                        Padding(
                          padding: const EdgeInsets.all(AppSizes.size8),
                          child: Text(orderReviewModel
                                  ?.continu?.orderDetails?.shippingMethod ??
                              ""),
                        ),
                        showDivider: false,
                        asCard: false,
                      ),
                    ),
                ],
              )),
        ],

        // payments methods
        TitleSeparatedCard(
            (localizations?.translate(AppStringConstant.paymentMethods) ?? ""),
            PaymentMethodsList(
              paymentMethod?.paymentMethods?.paymentMethodList ?? [],
              onPaymentMethodChange: () {
                onPaymentMethodChange!();
              },
            )),
        TitleSeparatedCard(
          (localizations?.translate(AppStringConstant.paymentComment) ?? ""),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 10, left: 10),
            child: TextField(
              onChanged: comment,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSizes.size4,
                  horizontal: AppSizes.size8,
                ),
                hintText:
                    localizations?.translate(AppStringConstant.comment) ?? "",
                hintStyle: TextStyle(
                  fontSize: AppSizes.size12,
                  color: AppColors.black,
                ),
                border: OutlineInputBorder(
                    gapPadding: AppSizes.size0,
                    borderSide: BorderSide(
                      color: AppColors.black,
                    )),
                focusedBorder: OutlineInputBorder(
                    gapPadding: AppSizes.size0,
                    borderSide: BorderSide(
                      color: AppColors.black,
                    )),
                enabledBorder: OutlineInputBorder(
                    gapPadding: AppSizes.size0,
                    borderSide: BorderSide(
                      color: AppColors.black,
                    )),
              ),
            ),
          ),
          showDivider: false,
          asCard: false,
        ),

        //agree field
        PrivacyPolicyCustomCheckbox(
          (value) {
            isCheckboxSelected!(value);
          },
          AppStringConstant.termAndCondition.localized(),
          paymentMethod?.paymentMethods?.textAgreeInfo,
          dark: darkMode,
        ),

        // order summary
        TitleSeparatedCard(
          (localizations?.translate(AppStringConstant.orderSummary) ?? ""),
          OrderSummary(
            orderReviewModel?.continu?.orderDetails?.products ?? [],
            localizations,
          ),
        ),

        // price details
        TitleSeparatedCard(
            (localizations?.translate(AppStringConstant.priceDetails) ?? ""),
            ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _priceItem(
                      orderReviewModel?.continu?.totals?[index].title ?? "",
                      orderReviewModel?.continu?.totals?[index].text
                              .toString() ??
                          "",
                      context);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    widgetSpace(1, AppSizes.size8),
                itemCount: orderReviewModel?.continu?.totals?.length ?? 0)),
      ],
    );
  }

  Widget _priceItem(String title, String price, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(AppSizes.size4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: AppSizes.size12, fontWeight: FontWeight.normal)),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      );

  /*
*
* Method to format the Shipping address
* */
  _getFormattedShippingAddress(OrderDetails orderDetails) {
    try {
      return Text(
        ((orderDetails.shippingFirstname != null &&
                    orderDetails.shippingFirstname.toString().isNotEmpty)
                ? orderDetails.shippingFirstname ?? ""
                : "") +
            " " +
            ((orderDetails.shippingLastname != null &&
                    orderDetails.shippingLastname.toString().isNotEmpty)
                ? orderDetails.shippingLastname ?? ""
                : "") +
            "\n"
                "${(orderDetails.shippingCompany != null && orderDetails.shippingCompany.toString().isNotEmpty) ? (orderDetails.shippingCompany ?? "") + ", \n" : ""}"
                "${(orderDetails.shippingAddress1 != null && orderDetails.shippingAddress1.toString().isNotEmpty) ? (orderDetails.shippingAddress1 ?? "") + ", \n" : ""}"
                "${(orderDetails.shippingAddress2 != null && orderDetails.shippingAddress2.toString().isNotEmpty) ? (orderDetails.shippingAddress2 ?? "") + ", \n" : ""}"
                "${(orderDetails.shippingCity != null && orderDetails.shippingCity.toString().isNotEmpty) ? (orderDetails.shippingCity ?? "") + ", \n" : ""}"
                "${(orderDetails.shippingZone != null && orderDetails.shippingZone.toString().isNotEmpty) ? (orderDetails.shippingZone ?? "") + ", \n" : ""}"
                "${(orderDetails.shippingPostcode != null && orderDetails.shippingPostcode.toString().isNotEmpty) ? (orderDetails.shippingPostcode ?? "") + ", \n" : ""}"
                "${(orderDetails.shippingCountry != null && orderDetails.shippingCountry.toString().isNotEmpty) ? (orderDetails.shippingCountry ?? "") + ", \n" : ""}"
                "${(orderDetails.telephone != null && orderDetails.telephone.toString().isNotEmpty) ? (orderDetails.telephone ?? "" + ", \n") : ""}",
        style: const TextStyle(fontSize: AppSizes.size14),
      );
    } catch (e, ex) {
      return const Text("");
    }
  }

  /*
  * Method to format the Shipping address
  * */
  _getFormattedBillingAddress(OrderDetails orderDetails) {
    try {
      return Text(
        ((orderDetails.paymentFirstname != null &&
                    orderDetails.paymentFirstname.toString().isNotEmpty)
                ? orderDetails.paymentFirstname ?? ""
                : "") +
            " " +
            ((orderDetails.paymentLastname != null &&
                    orderDetails.paymentLastname.toString().isNotEmpty)
                ? orderDetails.paymentLastname ?? ""
                : "") +
            "\n"
                "${(orderDetails.paymentCompany != null && orderDetails.paymentCompany.toString().isNotEmpty) ? (orderDetails.paymentCompany ?? "") + ", \n" : ""}"
                "${(orderDetails.paymentAddress1 != null && orderDetails.paymentAddress1.toString().isNotEmpty) ? (orderDetails.paymentAddress1 ?? "") + ", \n" : ""}"
                "${(orderDetails.paymentAddress2 != null && orderDetails.paymentAddress2.toString().isNotEmpty) ? (orderDetails.paymentAddress2 ?? "") + ", \n" : ""}"
                "${(orderDetails.paymentCity != null && orderDetails.paymentCity.toString().isNotEmpty) ? (orderDetails.paymentCity ?? "") + ", \n" : ""}"
                "${(orderDetails.paymentZone != null && orderDetails.paymentZone.toString().isNotEmpty) ? (orderDetails.paymentZone ?? "") + ", \n" : ""}"
                "${(orderDetails.paymentPostcode != null && orderDetails.paymentPostcode.toString().isNotEmpty) ? (orderDetails.paymentPostcode ?? "") + ", \n" : ""}"
                "${(orderDetails.paymentCountry != null && orderDetails.paymentCountry.toString().isNotEmpty) ? (orderDetails.paymentCountry ?? "") + ", \n" : ""}"
                "${(orderDetails.telephone != null && orderDetails.telephone.toString().isNotEmpty) ? (orderDetails.telephone ?? "") + ", \n" : ""}",
        style: const TextStyle(fontSize: AppSizes.size14),
      );
    } catch (e, ex) {
      return const Text("");
    }
    /*} else {

    }*/
  }
}
