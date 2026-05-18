import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/models/accountItemsListModel/account_items_list_model.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_data.dart';
import '../models/loginModel/login_model.dart';

class AppSharedPref {
  static const String login = "login_signup";
  static const String language = 'language';
  static const String currency = 'currency';
  static const String idCustomer = 'customerId';
  static const String customerName = 'customerName';
  static const String wkToken = "wkToken";
  static const String fcmToken = "fcmtoken";
  static const String fingerPrintData = "fingerPrintData";
  static const String loginUserData = "loginUserData";
  static const String allLanguages = "allLanguages";
  static const String allCurrencies = "allCurrencies";
  static const String cartAmount = 'cartAmount';
  static const String selectedShipping = "selectedShipping";
  static const String shippingAddressId = "addressId";
  static const String billingAddressId = "billingAddressId";
  static const String selectedPaymentId = "selectedPaymentId";
  static const String cartCount = "CartCount";
  static const String ShippingAddressSameAsBilling =
      "ShippingAddressSameAsBilling";
  static const String isArabicApp = "isArabicApp";
  static const String productID = "productID";
  static const String productOptions = "productOptions";
  static const String walkThrough = "walkThrough";
  static const String walkThroughStatus = "walkThroughStatus";
  static const String lightTheme = "lightTheme";
  static const String darkTheme = "darkTheme";
  static const String updatedTheme = "themeUpdated";
  //static const String selectedPaymentId = "guestCheckout";

  static logoutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(loginUserData);
    preferences.setBool(login, false);
    preferences.setString(idCustomer, "");
    preferences.setString(shippingAddressId, "");
    preferences.setString(selectedShipping, "");
    preferences.setString(billingAddressId, "");
    preferences.setString(selectedPaymentId, "");
    preferences.setString(cartAmount, "0");
    preferences.setString(cartCount, "0");
    preferences.setBool(ShippingAddressSameAsBilling, true);
  }

  static setProductId(int productID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(AppSharedPref.productID, productID);
  }

  static Future<int> getProductId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int producId = pref.getInt(AppSharedPref.productID) ?? 0;
    return producId;
  }

  static setWkToken(String wkToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppSharedPref.wkToken, wkToken);
  }

  static Future<String> getWkToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String wkToken = pref.getString(AppSharedPref.wkToken) ?? "";
    return wkToken;
  }

  static setCustomerId(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(idCustomer, id);
  }

  static Future<String> getCustomerId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(idCustomer) ?? "";
    return token;
  }

  static setCustomerName(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(idCustomer, id);
  }

  static Future<String> getCustomerName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(idCustomer) ?? "";
    return token;
  }

  static setLogin(bool isLogin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(login, isLogin);
  }

  static Future<bool> isLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool token = pref.getBool(login) ?? false;
    return token;
  }

  static setCustomerLanguage(String languageCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(language, languageCode);
  }

  static Future<String> getLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(language) ?? "en";
    return token;
  }

  static setCurrency(String selectedCurrency) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(currency, selectedCurrency);
  }

  static Future<String> getCurrency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(currency) ?? 'en';
  }

  static setFcmToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(fcmToken, token);
  }

  static Future<String> getFcmToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(fcmToken) ?? "";
    return token;
  }

  static setFingerprintData(Map<String, String> fingerprintData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(fingerPrintData, jsonEncode(fingerprintData));
  }

  static Future<Map<String, dynamic>?> getFingerprintData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString(fingerPrintData);
    print("qwdssada--$data");
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  static setLoginUserData(LoginModel loginModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(loginUserData, jsonEncode(loginModel.toJson()));
    pref.getString(loginModel.customerId ?? "");
  }

  static Future<LoginModel?> getLoginUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString(loginUserData);
    if (data != null) {
      return LoginModel.fromJson(json.decode(data));
    }
    return null;
  }

  /*
  * Checkout Proceess
  *
  * */
  static setCartAmount(String amount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(cartAmount, amount);
  }

  static Future<String> getCartAmount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // TODO(""Change this hardcoded value)
    return pref.getString(cartAmount) ?? "0";
  }

  static setSelectedShippingId(String carrierId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(selectedShipping, carrierId);
  }

  static Future<String> getSelectedShippingId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(selectedShipping) ?? "";
  }

  static setShippingAddressId(String shippingId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(shippingAddressId, shippingId);
  }

  static Future<String> getShippingAddressId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(shippingAddressId) ?? "";
  }

  static setBillingAddressId(String shippingId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(billingAddressId, shippingId);
  }

  static Future<String> getBillingAddressId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(billingAddressId) ?? "";
  }

  static setSelectedPaymentId(String paymentId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(selectedPaymentId, paymentId);
  }

  static Future<String> getSelectedPaymentId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(selectedPaymentId) ?? "";
  }

  static setAvailableCurrencies(Currencies? currencies) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(allCurrencies, jsonEncode(currencies?.toJson()));
  }

  static Future<Currencies?> getAvailableCurrencies() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString(allCurrencies);
    if (data != null) {
      return Currencies.fromJson(json.decode(data));
    }
    return null;
  }

  static setAvailableLanguages(Languages? languages) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(allLanguages, jsonEncode(languages?.toJson()));
  }

  static Future<Languages?> getAvailableLanguages() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString(allLanguages);
    if (data != null) {
      return Languages.fromJson(json.decode(data));
    }
    return null;
  }

  //cart count
  static setCartCount(String cartCount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppSharedPref.cartCount, cartCount);
  }

  static Future<String> getCartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String count = pref.getString(AppSharedPref.cartCount) ?? "0";
    return count;
  }

  static setShippingAddressSameAsBilling(bool isSame) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(ShippingAddressSameAsBilling, isSame);
  }

  static Future<bool> isShippingAddressSameAsBilling() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool token = pref.getBool(ShippingAddressSameAsBilling) ?? true;
    return token;
  }

  static setIsArabicApp(bool isArabic) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(isArabicApp, isArabic);
  }

  static Future<bool> getIsArabicApp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool token = pref.getBool(isArabicApp) ?? true;
    return token;
  }

  static setProductHasOption(bool isLogin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(productOptions, isLogin);
  }

  static Future<bool> getProductHasOption() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool hasOption = pref.getBool(productOptions) ?? false;
    return hasOption;
  }

  static Future<bool> getWalkThrough() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool hasOption = pref.getBool(walkThrough) ?? true;
    return hasOption;
  }

  static setWalkThrough(bool walkthrough) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(walkThrough, walkthrough);
  }

  static setWalkThroughStatus(String wkToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppSharedPref.walkThroughStatus, wkToken);
  }

  static Future<String> getWalkThroughStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String wkToken = pref.getString(AppSharedPref.walkThroughStatus) ?? "";
    return wkToken;
  }

  static Future<void> updateLightTheme(String themeData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(lightTheme, themeData);
  }

  static Future<String> getLightTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(lightTheme) ?? "";
  }

  static Future<void> updateDarkTheme(String themeData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(darkTheme, themeData);
  }

  static Future<String> getDarkTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(darkTheme) ?? "";
  }

  static Future<void> themeUpdated(bool updated) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(updatedTheme, updated);
  }

  static Future<bool> getThemeUpdated() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(updatedTheme) ?? false;
  }
}

