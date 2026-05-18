import 'package:oc_demo/models/checkout/checkout_confirm_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helper/app_shared_pref.dart';
import '../../../../network_manager/api_client.dart';

abstract class OrderReviewScreenRepository {
  Future<CheckoutPaymentMethodModel?> getPaymentMethods(String comment);
  Future<CheckoutPaymentMethodModel?> getPaymentMethodWhenShippingNotRequired();
  Future<CheckoutReviewOrderModel?> reviewOrder(
      String paymentMethod, String comment, String agree);
  Future<CheckoutConfirmOrderModel?> placeOrder(String state, String paymentId);
}

class OrderReviewScreenRepositoryImp implements OrderReviewScreenRepository {
  @override
  Future<CheckoutPaymentMethodModel?> getPaymentMethods(String comment) async {
    return ApiClient().getCheckoutPaymentMethod(
        AppConstant.paymentMethod,
        await AppSharedPref.getSelectedShippingId(),
        comment,
        await AppSharedPref.getWkToken());
  }

  @override
  Future<CheckoutConfirmOrderModel?> placeOrder(
      String state, String paymentId) async {
    return ApiClient()
        .confirmOrder(await AppSharedPref.getWkToken(), state, paymentId);
  }

  @override
  Future<CheckoutReviewOrderModel?> reviewOrder(
      String paymentMethod, String comment, String agree) async {
    return ApiClient().reviewOrder(
        AppSizes.deviceWidth.toString(),
        AppConstant.confirm,
        paymentMethod,
        agree,
        comment,
        await AppSharedPref.getWkToken());
  }

  @override
  Future<CheckoutPaymentMethodModel?>
      getPaymentMethodWhenShippingNotRequired() async {
    return ApiClient().getPaymentMethodsWhileShippingIsNotRequired(
        AppConstant.shippingAddress,
        await AppSharedPref.getBillingAddressId(),
        AppConstant.existing,
        await AppSharedPref.getWkToken());
  }
}
