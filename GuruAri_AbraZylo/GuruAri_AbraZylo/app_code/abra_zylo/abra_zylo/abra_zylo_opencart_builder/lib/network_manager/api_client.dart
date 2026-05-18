import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart' show kIsWeb;
// dart:io is needed for File and Platform used in image upload methods
// and in the generated api_client.g.dart (part of this file).
// On web these upload methods are not called, but the import must exist.
// ignore: avoid_web_libraries_in_flutter
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/accountInfoModel/account_info_model.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import 'package:oc_demo/models/cart/cart_shipping_model.dart';
import 'package:oc_demo/models/cart/country_data_model.dart';
import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/checkout/checkout_confirm_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_guest_model.dart';
import 'package:oc_demo/models/checkout/checkout_payment_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_method_model.dart';
import 'package:oc_demo/models/cmsDetailModel/cms_detail_model.dart';
import 'package:oc_demo/models/downloadProductModel/download_product_model.dart';
import 'package:oc_demo/models/locationModel/location_model.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';
import 'package:oc_demo/models/notification/notification_screen_model.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/models/orderDetailModel/return_order_request.dart';
import 'package:oc_demo/models/productDetail/add_product_wishlist_model.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';
import 'package:oc_demo/models/returnOrderDetailModel/return_order_detail_model.dart';
import 'package:oc_demo/models/reviewListModel/reviews_list_model.dart';
import 'package:oc_demo/models/rewardModel/reward_model.dart';
import 'package:oc_demo/models/searchModel/search_model.dart';
import 'package:oc_demo/models/splash/splash_screen_model.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';
import 'package:oc_demo/models/wishlist/get_wish_list.dart';
import 'package:retrofit/http.dart';

import '../../constants/app_constants.dart';
import '../../models/ApiLoginResponse/api_login_response.dart';
import '../../network_manager/apis.dart';
import '../../network_manager/dio_exceptions.dart';
import '../models/accountItemsListModel/account_items_list_model.dart';
import '../models/address/edit_address_book.dart';
import '../models/address/get_address.dart';
import '../models/carousel/carousel_model.dart';
import '../models/compare_products/compare_product_model.dart';
import '../models/google_place_model.dart';
import '../models/guestOrderReturn/GuestOrderReturn.dart';
import '../models/homPage/home_screen_model.dart';
import '../models/orderListModel/order_list_model.dart';
import '../models/returnOrderListModel/return_order_list_model.dart';

import '../models/saveImageModel/save_image_model.dart';
import '../models/transactionModel/transaction_model.dart';
import '../models/walk_through/walk_through_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://abra-zylo.com/")
abstract class ApiClient {
  factory ApiClient({String? baseUrl, showError = true}) {
    Dio dio = Dio();
    final cookieJar = DefaultCookieJar();
    if (!kIsWeb) {
      // CookieManager only works on mobile — browsers block manual cookie headers
      dio.interceptors.add(CookieManager(cookieJar));
    }
    dio.options = BaseOptions(
        receiveTimeout: Duration(milliseconds: 50000),
        connectTimeout: Duration(milliseconds: 50000),
        responseType: ResponseType.json,
        baseUrl: baseUrl ?? ApiConstant.baseUrl);
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    AppSharedPref.getWkToken().then((value) {
      dio.options.headers["wk_token"] = value;
    });

    RequestOptions? reqOptions, loginOptions;
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        logPrint: (object) {
          log(object.toString());
          //print(object.toString());
        }));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (options.path != Apis.apiLogin) {
        reqOptions = options;
        loginOptions = null;
      } else {
        loginOptions = options;
      }

      return handler.next(options);
    }, onResponse: (response, handler) async {
      String currentToken = await AppSharedPref.getWkToken();
      // On web, response.data may come back as a String — parse it if needed
      Map<String, dynamic> map;
      try {
        if (response.data is Map<String, dynamic>) {
          map = response.data as Map<String, dynamic>;
        } else if (response.data is String) {
          final str = response.data as String;
          // Server returned HTML (PHP error page) — reject it cleanly
          if (str.trimLeft().startsWith('<')) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: 'Server error — check backend logs',
                type: DioExceptionType.badResponse,
                response: response,
              ),
            );
          }
          map = jsonDecode(str) as Map<String, dynamic>;
        } else {
          handler.next(response);
          return;
        }
      } catch (e) {
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: 'Invalid response format: $e',
            type: DioExceptionType.badResponse,
            response: response,
          ),
        );
      }

      var baseModel = BaseModel.fromJson(map);
      if (baseModel.fault != 1 && currentToken.isEmpty) {
        handler.next(response);
      } else if (baseModel.fault != 1 &&
          currentToken.isNotEmpty &&
          loginOptions == null) {
        handler.next(response);
      } else if (baseModel.fault == 1) {
        handleFaultCode(
            dio, reqOptions, baseUrl ?? dio.options.baseUrl, handler);
      } else {
        handler.next(response);
      }
    }, onError: (DioError e, handler) {
      if (e.response?.statusCode != 304 && showError) {
        // On web, e.error may be a JS Event object — convert safely
        final errMsg = DioExceptions.fromDioError(e).message ?? 'Something went wrong';
        DioCustomError err = DioCustomError(errMsg, e);
        return handler.next(err);
      }
    }));
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  @POST(Apis.homePageApi)
  Future<HomePageData> getHomePage(
      @Field("mfactor") String lang,
      @Field("count") String currency,
      @Field("width") int deviceWidth,
      @Field("wk_token") String wsKey,
      @Field("etag") String header);

