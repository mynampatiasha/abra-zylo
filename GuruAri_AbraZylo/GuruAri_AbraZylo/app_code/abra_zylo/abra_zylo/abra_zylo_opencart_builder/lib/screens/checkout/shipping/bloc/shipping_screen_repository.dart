import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/checkout/checkout_payment_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_method_model.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helper/app_shared_pref.dart';
import '../../../../models/address/add_address_request.dart';
import '../../../../network_manager/api_client.dart';

abstract class ShippingScreenRepository {
  Future<CheckoutShippingAddressModel?> getShippingAddress();

  Future<CheckoutShippingMethodModel?> getShippingMethods();

  Future<CheckoutPaymentAddressModel?> getPaymentOrBillingAddress();

  Future<CheckoutShippingMethodModel?> guestShippingMethod(
      AddAddressRequest request, String function);
}

class ShippingScreenRepositoryImp implements ShippingScreenRepository {
  /*
  * Method to call api for getting payment/Billing address
  * */
  @override
  Future<CheckoutPaymentAddressModel?> getPaymentOrBillingAddress() async {
    return ApiClient().getCheckoutPaymentAddress(
        await AppSharedPref.getWkToken(), AppConstant.paymentAddress);
  }

/*
* Method to call api for getting shipping address from server
* */
  @override
  Future<CheckoutShippingAddressModel?> getShippingAddress() async {
    return ApiClient().getCheckoutShippingAddress(
        AppConstant.shippingAddress,
        await AppSharedPref.getBillingAddressId(),
        AppConstant.existing,
        await AppSharedPref.getWkToken());
  }

  /*
  * Method to call api for getting shipping methods from server.
  * */
  @override
  Future<CheckoutShippingMethodModel?> getShippingMethods() async {
    return ApiClient().getCheckoutShippingMethods(
        AppConstant.shippingMethod,
        await AppSharedPref.getShippingAddressId(),
        AppConstant.existing,
        await AppSharedPref.getWkToken()
        /*await AppSharedPref.getWkToken()*/
        );
  }

  @override
  Future<CheckoutShippingMethodModel?> guestShippingMethod(
      AddAddressRequest request, String function) async {
    return ApiClient().guestShippingMethod(
        "1",
        function,
        request.email ?? "",
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
