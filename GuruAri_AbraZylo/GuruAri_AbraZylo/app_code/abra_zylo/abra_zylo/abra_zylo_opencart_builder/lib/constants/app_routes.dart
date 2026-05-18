import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/Tabbar/bottom_tabbar.dart';
import 'package:oc_demo/helper/extension.dart';
import 'package:oc_demo/models/splash/splash_screen_model.dart';
import 'package:oc_demo/screens/accountInfo/account_info_screen.dart';
import 'package:oc_demo/screens/accountInfo/bloc/account_info_bloc.dart';
import 'package:oc_demo/screens/accountInfo/bloc/account_info_repository.dart';
import 'package:oc_demo/screens/brand_screen/brand_screen.dart';
import 'package:oc_demo/screens/category/bloc/categories_screen_bloc.dart';
import 'package:oc_demo/screens/category/category_screen.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_bloc.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_repository.dart';
import 'package:oc_demo/screens/checkout/order_review/bloc/order_review_screen_bloc.dart';
import 'package:oc_demo/screens/checkout/shipping/bloc/shipping_screen_bloc.dart';
import 'package:oc_demo/screens/checkout/shipping/checkout_shipping_screen.dart';
import 'package:oc_demo/screens/cmsPage/bloc/cms_page_bloc.dart';
import 'package:oc_demo/screens/cmsPage/bloc/cms_screen_repository.dart';
import 'package:oc_demo/screens/cmsPage/cms_page.dart';
import 'package:oc_demo/screens/compare_products/bloc/compare_product_bloc.dart';
import 'package:oc_demo/screens/compare_products/bloc/compare_product_repository.dart';
import 'package:oc_demo/screens/compare_products/compare_product_screen.dart';
import 'package:oc_demo/screens/dashboard/dashboard_screen.dart';
import 'package:oc_demo/screens/login_qr/login_qr_screen.dart';
import 'package:oc_demo/screens/myDownloadableProducts/bloc/downloadable_product_screen_bloc.dart';
import 'package:oc_demo/screens/myDownloadableProducts/bloc/downloadable_product_screen_repository.dart';
import 'package:oc_demo/screens/myDownloadableProducts/my_downloadable_products_screen.dart';
import 'package:oc_demo/screens/newsLetter/bloc/newsletter_screen_bloc.dart';
import 'package:oc_demo/screens/newsLetter/news_letter.dart';
import 'package:oc_demo/screens/orderDetail/bloc/order_detail_screen_bloc.dart';
import 'package:oc_demo/screens/orderDetail/bloc/order_detail_screen_repository.dart';
import 'package:oc_demo/screens/orderDetail/order_detail_screen.dart';
import 'package:oc_demo/screens/orders_list/bloc/order_screen_bloc.dart';
import 'package:oc_demo/screens/orders_list/bloc/order_screen_repository.dart';
import 'package:oc_demo/screens/orders_list/orders_screen.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_repository.dart';
import 'package:oc_demo/screens/productDetail/Bloc/review_screen_bloc.dart';
import 'package:oc_demo/screens/productDetail/product_detail_screen.dart';
import 'package:oc_demo/screens/returnInformation/bloc/return_order_information_screen_repository.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_bloc.dart';
import 'package:oc_demo/screens/returnOrderForm/return_order_screen.dart';
import 'package:oc_demo/screens/rewardTransactionInfoScreen/reward_info_screen.dart';
import 'package:oc_demo/screens/search/bloc/search_bloc.dart';
import 'package:oc_demo/screens/search/bloc/search_repository.dart';
import 'package:oc_demo/screens/search/search_screen.dart';
import 'package:oc_demo/screens/splash/bloc/splash_screen_bloc.dart';
import 'package:oc_demo/screens/splash/bloc/splash_screen_repository.dart';
import 'package:oc_demo/screens/splash/splash_screen.dart';
import 'package:oc_demo/screens/sub_category_screen/bloc/subcategory_screen_bloc.dart';
import 'package:oc_demo/screens/sub_category_screen/bloc/subcategory_screen_repository.dart';
import 'package:oc_demo/screens/sub_category_screen/sub_category_screen.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_delivery_boy_screen_repository.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_dellivery_boy_bloc.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/track_delivery_boy.dart';
import 'package:oc_demo/screens/walk_through/bloc/walk_through_bloc.dart';
import 'package:oc_demo/screens/walk_through/bloc/walk_through_repository.dart';
import 'package:oc_demo/screens/walk_through/walk_through_screen.dart';