//apiKey=admin&apiPassword=21232f297a57a5a743894a0e4a801fc3&customer_id=1&language=&currency=USD
  @POST(Apis.apiLogin)
  Future<ApiLoginResponseModel> apiLogin(
    @Field("apiKey") String apiKey,
    @Field("apiPassword") String apiPassword,
    @Field("customer_id") String customer_id,
    @Field("language") String language,
    @Field("currency") String currency,
  );

  @POST(Apis.getSubCategory)
  Future<SubCategoryModel> getSubCategoryData(
      @Field("width") String width,
      @Field("wk_token") String wkToken,
      @Field("category_id") String categoryId,
      @Field("etag") String eTag);

  ///Goswami
  @POST(Apis.productCategory)
  Future<CatalogModel> getCatalogProducts(
      @Field("page") String page,
      @Field("limit") String limit,
      @Field("width") String width,
      @Field("path") String path,
      @Field("sort") String? sort,
      @Field("order") String? order,
      @Field("filter") String? filter,
      @Field("wk_token") String wkToken,
      @Field("etag") String eTag);

  ///Goswami
  @POST(Apis.SEARCH_RESULT_API)
  Future<CatalogModel> searchResults(
    @Field("search") String? search,
    @Field("wk_token") String token,
    @Field("width") String width,
    @Field("category_id") String categoryId,
  );

  @POST(Apis.customCollection)
  Future<CatalogModel> getCustomCollection(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("id") String path,
    @Field("sort") String? sort,
    @Field("order") String? order,
    @Field("filter") String? filter,
    @Field("wk_token") String wkToken,
  );

  @POST(Apis.productDetailApi)
  Future<ProductDetailScreenModel> getProductDetail(
      @Field("width") String width,
      @Field("product_id") String product_id,
      @Field("profile_page") String profile_page,
      @Field("wk_token") String wk_token,
      @Field("etag") String header);

  @POST(Apis.writeProductReviewApi)
  Future<BaseModel> writeReview(
      @Field("name") String name,
      @Field("text") String text,
      @Field("rating") String rating,
      @Field("product_id") String product_id,
      @Field("wk_token") Stringwk_token);

  @POST(Apis.getProductReviewApi)
  Future<ReviewData> getProductReviewList(
      @Field("wk_token") String wkToken,
      @Field("product_id") String productId,
      @Field("page") String page,
      @Field("limit") String limit);

  @POST(Apis.addProductToCart)
  Future<BaseModel> addToCart(
      @Field("product_id") String product_id,
      @Field("quantity") String quantity,
      @Field("option") String /*Map<String, dynamic>*/ option,
      @Field("width") String width,
      @Field("wk_token") String wk_token);

  @POST(Apis.addProductToWishlist)
  Future<AddProductToWishListModel> addProductToWishlist(
      @Field("product_id") String product_id,
      @Field("wk_token") String wk_token);

  @POST(Apis.registerAccount)
  Future<RegisterAccountModel> registerAccount(
      @Field("wk_token") String wk_token);

  @POST(Apis.checkEmail)
  Future<RegisterAccountModel> checkEmail(
      @Field("wk_token") String wk_token, @Field("email") String email);

  @POST(Apis.addCustomer)
  Future<LoginModel> addCustomer(
    @Field("wk_token") String wk_token,
    @Field("customer_group_id") String customer_group_id,
    @Field("firstname") String firstname,
    @Field("lastname") String lastname,
    @Field("email") String email,
    @Field("telephone") String telephone,
    @Field("password") String password,
    @Field("newsletter") String isSubscribe,
    @Field("agree") String agree,
    @Field("tobecomepartner") String tobecomepartner,
    @Field("shoppartner") String shoppartner,
    @Field("android_device_id") String android_device_id,
  );

  @POST(Apis.loginCustomer)
  Future<LoginModel> loginCustomer(
    @Field("wk_token") String wk_token,
    @Field("username") String username,
    @Field("password") String password,
    @Field("android_device_id") String? androidDeviceId,
    @Field("ios_device_id") String? iosDeviceId,
  );

  @POST(Apis.forgotPassword)
  Future<BaseModel> forgotPassword(
      @Field("wk_token") String wk_token, @Field("email") String email);

  @POST(Apis.logoutUser)
  Future<BaseModel> logoutUser(
    @Field("wk_token") String wk_token,
  );

  @POST(Apis.deleteUser)
  Future<BaseModel> deleteUser(
    @Field("wk_token") String wk_token,
  );

  @POST(Apis.userDetails)
  Future<AccountInfoModel> userDetail(
    @Field("wk_token") String wk_token,
  );

  @POST(Apis.editCustomer)
  Future<BaseModel> editCustomer(
    @Field("wk_token") String wk_token,
    @Field("firstname") String firstName,
    @Field("lastname") String lastname,
    @Field("email") String email,
    @Field("telephone") String telephone,
    @Field("fax") String fax,
  );

  @POST(Apis.editPassword)
  Future<BaseModel> editPassword(
    @Field("wk_token") String wk_token,
    @Field("password") String password,
  );

  @POST(Apis.viewCart)
  Future<CartModel> viewCart(
      @Field("width") String width, @Field("wk_token") String wk_token);

  @POST(Apis.removeFromCart)
  Future<BaseModel> removeFromCart(
      @Field("key") String key, @Field("wk_token") String wk_token);

  @POST(Apis.emptyCart)
  Future<BaseModel> emptyCart(@Field("wk_token") String wk_token);

  @POST(Apis.updateCart)
  Future<BaseModel> updateCart(
      @Field("quantity") String quantity, @Field("wk_token") String wk_token);

  @POST(Apis.applyCoupon)
  Future<BaseModel> applyCoupon(
      @Field("coupon") String coupon, @Field("wk_token") String wk_token);

  @POST(Apis.applyVoucher)
  Future<BaseModel> applayVoucher(
      @Field("voucher") String voucher, @Field("wk_token") String wk_token);

  @POST(Apis.applyRewards)
  Future<BaseModel> applyRewards(
      @Field("reward") String coupon, @Field("wk_token") String wk_token);

  @POST(Apis.getCountryData)
  Future<CountryDataModel> getCountryData(@Field("wk_token") String wk_token);

  @POST(Apis.getShipping)
  Future<CartShippingModel> getShipping(
      @Field("wk_token") String wk_token,
      @Field("zone_id") String zone_id,
      @Field("country_id") String country_id,
      @Field("postcode") String postcode);

  @POST(Apis.applyShipping)
  Future<BaseModel> applyShipping(
    @Field("wk_token") String wk_token,
    @Field("shipping_method") String shipping_method,
  );

