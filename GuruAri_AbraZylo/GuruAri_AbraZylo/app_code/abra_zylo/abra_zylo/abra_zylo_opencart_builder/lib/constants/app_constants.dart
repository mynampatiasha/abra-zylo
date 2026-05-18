import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../helper/extension.dart';

class ApiConstant {
  /** *************************************************Builder live demo ********************************************/

  // For local web development, use the CORS proxy (run: lcp --proxyUrl https://abra-zylo.com --port 8010)
  // Switch back to the direct URL for mobile builds.
  static String get baseUrl => kIsWeb
      ? "http://localhost:8010/proxy/"
      : "https://abra-zylo.com/";
  static const String apiKey = 'abra';
  static const String apiPassword = '79218a25c2a07a92155aeb3c2b95d340';

  /// Rewrites image URLs to go through the CORS proxy on web.
  /// On mobile, returns the URL unchanged.
  static String imageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (!kIsWeb) return url;
    // Replace the direct domain with the proxy
    return url.replaceFirst('https://abra-zylo.com/', 'http://localhost:8010/proxy/');
  }
}

class AppConstant {
  static const String channelName = "com.webkul.oc.methodchannel";
  static const String searchText = "searchText";
  static const String searchImage = "searchImage";

  static const String appDocPath = "";
  static const List<String> supportedLanguages = ['en'];
  static const String mainPageBanner = "banner";
  static const String mainPageCategory = "category";
  static const String mainPagePopular = "popular";
  static const String mainPageBest = "best";
  static const String mainFeatureFeature = "featured";
  static const String mainPageLatest = "latest";
  static const String mainPageCarousel = "carousel";
  static const String mainPageRecent = "recently";

  /// Uncomment these topics for testing notification on local instance
  static const TOPICS = ["global", "globalAndroid"];
  static const appLogo = "assets/images/app_logo.png";

  static const isMarketPlace = false;

/*
* Demo login credentials
* */
  static const String demoEmail = "";
  static const String demoPassword = "";

  /*
  * Number constant like product limit or count on home page need to send in api's
  *
  * */
  static const String homePageProductCount = "6";
  static const String productReviewLimit = "10";

  // TODO("Replace this with API key")
  static const String googleKey = "AIzaSyCfb0p1u6Ugu8s17Sogt7PlV9UlLRhiCBo";

  /*
  * Function name need to send in checkout process api
  * */
  static const String shippingAddress = "shippingAddress";
  static const String paymentAddress = "paymentAddress";
  static const String shippingMethod = "shippingMethod";
  static const String paymentMethod = "paymentMethod";
  static const String confirm = "confirm";
  static const String existing = "existing";
  static const String guest = "guest";
  static const String saveGuest = "saveGuest";
  static const String saveGuestShipping = "saveGuestShipping";
}

class AppSizes {
  static const double linePadding = 4;
  static double deviceHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  static double deviceWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static const int splashScreenTitleFontSize = 14;
  static const double size15 = 15;
  static const double size14 = 14;
  static const double size12 = 12;
  static const double size8 = 8;
  static const double size4 = 4;
  static const double size6 = 6;
  static const double size16 = 16;
  static const double size24 = 24;
  static const double size10 = 10;
  static const double size20 = 20;
  static const double size18 = 18;
  static const double size22 = 22;
  static const double size26 = 26;
  static const double size30 = 30;
  static const double size34 = 34;
  static const double size27 = 27;
  static const double size1 = 1;
  static const double size2 = 2;
  static const double size240 = 240;
  static const double size58 = 58;
  static const double appBarSize = 56.0;
  static const double size40 = 40;
  static const double size44 = 44;
  static const double size0 = 0;
  static const double productListHeight = 210;
  static const double categoryImageSizeSmall = 90;
  static const double catProductItemHeight = 160;
  static const double categoryImageSizeMedium = 130;
  static const double cartProductSize = 96;
  static const double normalPadding = 8.0;
  static const double mediumPadding = 12.0;
  static const double size100 = 100;
  static const double size250 = 250;
  static const double size3 = 3;
  static const double size60 = 60;
  static const double size48 = 48;
  static const double categoryListingImageSize = 50;
  static const double itemHeight = 45;
}

class AppColors {
  static const red = Color(0xFFDB3022);
  static const lightRed = Color(0xFFF65F53);
  static const yellow = Color(0xFFEA9301);
  static const black = Color(0xFF222222);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const gray = Color(0xFF7D7D7D);
  static const white = Color(0xFFFFFFFF);
  static const orange = Color(0xFFFFBA49);
  static const background = Color(0xFFE5E5E5);
  static const backgroundLight = Color(0xFFF9F9F9);
  static const transparent = Color(0x00000000);
  static Color success = HexColor.fromHex("22bb33");
  static Color error = HexColor.fromHex("BB2124");
  static Color warning = HexColor.fromHex("f0ad4e");
  static const green = Color(0xFF2AA952);
  static const blue = Color(0xFF3D79EC);
  static const order_color = Color(0xFFFFE0B1);
  static const customer_color = Color(0xFFF57C1F);
  static const lightPrimaryColor = Color(0xFF546E7A);
  static const dividerColor = Color(0xFFE5E5E5);
  static const backgroundColor = Color(0xFFF5F5F5);
  static const textBorderColor = Color(0xFFE0E0E0);
  static const transparentBackground = Color(0x3B7F7D7D);
}

class AppImages {
  //================Icons==================//
  static const settingsIcon = "assets/icons/settings.png";
  static const translationIcon = "assets/icons/translation.png";
  static const googleIcon = "assets/icons/ic_google.png";
  static const facebookIcon = "assets/icons/ic_facebook.png";
  static const loginIcon = "assets/icons/login.png";
  static const accountIcon = "assets/icons/account.png";
  static const accountInfoIcon = "assets/icons/account_information.png";
  static const addressIcon = "assets/icons/address_book.png";
  static const dashboardIcon = "assets/icons/dashboard.png";
  static const logoutIcon = "assets/icons/logout.png";
  static const ordersIcon = "assets/icons/orders.png";
  static const wishlistsIcon = "assets/icons/wishlist.png";
  static const placeholder = "assets/images/placeholder.png";
  static const compare = "assets/icons/compare.png";
  static const cancelIcon = "assets/icons/close.png";
  static const deleteIcon = "assets/icons/ic_delete.png";
  static const avtar = "assets/images/ic_delete.png";

  //==============Lottie Assets============//
  static const fingerPrintLottie = "assets/lottie/finger_print.json";
  static const emptyAddressLottie = "assets/lottie/empty_address.json";
  static const emptyCartLottie = "assets/lottie/empty_cart.json";
  static const emptyOrderLottie = "assets/lottie/empty_order_list.json";
  static const emptyWishlistLottie = "assets/lottie/empty_wishlist.json";

  //=============Images===============//
  static const dashboardImage = "assets/images/dashboard_header.webp";
//===========marketplace=========//
  static const buyerIcon = "assets/icons/icon_buyers.png";
  static const orderIcon = "assets/icons/icon_orders.png";
  static const salesIcon = "assets/icons/icon_sales.png";
  static const filterIcon = "assets/icons/filter.png";
  static const reviewIcon = "assets/icons/review.png";
  static const orderIcons = "assets/icons/sellerorder.png";
  static const transaction = "assets/icons/transaction.png";
  static const sellerDashboard = "assets/icons/sellerdashboard.png";
  static const addProduct = "assets/icons/addproduct.png";
  static const sellerPage = "assets/icons/sellerpage.png";
  static const productList = "assets/icons/product_list.png";
  static const editNote = "assets/icons/edit.png";
}