import '../../screens/home/bloc/home_screen_bloc.dart';
import '../../screens/home/bloc/home_screen_repository.dart';
import '../screens/add_edit_address/add_edit_address.dart';
import '../screens/add_edit_address/bloc/add_edit_address_repository.dart';
import '../screens/add_edit_address/bloc/add_edit_address_screen_bloc.dart';
import '../screens/address_book/address_book.dart';
import '../screens/address_book/bloc/addressbook_screen_bloc.dart';
import '../screens/address_book/bloc/addressbook_screen_repository.dart';
import '../screens/brand_screen/bloc/brand_screen_bloc.dart';
import '../screens/brand_screen/bloc/brand_screen_repository.dart';
import '../screens/cart/bloc/cart_screen_bloc.dart';
import '../screens/cart/bloc/cart_screen_repository.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/catalog_screen/bloc/catalog_screen_bloc.dart';
import '../screens/catalog_screen/bloc/catalog_screen_repository.dart';
import '../screens/catalog_screen/catalog_screen.dart';
import '../screens/category/bloc/categories_screen_repository.dart';
import '../screens/checkout/guest/checkout_guest_widget.dart';
import '../screens/checkout/order_review/bloc/order_review_screen_repository.dart';
import '../screens/checkout/order_review/order_review.dart';
import '../screens/checkout/shipping/bloc/shipping_screen_repository.dart';
import '../screens/delivery_tracking/delivery_tracking_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/location/location_screen.dart';
import '../screens/login_signup/bloc/signin_signup_screen_bloc.dart';
import '../screens/login_signup/bloc/signin_signup_screen_repository.dart';
import '../screens/login_signup/signin_signup_screen.dart';
import '../screens/newsLetter/bloc/newsletter_screen_repository.dart';
import '../screens/orders_and_returns/bloc/orders_and_returns_screen_bloc.dart';
import '../screens/orders_and_returns/bloc/orders_and_returns_screen_repository.dart';
import '../screens/orders_and_returns/orders_and_returns_screen.dart';
import '../screens/productDetail/widget/review/show_product_reviews_widget.dart';
import '../screens/returnInformation/bloc/return_order_information_screen_bloc.dart';
import '../screens/returnInformation/return_order_information_screen.dart';
import '../screens/returnOrderForm/bloc/return_order_repository.dart';
import '../screens/returnOrderList/bloc/return_order_screen_bloc.dart';
import '../screens/returnOrderList/bloc/return_order_screen_repository.dart';
import '../screens/returnOrderList/return_order_screen.dart';
import '../screens/reviews/block/reviews_screen_bloc.dart';
import '../screens/reviews/block/reviews_screen_repository.dart';
import '../screens/reviews/reviews_screen.dart';
import '../screens/rewardTransactionInfoScreen/transaction_info_screen.dart';
import '../screens/wishlist/bloc/wishlist_bloc.dart';
import '../screens/wishlist/bloc/wishlist_repository.dart';
import '../screens/wishlist/wishlist_screen.dart';

class AppRoute {
  //Argument Constant
  static const String productPage = 'productPage';
  static const String homePage = 'homePage';
  static const String reviewDetails = 'reviewDetails';
  static const String splash = 'splash';
  static const String login = 'login_signup';
  static const String bottomTabBAr = 'bottomTabBar';
  static const String accountInfo = 'accountInfo';
  static const String cart = 'cart';
  static const String category = "category";
  static const String subCategory = "subcategory";
  static const String catalog = "catalog";
  static const String trackDeliveryBoy = "trackDeliveryBoy";
  static const String orderDetail = "orderDetail";
  static const String shipping = "shipping";
  static const String orderReview = "orderReview";
  static const String wishlist = "wishlist";
  static const String returnOrders = "returnOrders";
  static const String cmsPage = "cmsPage";
  static const String rewardScreen = "rewardScreen";
  static const String transactionScreen = "transactionScreen";
  static const String orderList = "orderList";
  static const String newsLetter = "newsLetter";
  static const String addressBook = "addressBook";
  static const String addEditAddress = "addEditAddress";
  static const String location = "location";
  static const String downloadableProducts = "downloadableProducts";
  static const String dashboardScreen = "dashboardScreen";
  static const String loginUsingQr = "loginUsingQr";
  static const String searchScreen = "searchScreen";
  static const String guestCheckout = "guestCheckout";
  static const String brand = "brand";
  static const String returnDetail = "returnDetail";
  static const String returnProduct = "returnProduct";
  static const String walkThrough = 'walkThrough';
  static const String ordersAndReturns = 'ordersAndReturns';
  static const String productReview = 'productReview';