/*
* Checkout Process Api's Start
* -----------------------------------------------
* */

/*
* for getting payment/Billing Address
* */

  @POST(Apis.checkout)
  Future<CheckoutPaymentAddressModel> getCheckoutPaymentAddress(
    @Field("wk_token") String wk_token,
    @Field("function") String function,
  );

  /*
  * For getting shipping address
  * */

  @POST(Apis.checkout)
  Future<CheckoutShippingAddressModel> getCheckoutShippingAddress(
    @Field("function") String function,
    @Field("address_id") String address_id,
    @Field("payment_address") String payment_address,
    @Field("wk_token") String wk_token,
  );

  /*
  * For getting shipping methods
  * */
  @POST(Apis.checkout)
  Future<CheckoutShippingMethodModel> getCheckoutShippingMethods(
    @Field("function") String function,
    @Field("address_id") String address_id,
    @Field("shipping_address") String shipping_address,
    @Field("wk_token") String wk_token,
  );

/*
* For getting payment methods directly by skipping shipping address and shipping method step if shipping required is false.
* */
  @POST(Apis.checkout)
  Future<CheckoutPaymentMethodModel>
      getPaymentMethodsWhileShippingIsNotRequired(
    @Field("function") String function,
    @Field("address_id") String address_id,
    @Field("payment_address") String payment_address,
    @Field("wk_token") String wk_token,
  );

