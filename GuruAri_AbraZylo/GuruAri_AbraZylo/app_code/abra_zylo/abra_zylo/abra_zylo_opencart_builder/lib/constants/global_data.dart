import '../models/homPage/home_screen_model.dart';

class GlobalData {
  static List<Categories>? rootCategories;
  static List<FooterMenu>? cmsPageData;
  static List<Categories>? carouselCategory;

  // to keep track of cart total amount
  static String cartTotal = "";
  static String feature_products = "feature_products";
  static String latest_products = "latest_products";
  static String popular_products = "popular_products";
  static String best_products = "best_products";
  static String custom_collection = "Custom";
  static String home_page_carousel = "home_page_carousel";

  //
  static String customerId = "";
  static int selectedCategory = 0;
  static int selectedIndex = 0;
  static String selectedCategoryId = "";
  static String menuFirstCategoryId = "";
  static String tempPassword = "";
  static double cardSize = 250;
  static String? cookies = "";

  //to keep track of selected language

  static String? selectedLanguage = "ar";
}
