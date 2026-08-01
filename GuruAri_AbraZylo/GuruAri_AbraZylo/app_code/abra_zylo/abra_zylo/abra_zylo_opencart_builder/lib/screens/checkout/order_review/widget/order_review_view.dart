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
                if (isGuestCheckout == false && (isShippingRequired ?? false)) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations?.translate(AppStringConstant.shippingInfo) ?? "Shipping Info",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Shipping Address Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            localizations?.translate(AppStringConstant.shippingAddress) ?? "Shipping Address",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (orderReviewModel?.continu?.orderDetails == null)
                        Row(
                          children: [
                            SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text("Loading address...", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                          ],
                        )
                      else
                        _getFormattedShippingAddress(orderReviewModel!.continu!.orderDetails!),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Shipping Method Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_shipping_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            localizations?.translate(AppStringConstant.shippingMethod) ?? "Shipping Method",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (orderReviewModel?.continu?.orderDetails?.shippingMethod == null ||
                          (orderReviewModel?.continu?.orderDetails?.shippingMethod?.isEmpty ?? true))
                        Row(
                          children: [
                            SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text("Loading method...", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                          ],
                        )
                      else
                        Text(
                          orderReviewModel!.continu!.orderDetails!.shippingMethod ?? "",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
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
        if (orderReviewModel?.continu?.totals != null && orderReviewModel!.continu!.totals!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.translate(AppStringConstant.priceDetails) ?? "Price Summary",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 12),
                  ...List.generate(orderReviewModel!.continu!.totals!.length, (index) {
                    final item = orderReviewModel!.continu!.totals![index];
                    final isTotal = item.title?.toLowerCase() == 'total';
                    if (isTotal) return const SizedBox(); // Skip total for now
                    
                    bool isFree = item.text?.toLowerCase() == 'free' || item.text == '₹0.00' || item.text == '0' || item.text == '₹0';
                    String title = item.title ?? '';
                    if (title.toLowerCase() == 'sub-total') title = 'Total MRP';
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            isFree ? 'FREE' : (item.text ?? ''),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isFree ? FontWeight.w700 : FontWeight.w600,
                              color: isFree ? Colors.green : (title.toLowerCase().contains('discount') ? Colors.green : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(color: Colors.grey.shade300, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Final Payable Amount:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        orderReviewModel!.continu!.totals!.lastWhere((element) => element.title?.toLowerCase() == 'total', orElse: () => orderReviewModel!.continu!.totals!.last).text ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      final discountItem = orderReviewModel!.continu!.totals!.where((element) => 
                        element.title?.toLowerCase().contains('discount') == true ||
                        element.title?.toLowerCase().contains('coupon') == true
                      ).firstOrNull;
                      
                      if (discountItem != null && discountItem.text != null && discountItem.text!.isNotEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade100),
                          ),
                          child: Center(
                            child: Text(
                              "You will save ${discountItem.text?.replaceAll('-', '')} on this order",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    }
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

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