/*
* to get payment methods
* */
  @POST(Apis.checkout)
  Future<CheckoutPaymentMethodModel> getCheckoutPaymentMethod(
    @Field("function") String function,
    @Field("shipping_method") String shipping_method,
    @Field("comment") String comment,
    @Field("wk_token") String wk_token,
  );

/*
* To Review Order - will return order summary before placing order
* */
  @POST(Apis.checkout)
  Future<CheckoutReviewOrderModel> reviewOrder(
    @Field("width") String width,
    @Field("function") String function,
    @Field("payment_method") String payment_method,
    @Field("agree") String agree,
    @Field("comment") String comment,
    @Field("wk_token") String wk_token,
  );

/*
* Confirm the Order
* */
  @POST(Apis.confirmOrder)
  Future<CheckoutConfirmOrderModel> confirmOrder(
    @Field("wk_token") String wk_token,
    @Field("state") String state,
    @Field("razorpay_payment_id") String paymentId,
  );

  /*
  * Guest checkout
  * */
  @POST(Apis.checkout)
  Future<CheckoutGuestModel> guestCheckout(
    @Field("function") String state,
    @Field("wk_token") String wk_token,
  );

  @POST(Apis.guestOrderReturn)
  Future<BaseModel> guestOrdersAndReturnsData(
    @Field("wk_token") String wkToken,
    @Field("order_id") String orderId,
    @Field("product_id") String orderProductId,
    @Field("firstname") String firstName,
    @Field("lastname") String lastName,
    @Field("email") String email,
    @Field("telephone") String telephone,
    @Field("date_ordered") String dateOrdered,
    @Field("product") String product,
    @Field("model") String model,
    @Field("quantity") String quantity,
    @Field("return_reason_id") String returnReasonId,
    @Field("opened") String opened,
    @Field("comment") String comment,
  );

  @POST(Apis.getGuestOrder)
  Future<GuestOrderReturn> getGuestOrders(
    @Field("wk_token") String wk_token,
    @Field("order_id") String orderId,
    @Field("lastName") String lastName,
    @Field("email") String email,
    @Field("zip") String zip,
  );

  @POST(Apis.getReviewsList)
  Future<ReviewsListModel> getReviewsList(@Field("wk_token") String wk_token,
      @Field("page") int pageNo, @Field("limit") int limit);

  /*
  * Guest Shipping Address
  * */
  @POST(Apis.checkout)
  Future<CheckoutShippingAddressModel> guestShippingAddress(
    @Field("shipping_address") String state,
    @Field("function") String function,
    @Field("email") String email,
    @Field("telephone") String telephone,
    @Field("fax") String fax,
    @Field("firstname") String firstname,
    @Field("lastname") String lastname,
    @Field("company") String company,
    @Field("address_1") String address_1,
    @Field("address_2") String address_2,
    @Field("city") String city,
    @Field("postcode") String postcode,
    @Field("country_id") String country_id,
    @Field("zone_id") String zone_id,
    @Field("wk_token") String wk_token,
  );

  /*
  * Guest Shipping Address
  * */
  @POST(Apis.checkout)
  Future<CheckoutShippingMethodModel> guestShippingMethod(
    @Field("shipping_address") String state,
    @Field("function") String function,
    @Field("email") String email,
    @Field("telephone") String telephone,
    @Field("fax") String fax,
    @Field("firstname") String firstname,
    @Field("lastname") String lastname,
    @Field("company") String company,
    @Field("address_1") String address_1,
    @Field("address_2") String address_2,
    @Field("city") String city,
    @Field("postcode") String postcode,
    @Field("country_id") String country_id,
    @Field("zone_id") String zone_id,
    @Field("wk_token") String wk_token,
  );