  static const String deliveryTrackingScreen = "deliveryTrackingScreen";

  /*
  *
  * MarketPlace Route Constant start
  * */

  static const String sellerPage = "sellerPage";
  static const String sellerList = "sellerList";
  static const String sellerProfile = "sellerProfile";
  static const String sellerProduct = "sellerProduct";
  static const String sellerDashboard = "sellerDashboard";
  static const String sellerOrders = "sellerOrders";
  static const String sellerReviews = "sellerReviews";
  static const String sellerTransition = "sellerTransition";
  static const String addProduct = "addProduct";
  static const String generalTab = "generalTab";
  static const String dataTab = "dataTab";
  static const String attributeTab = "attributeTab";
  static const String discountTab = "discountTab";
  static const String specialTab = "specialTab";
  static const String imageTab = "imageTab";
  static const String linksTab = "linksTab";
  static const String optionTab = "optionTab";
  static const String addOptionTab = "addOptionTab";
  static const String productList = "productList";
  static const String compareProduct = "compareProduct";
  static const String sellerOrderDetials = "sellerOrderDetials";
  static const String marketPlaceProduct = "marketPlaceProduct";
  /*
  *
  * MarketPlace Route Constant end
  * */

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      /*
      * Route for Splash Screen
      * */
      case splash:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      SplashScreenBloc(repository: SplashScreenRepositoryImp()),
                  child: const SplashScreen(),
                ));
      /*
      * Route for Home page
      * */
      case homePage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      HomeScreenBloc(repository: HomeScreenRepositoryImp()),
                  child: HomeScreen((_, path) {}),
                ));
      /*
        * Route for Product detail Page
        * */
      case productPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) =>
                  ProductDetailBloc(repository: ProductDetailRepositoryImp()),
              child: ProductDetailScreen(
                  ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{}))),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SigninSignupScreenBloc(
                repository: SigninSignupScreenRepositoryImp()),
            child:
                SignInSignUpScreen(((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})),
          ),
        );

      case bottomTabBAr:
        return MaterialPageRoute(
          builder: (_) => const BottomTabbarWidget(),
        );

      /*
        *Route to Show all product review
        * */
      case reviewDetails:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ReviewScreenBloc(repository: ProductDetailRepositoryImp()),
            child: ShowProductReviewWidget(
                ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})),
          ),
        );
      /*
        * Route for Cart Cart page/ screen
        * */
      case cart:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<CartScreenBloc>(
                create: (context) =>
                    CartScreenBloc(repository: CartScreenRepositoryImp()),
                child: const CartScreen()));
      case category:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CategoriesScreenBloc(
              repository: CategoriesScreenRepositoryImp(),
            ),
            child: CategoriesScreen(
              selectedIndex: (((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{}))
                      .get("selectedIndex") ??
                  0,
              categoryPath: -1,
            ),
          ),
          settings: settings,
        );
      case subCategory:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SubcategoryBloc(
              repository: SubCategoryRepositoryImp(),
            ),
            child: SubCategoryScreen(
              ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{}),
            ),
          ),
          settings: settings,
        );

      case orderList:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      OrderScreenBloc(repository: OrderScreenRepositoryImp()),
                  child: OrderScreen(settings.arguments as bool),
                ));
      case returnOrders:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ReturnOrderScreenBloc(
                      repository: ReturnOrderScreenRepositoryImp()),
                  child: ReturnOrderScreen(),
                ));
      case wishlist:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) =>
                    WishlistScreenBloc(repository: WishlistImpRepository()),
                child: const WishlistScreen()));
      case cmsPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      CMSScreenBloc(repository: CMSScreenRepositoryImp()),
                  child:
                      CMSPageView(((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})),
                ));
      case addressBook:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AddressBookScreenBloc>(
            create: (context) => AddressBookScreenBloc(
              repository: AddressBookRepositoryImp(),
            ),
            child: AddressBook(),
          ),
        );
      case downloadableProducts:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => DownloadableProductScreenBloc(
              repository: DownloadableProductScreenRepositoryImp(),
            ),
            child: MyDownloadableProductsScreen(),
          ),
        );
      case addEditAddress:
        String? id;
        if (settings.arguments != null) {
          id = (((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{}))["addressId"];
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddEditAddressScreenBloc(
                repository: AddEditAddressRepositoryImp()),
            child: AddEditAddress(id),
          ),
        );
      case location:
        return MaterialPageRoute(builder: (_) => const LocationScreen());
      case newsLetter:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<NewsLetterScreenBloc>(
                create: (context) => NewsLetterScreenBloc(
                      repository: NewsLetterScreenRepositoryImp(),
                    ),
                child: NewsletterScreen()));
      case rewardScreen:
        return MaterialPageRoute(builder: (_) => RewardInfoScreen());
      case transactionScreen:
        return MaterialPageRoute(builder: (_) => TransactionInfoScreen());
      case dashboardScreen:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case loginUsingQr:
        return MaterialPageRoute(builder: (_) => const LoginQrScan());

      case searchScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SearchScreenBloc>(
            create: (context) => SearchScreenBloc(
              repository: SearchRepositoryImp(),
            ),
            child: const SearchScreen(),
          ),
        );
      case searchScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SearchScreenBloc>(
            create: (context) => SearchScreenBloc(
              repository: SearchRepositoryImp(),
            ),
            child: const SearchScreen(),
          ),
        );
      case accountInfo:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      AccountInfoBloc(repository: AccountInfoRepositoryImp()),
                  child: const AccountInfoScreen(),
                ));
      /*
        * Checkout route start
        * */
      case shipping:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ShippingScreenBloc(
                      repository: ShippingScreenRepositoryImp()),
                  child: CheckoutShippingScreen(
                      ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})),
                ));
      case orderReview:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => OrderReviewScreenBloc(
                      repository: OrderReviewScreenRepositoryImp()),
                  child:
                      OrderReview(((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})),
                ));
      /*
        * Guest Checkout
        * */
      case guestCheckout:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => GuestCheckoutScreenBloc(
                      repository: GuestCheckoutScreenRepositoryImp()),
                  child: const GuestCheckoutAddressWidget(
                      /*((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})*/),
                ));

      /** Guest Order return **/
      case ordersAndReturns:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => OrdersAndReturnsBloc(
                    repository: OrdersAndReturnsRepositoryImp()),
                child: const OrdersAndReturns()));
      /*
      * Checkout route end
      * */

      case productReview:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ReviewsScreenBloc(
                      repository: ReviewsScreenRepositoryImp()),
                  child: ReviewsScreen(settings.arguments as bool),
                ));

      case catalog:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider(
            create: (context) =>
                CatalogScreenBloc(repository: CatalogRepositoryImpl()),
            child: CatalogScreen(
              ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{}),
            ),
          ),
          settings: settings,
        );

      case trackDeliveryBoy:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider(
            create: (context) => TrackDeliveryBoyBloc(
                repository: TrackDeliveryBoyRepositoryImp()),
            child: TrackDeliveryBoy(
              ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{}),
            ),
          ),
          settings: settings,
        );
      case orderDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                OrderDetailsBloc(repository: OrderDetailRepositoryImp()),
            child: OrderDetails(settings.arguments as String),
          ),
          settings: settings,
        );
      case returnDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ReturnOrderInformationScreenBloc(
                repository: ReturnOrderInformationScreenRepositoryImp()),
            child: ReturnOrderInformationScreen(settings.arguments as String),
          ),
          settings: settings,
        );
      case returnProduct:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ReturnOrderBloc(repository: ReturnOrderRepositoryImp()),
            child: ReturnOrderProductScreen(
                ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})),
          ),
          settings: settings,
        );
      case brand:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                BrandScreenBloc(repository: BrandScreenRepositoryImp()),
            child: BrandScreen(
              (settings.arguments as String),
            ),
          ),
          settings: settings,
        );
      /*case brand:
        return MaterialPageRoute(
          builder: (_) => BrandScreen( (settings.arguments as String))
              // (((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{}))["carousel"]),
        );*/

      /*
        * Market place route start
        * */

      case walkThrough:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      WalkThroughBloc(repository: WalkThroughRepositoryImp()),
                  child: WalkThroughScreen(
                      settings.arguments as WalkthroughDataResponse?),
                ));
      case compareProduct:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => CompareProductBloc(
                      repository: CompareProductRepositoryImp()),
                  child: CompareProducts(),
                ));
      case deliveryTrackingScreen:
        return MaterialPageRoute(
            builder: (_) => DeliveryTrackingScreen(
                ((settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{})));
      /*
        * Market place route end
        * */
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