final mAppStoragePref = AppStoragePref();

class AppStoragePref {
  static const String darkThemeSplash = "darkThemeSplashImage";
  static const String lightThemeSplash = "lightThemeSplashImage";
  static const String darkThemeLogo = "darkThemeLogo";
  static const String lightThemeLogo = "lightThemeLogo";
  static const String launcherType = "appLauncherType";
  static const String usedLauncherType = "usedLauncherType";
  static const String categoryType = "categoryType";
  static const String accountItemUserData = "accountItemUserData";

  var configurationStorage = GetStorage("configurationStorage");

  init() async {
    await GetStorage.init("configurationStorage");
    return true;
  }

  String getLightThemeSplashImage() {
    return configurationStorage.read(lightThemeSplash) ?? "";
  }

  setLightThemeSplash(String value) {
    configurationStorage.write(lightThemeSplash, value);
  }

  String getDarkThemeSplashImage() {
    return configurationStorage.read(darkThemeSplash) ?? "";
  }

  setDarkThemeSplash(String image) {
    configurationStorage.write(darkThemeSplash, image);
  }

  String getLightThemeLogo() {
    return configurationStorage.read(lightThemeLogo) ?? "";
  }

  setLightThemeLogo(String image) {
    configurationStorage.write(lightThemeLogo, image);
  }

  String getDarkThemeLogo() {
    return configurationStorage.read(darkThemeLogo) ?? "";
  }

  setDarkThemeLogo(String image) {
    configurationStorage.write(darkThemeLogo, image);
  }

  String getLauncherType() {
    return configurationStorage.read(launcherType) ?? "0";
  }

  setLauncherType(String count) {
    configurationStorage.write(launcherType, count);
  }

  String getIsLauncherUsed() {
    return configurationStorage.read(usedLauncherType) ?? "-1";
  }

  setLauncherUsed(String count) {
    configurationStorage.write(usedLauncherType, count);
  }

  setIsTabCategoryView(String value) {
    configurationStorage.write(categoryType, value);
  }

  String getIsTabCategoryView() {
    return configurationStorage.read(categoryType) ?? "0";
  }

  BannerModel? getUserData() {
    var userMap = configurationStorage.read(accountItemUserData);
    if (userMap != null) {
      return BannerModel.fromJson(userMap);
    }
    return null;
  }

  setUserData(BannerModel? userDataModel) {
    configurationStorage.write(accountItemUserData, userDataModel?.toJson());
  }
}