/*
* Checkout Process Api's End
*  ------------------------------
* */

  @POST(Apis.getOrderDetails)
  Future<OrderDetailModel> getOrderDetails(
    @Field("wk_token") String wk_token,
    @Field("order_id") String order_id,
  );

  @POST(Apis.getReturnOrders)
  Future<ReturnOrderListModel> getReturnOrderList(
      @Field("wk_token") String wk_token, @Field("etag") String eTag);

  @POST(Apis.getCmsPageDetail)
  Future<CmsDetailModel> getCmsPageDetail(
    @Field("wk_token") String wk_token,
    @Field("information_id") String information_id,
  );

  @POST(Apis.updateCurrency)
  Future<BaseModel> updateCurrency(
    @Field("wk_token") String wk_token,
    @Field("code") String code,
  );

  @POST(Apis.updateLanguage)
  Future<BaseModel> updateLanguage(
    @Field("wk_token") String wk_token,
    @Field("code") String code,
  );

  @POST(Apis.getTransactionDetails)
  Future<TransactionModel> getTransactionDetails(
    @Field("wk_token") String wk_token,
    @Field("page") String page,
  );

  @POST(Apis.getRewardPointsDetails)
  Future<RewardModel> getRewardPointsDetails(
    @Field("wk_token") String wk_token,
    @Field("page") String page,
  );

  @POST(Apis.getDownloadableProducts)
  Future<DownloadProductModel> getDownloadableProducts(
    @Field("wk_token") String wk_token,
    @Field("limit") String limit,
    @Field("page") String page,
  );

  @POST(Apis.GET_WISHLIST)
  Future<GetWishlist> getWishlist(@Field("width") String width,
      @Field("wk_token") String wk_token, @Field("etag") String eTag);

  @POST(Apis.REMOVE_FROM_WISHLIST)
  Future<BaseModel> removeFromWishlist(@Field("product_id") String product_id,
      @Field("wk_token") String wk_token);

  @POST(Apis.getAllOrderList)
  Future<OrderListModel> getAllOrderList(@Field("wk_token") String wk_token,
      @Field("page") String page, @Field("etag") String eTag);

  @POST(Apis.subscribeNewsletter)
  Future<BaseModel> subscribeNewsletter(
    @Field("wk_token") String wk_token,
    @Field("newsletter") String newsletter,
  );

  @POST(Apis.getNewsletter)
  Future<BaseModel> getNewsLetter(
    @Field("wk_token") String wk_token,
  );

  @POST(Apis.getAddress)
  Future<GetAddress> getAddressList(
      @Field("wk_token") String token, @Field("etag") String eTag);

  @POST(Apis.deleteAddress)
  Future<BaseModel> deleteAddress(
    @Field("address_id") String addressId,
    @Field("wk_token") String token,
  );

  @POST(Apis.addAddressBook)
  Future<EditAddressBook> addAddressBook(
    @Field("address_id") String? addressId,
    @Field("wk_token") String token,
  );

  @POST(Apis.dashboardOrderInfo)
  Future<OrderDetailModel> dashboarOrderInfo(
    @Field("order_id") String? orderId,
    @Field("wk_token") String token,
  );

  @FormUrlEncoded()
  @POST(Apis.reOrderProduct)
  Future<BaseModel> reOrderProduct(
    @Field("wk_token") String token,
    @Field("order_id") String? orderId,
    @Field("order_product_id") String orderProductId,
  );

  @FormUrlEncoded()
  @POST(Apis.addReturnData)
  Future<ReturnOrderRequest> addReturnData(
    @Field("wk_token") String token,
    @Field("order_id") String? orderId,
    @Field("product_id") String orderProductId,
  );

  @FormUrlEncoded()
  @POST(Apis.addReturn)
  Future<BaseModel> addReturn(
    @Field("wk_token") String token,
    @Field("order_id") String? order_id,
    @Field("product_id") String orderProductId,
    @Field("firstname") String? firstname,
    @Field("lastname") String? lastname,
    @Field("email") String? email,
    @Field("telephone") String? telephone,
    @Field("date_ordered") String? date_ordered,
    @Field("product") String? product,
    @Field("model") String? model,
    @Field("quantity") String? quantity,
    @Field("return_reason_id") String? return_reason_id,
    @Field("opened") String? opened,
    @Field("comment") String? comment,
  );

  @FormUrlEncoded()
  @POST(Apis.getDBoyLocation)
  Future<LocationModel> getDboyLocation(
    @Field("wk_token") String token,
    @Field("id") String? id,
  );

  @FormUrlEncoded()
  @POST(Apis.loginWithQr)
  Future<BaseModel> loginWithQr(
    @Field("key") String? key,
    @Field("wk_token") String token,
  );

  @POST(Apis.addAddress)
  Future<BaseModel> addAddress(
    @Field("customer_id") String customerId,
    @Field("address_id") String? addressId,
    @Field("firstname") String firstname,
    @Field("lastname") String lastname,
    @Field("company") String company,
    @Field("address_1") String address1,
    @Field("address_2") String address22,
    @Field("city") String city,
    @Field("zone_id") String zoneId,
    @Field("postcode") String postcode,
    @Field("country_id") String countryId,
    @Field("default") String defaultValue,
    @Field("wk_token") String token,
  );

  @GET(Apis.googlePlace + "{endPoint}")
  Future<GooglePlaceModel> getGooglePlace(@Path() String endPoint);

  @POST(Apis.viewNotifications)
  Future<NotificationScreenModel> getNotifications(@Field("width") String width,
      @Field("wk_token") String wk_token, @Field("etag") String eTag);

  @FormUrlEncoded()
  @POST(Apis.SEARCH_API)
  Future<SearchModel> searchSuggestions(
    @Field("search") String? search,
    @Field("wk_token") String token,
  );

  @POST(Apis.getPopularProducts)
  Future<CatalogModel> popularProducts(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("path") String? path,
    @Field("sort") String? sort,
    @Field("order") String? order,
    @Field("filter") String? filter,
    @Field("wk_token") String wkToken,
    @Field("etag") String eTag,
  );

  @POST(Apis.getBestProducts)
  Future<CatalogModel> bestProducts(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("path") String? path,
    @Field("sort") String? sort,
    @Field("order") String? order,
    @Field("filter") String? filter,
    @Field("wk_token") String wkToken,
    @Field("etag") String eTag,
  );

  @POST(Apis.featured)
  Future<CatalogModel> featured(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("path") String? path,
    @Field("sort") String? sort,
    @Field("order") String? order,
    @Field("filter") String? filter,
    @Field("wk_token") String wkToken,
    @Field("etag") String eTag,
  );

  @POST(Apis.latestProduct)
  Future<CatalogModel> latestProduct(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("path") String? path,
    @Field("sort") String? sort,
    @Field("order") String? order,
    @Field("filter") String? filter,
    @Field("wk_token") String wkToken,
    @Field("etag") String eTag,
  );

  @POST(Apis.manufacture)
  Future<ManufactureModel> manufactureInfo(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("manufacturer_id") String manufacturer_id,
    @Field("sort") String sort,
    @Field("order") String order,
    @Field("wk_token") String wk_token,
    @Field("etag") String eTag,
  );

  @FormUrlEncoded()
  @POST(Apis.registerCustomerDeviceToken)
  Future<BaseModel> registerCustomerDeviceToken(
    @Field("wk_token") String wkToken,
    @Field("android_device_id") String? androidDeviceId,
    @Field("ios_device_id") String? iosDeviceId,
  );

  @FormUrlEncoded()
  @POST(Apis.returnInformation)
  Future<ReturnOrderDetailModel> getReturnDetails(
      @Field("wk_token") String wkToken, @Field("return_id") String? return_id);

  @POST(Apis.toBecomeSeller)
  Future<BaseModel> toBecomeSeller(
    @Field("wk_token") String wk_token,
    @Field("shoppartner") String shoppartner,
    @Field("description") String description,
  );

  /*Walk thorough*/

  @POST(Apis.walkThrough)
  Future<WalkThroughModel> getWalkThrough(
    @Field("height") String height,
    @Field("width") String width,
  );

  @POST(Apis.carouselProduct)
  Future<CatalogModel> getCarouselProducts(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("carousel_id") String path,
    @Field("sort") String? sort,
    @Field("order") String? order,
    @Field("wk_token") String wkToken,
  );

  @POST(Apis.carouselProduct)
  Future<CarouselModel> getCarouselManufacture(
    @Field("page") String page,
    @Field("limit") String limit,
    @Field("width") String width,
    @Field("carousel_id") String path,
    @Field("sort") String? sort,
    @Field("order") String? order,
    @Field("wk_token") String wkToken,
  );

  @POST(Apis.compareProducts)
  Future<CompareProduct> getCompareProducts(
    @Field("wk_token") String wkToken,
  );

  //Add to compare product
  @FormUrlEncoded()
  @POST(Apis.addCompareProduct)
  Future<BaseModel> addCompareProduct(
    @Field("product_id") String? productId,
    @Field("wk_token") String wkToken,
  );

