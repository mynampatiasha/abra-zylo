import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/checkout/checkout_confirm_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_guest_model.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/screens/add_edit_address/add_edit_address.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helper/app_shared_pref.dart';
import '../../../../network_manager/api_client.dart';

abstract class GuestCheckoutScreenRepository {
  Future<CheckoutShippingAddressModel?> guestShippingMethod(
      String shippingAddress, AddAddressRequest request);
  Future<CheckoutGuestModel?> guestCheckout();
  /*Future<CheckoutReviewOrderModel?> reviewOrder(String paymentMethod,String comment,String agree);
  Future<CheckoutConfirmOrderModel?> placeOrder(String state);*/
}

class GuestCheckoutScreenRepositoryImp
    implements GuestCheckoutScreenRepository {
/*  @override
  Future<CheckoutPaymentMethodModel?> getPaymentMethods(String comment) async {
    return ApiClient().getCheckoutPaymentMethod(
        AppConstant.paymentMethod,
        await AppSharedPref.getSelectedShippingId(),
        comment,await AppSharedPref.getWkToken()
    );
  }

  @override
  Future<CheckoutConfirmOrderModel?> placeOrder(String state) async {
    return ApiClient().confirmOrder(await AppSharedPref.getWkToken(),state);
  }*/

  @override
  Future<CheckoutGuestModel?> guestCheckout() async {
    return ApiClient()
        .guestCheckout(AppConstant.guest, await AppSharedPref.getWkToken());
  }

  @override
  Future<CheckoutShippingAddressModel?> guestShippingMethod(
      String shippingAddress, AddAddressRequest request) async {
    return ApiClient().guestShippingAddress(
        shippingAddress,
        AppConstant.saveGuest,
        request.email?.trim() ?? "",
        request.telephone ?? "",
        "",
        request.firstName ?? "",
        request.lastName ?? "",
        request.company ?? "",
        request.address1 ?? "",
        request.address2 ?? "",
        request.city ?? "",
        request.postcode ?? "",
        request.countryId ?? "",
        request.zoneId ?? "",
        await AppSharedPref.getWkToken());
  }
}
