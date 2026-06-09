//============================Map Keys==============================//

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';

// import '../marketplace/marketplace_model/seller_order_details.dart';
// import '../marketplace/marketplace_model/add_product/option_tab_model/option_tab_model.dart';
import '../models/orderDetailModel/order_detail_model.dart';
import '../models/productDetail/product_detail_screen_model.dart';

const addressKey = 'address';
const shippingMethodKey = 'shippingMethod';
const shippingIdKey = "shippingId";
const shippingAddressIdKey = "shippingAddressId";
const customerIdKey = "customerId";
const urlKey = 'url';
const fromHomePageKey = "fromHomePage";
const productIdKey = "productId";
const productNameKey = "productName";
const subCategoryListKey = "subCategoryList";
const addressEndpointKey = "addressEndpoint";
const productData = "productData";
const reviewData = "reviewData";
const categoryNameKey = "categoryName";
const fromNotificationKey = "fromNotification";
const domainKey = "domain";
const productBloc = "productBloc";
const categoryId = "catalogId";
const productCategoryTypeKey = "productCategoryType";
const labelKey = "label";
const comment = "comment";
const isShippingRequired = "isShippingRequired";
const cmsPageId = "cmsPageId";
const cmsPageTitle = "cmsPageTitle";
const isFromCartForLogin = "isFromCartForLogin";
const isFromCartForSignup = "isFromCartForSignup";
const guestShippingData = "guestShippingData";
const guestShippingFunction = "guestShippingFunction";
const isForGuestShippingAddress = "isForGuestShippingAddress";
const isGuestCheckout = "isGuestCheckout";
const isGuestAddress = "isGuestAddress";
const orderId = "orderId";
const boyId = "boyId";
const address = "address";
const sellerOrderModel = "sellerOrderModel";
const sellerOrderID = "sellerOrderID";

const sellerId = "sellerId";
const optionValues = "optionValues";
const productOptions = "productOptions";
const payment_method = "payment_method";
const shippingAddressKey = "shippingAddress";
const sourceLocation = "sourceLocation";
const destinationLocation = "destinationLocation";
const wareHouseAddress = "wareHouseAddress";
const wareHouseAddressLat = "wareHouseAddressLat";
const wareHouseAddressLong = "wareHouseAddressLong";
const deliveryBoyIdKey = "deliveryBoyId";

//===============================================================//

Map<String, dynamic> getCheckoutMap(
    int shippingId, int shippingAddressId, String addressEndpoint) {
  Map<String, dynamic> args = {};
  args[addressEndpointKey] = addressEndpoint;
  args[shippingAddressIdKey] = shippingAddressId;
  args[shippingIdKey] = shippingId;
  return args;
}

Map<String, dynamic> getCatalogMap(
    String url, bool fromHomepage, String categoryName,
    {bool fromNotification = false, String domain = "", int customerId = 0}) {
  Map<String, dynamic> args = {};
  args[customerIdKey] = customerId;
  args[urlKey] = url;
  args[fromHomePageKey] = fromHomepage;
  args[categoryNameKey] = categoryName;
  args[fromNotificationKey] = fromNotification;
  args[domainKey] = domain;
  return args;
}

/*
* Method  will return the attribute which will be passed to product detail page at any product click event
*
* */
Map<String, dynamic> getProductDataAttributeMap(
    String productName, String productId) {
  Map<String, dynamic> args = {};
  args[productNameKey] = productName;
  args[productIdKey] = productId;
  return args;
}

/*
* Method will return attribute map ned to pass to review screen
* */
Map<String, dynamic> reviewAttributeDataMap(
    ProductDetailScreenModel data, ProductDetailBloc bloc) {
  Map<String, dynamic> args = {};
  args[productData] = data;
  args[productBloc] = bloc;
  return args;
}

Map<String, dynamic> categoryMap(String id, String label, String? type,
    [bool fromHomePage = false]) {
  var args = <String, dynamic>{};
  args[labelKey] = label;
  args[categoryId] = id;
  args[productCategoryTypeKey] = type ?? "";
  args[fromHomePageKey] = fromHomePage;
  return args;
}

Map<String, dynamic> trackDboyMap(String id, String? address) {
  var args = <String, dynamic>{};
  args[boyId] = id;
  args[addressKey] = address ?? "";
  return args;
}

Map<String, dynamic> orderReviewScreenMap(
    String shippingComment,
    bool shippingRequired,
    bool guestCheckout,
    List<PaymentMethod>? paymentMethodList) {
  var args = <String, dynamic>{};
  args[comment] = shippingComment;
  args[isShippingRequired] = shippingRequired;
  args[isGuestCheckout] = guestCheckout;
  args[payment_method] = paymentMethodList;
  return args;
}

Map<String, dynamic> getCmsPageArguments(String pageId, String pageTitle) {
  Map<String, dynamic> args = {};
  args[cmsPageId] = pageId;
  args[cmsPageTitle] = pageTitle;
  return args;
}

/*
* Sing_in/sign up
* */

Map<String, dynamic> getSignInSignUpPageArgument(
    bool isLoginCall, bool isRegisterCall) {
  Map<String, dynamic> args = {};
  args[isFromCartForLogin] = isLoginCall;
  args[isFromCartForSignup] = isRegisterCall;
  return args;
}
/*
* Shipping page
* */

Map<String, dynamic> getShippingPageArgument(
    AddAddressRequest addAddressRequest, String function, bool guestCheckout,
    {String? address}) {
  Map<String, dynamic> args = {};
  args[guestShippingData] = addAddressRequest;
  args[guestShippingFunction] = function;
  args[isGuestCheckout] = guestCheckout;
  if (address != null && address != "") {
    args[isGuestAddress] = address;
  }
  return args;
}

Map<String, dynamic> getGuestCheckoutArguments(bool forShippingAddressPage) {
  Map<String, dynamic> args = {};
  args[isForGuestShippingAddress] = forShippingAddressPage;

  return args;
}

/*
* Product Return page
* */

Map<String, dynamic> getProductReturnMap(String productId, String id) {
  Map<String, dynamic> args = {};
  args[productIdKey] = productId;
  args[orderId] = id;

  return args;
}

Map<String, dynamic> getSellerProfileArgument(String id) {
  Map<String, dynamic> args = {};
  args[sellerId] = id;
  return args;
}

Map<String, dynamic> getOrderTrackingDataMap(
    String deliveryBoyId,
    String shippingAddress,
    LatLng sourceLatLng,
    LatLng destinationLatLng,
    WarehouseDetails? warehouseDetails) {
  Map<String, dynamic> args = {};
  args[deliveryBoyIdKey] = deliveryBoyId;
  args[shippingAddressKey] = shippingAddress;
  args[sourceLocation] = sourceLatLng;
  args[destinationLocation] = destinationLatLng;
  args[wareHouseAddress] = warehouseDetails?.address ?? "";
  args[wareHouseAddressLat] = warehouseDetails?.lat ?? "";
  args[wareHouseAddressLong] = warehouseDetails?.lon ?? "";
  return args;
}