//remove to compare product
  @FormUrlEncoded()
  @POST(Apis.removeCompareProduct)
  Future<BaseModel> removeCompareProduct(
    @Query("remove") String? productId,
    @Field("wk_token") String wkToken,
  );

  @FormUrlEncoded()
  @POST(Apis.splashScreen)
  Future<SplashScreenModel> getSplashScreen(@Field("height") String height,
      @Field("width") String width, @Field("wk_token") String wk_token);

  @FormUrlEncoded()
  @POST(Apis.getAccountItemListApi)
  Future<AccountItemsListModel> getAccountItemsList(
      @Field("customer_id") String customerId,
      @Field("wk_token") String wkToken);

  @POST(Apis.shareWishlistCollection)
  Future<BaseModel> sendWishlistCollection(
      @Field("email") String email, @Field("wk_token") String wkToken);

  @POST(Apis.uploadImage)
  @MultiPart()
  Future<SaveImageModel> uploadProfileImage(
    @Part(name: 'customer_id') String customerId,
    @Part(name: 'wk_token') String wkToken,
    @Part(name: 'image', contentType: 'image/jpeg') File image,
  );

  @POST(Apis.uploadImage)
  @MultiPart()
  Future<SaveImageModel> uploadBannerImage(
    @Part(name: 'customer_id') String customerId,
    @Part(name: 'wk_token') String wkToken,
    @Part(name: 'banner', contentType: 'image/jpeg') File banner,
  );

  /// Google Sign-In — sends Google ID token + user info to backend
  @POST(Apis.googleLogin)
  Future<LoginModel> googleLogin(
    @Field("wk_token") String wkToken,
    @Field("google_id") String googleId,
    @Field("email") String email,
    @Field("firstname") String firstname,
    @Field("lastname") String lastname,
    @Field("android_device_id") String? androidDeviceId,
    @Field("ios_device_id") String? iosDeviceId,
  );
}
