import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/helper/open_bottom_model_sheet_helper.dart';
import 'package:oc_demo/helper/push_notifications_manager.dart';
import 'package:oc_demo/network_manager/api_client.dart';
import 'package:oc_demo/screens/home/widgets/home_page_Image_carousel.dart';
import 'package:oc_demo/screens/home/widgets/home_page_carousel_widget.dart';
import 'package:oc_demo/screens/home/widgets/view_all_widget.dart';

import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/widget_space.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/global_data.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../helper/notification_service.dart';
import '../../hive/prefetch_service.dart';
import '../../models/ApiLoginResponse/api_login_response.dart';
import '../../models/homPage/home_screen_model.dart';
import '../../screens/home/widgets/home_page_banner_widget.dart';
import '../../screens/home/widgets/home_page_trust_badges_widget.dart';
import '../../screens/home/widgets/home_page_categories_widget.dart';
import '../../screens/home/widgets/home_page_promo_banner_widget.dart';
import '../../screens/home/widgets/home_page_product_collection_view.dart';
import '../../screens/home/widgets/reach_bottom_view.dart';
import 'bloc/home_screen_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.moveToCategory, {this.moveToTab, Key? key}) : super(key: key);

  final Function(int, int) moveToCategory;
  final Function(int)? moveToTab;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String TAG = "_HomeScreenState";
  HomeScreenBloc? homePageBloc;
  AppLocalizations? _localizations;
  bool isLoading = true; // Variable used to handle visibility of loader
  HomePageData? homePageModel; //HomePage Model/data
  bool? addedToWishlist = false;
  String token = "";
  final _scrollController = ScrollController();
  List<Product> recentProductList = [];
  Set<String> displayedCarousels = {};

  @override
  void initState() {
    Notifications().checkInitialMessage(context);
    GlobalData.selectedIndex = 0;
    GlobalData.selectedCategory = 0;
    GlobalData.selectedCategoryId = "";
    homePageBloc = context.read<HomeScreenBloc>();
    // homePageBloc?.add( RecentProductEvent());
    homePageBloc?.add(HomeScreenDataFetchEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    _registerFcmToken();
    // print(homePageModel.carousels)
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF673AB7), Color(0xFF8E24AA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ]
                        ),
                        child: Image.asset('assets/images/app_logo.png', height: 40),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to Abra Zylo!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  text: _localizations?.translate(AppStringConstant.home) ?? 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.moveToTab != null) widget.moveToTab!(0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.category_outlined,
                  text: _localizations?.translate(AppStringConstant.categories) ?? 'Categories',
                  onTap: () {
                    Navigator.pop(context);
                    widget.moveToCategory(0, -1);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_cart_outlined,
                  text: _localizations?.translate(AppStringConstant.cart) ?? 'Cart',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.moveToTab != null) widget.moveToTab!(2);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.account_circle_outlined,
                  text: _localizations?.translate(AppStringConstant.profile) ?? 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.moveToTab != null) widget.moveToTab!(3);
                  },
                ),
                const Divider(height: 40, thickness: 1, indent: 20, endIndent: 20),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/app_logo.png', height: 24),
              const SizedBox(width: 8),
              const Text(
                'Abra Zylo',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoute.searchScreen);
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                notificationBottomModelSheet(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, currentState) {
            print("Rishabh" + currentState.toString());
            if (currentState is HomeScreenInitial) {
              isLoading = true;
            } else if (currentState is HomeScreenSuccess) {
              homePageModel = currentState.homePageData;
              AppSharedPref.setCartCount((homePageModel?.cart ?? 0).toString());
              // var loginModel = await AppSharedPref.getLoginUserData();
              // loginModel?.newsletter = isNewsletter;
              //AppSharedPref.setLoginUserData(loginModel!);
              AppSharedPref.getLoginUserData().then((value) {
                if (value != null) {
                  value.partner = homePageModel?.partner ?? 0;
                  value.partnerApproveRequired =
                      homePageModel?.partnerApproveRequired ?? false;
                  AppSharedPref.setLoginUserData(value);
                }
              });
              TabbarController.countController.sink
                  .add(homePageModel?.cart ?? 0);
              isLoading = false;
              /*   WidgetsBinding.instance?.addPostFrameCallback((_) {
                buildHomePageView();
              */ /* setState(() {

               });*/ /*
              });*/
            } else if (currentState is HomeScreenError) {
              isLoading = false;
              print("Rishabh" + currentState.message.toString());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Show a user-friendly message instead of raw error object
                final msg = (currentState.message?.isNotEmpty == true &&
                        !currentState.message!.contains('Instance of'))
                    ? currentState.message!
                    : 'Unable to load. Please check your connection.';
                AlertMessage.showError(msg, context);
              });
            }
            /*else if (currentState is RecentproductStateSuccess) {
              recentProductList=currentState.RecentProductList;
              // WidgetsBinding.instance?.addPostFrameCallback((_) {
              //   setState(() {
              //
              //   });
              // });
              */ /*isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showError(currentState.message ?? '', context);
              });*/ /*
            }*/

            return buildHomePageView();
          },
        ));
  }

/*
* Method to build home page UI
* Will check the home sequence and further call the widget accordingly
* */
  Widget buildHomePageView() {
    PrefetchService.preFetchBestProductsFromDb();
    PrefetchService.preFetchPopularProductsFromDb();
    PrefetchService.preFetchLatestProductsFromDb();
    PrefetchService.preFetchFeatureProductsFromDb();

    return RefreshIndicator(
      onRefresh: _refreshHomePage,
      child: Stack(
        children: [
          Visibility(
            visible: (homePageModel?.home_sequence?.length ?? 0) > 0,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // --- NEW SEARCH BAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoute.searchScreen);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Search for products, brands & more...",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            Icon(Icons.qr_code_scanner, color: Colors.grey.shade600),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // -----------------------
                  ...getWidgets()
                  //  widgetSpace(),
                  /*  Builder(
                    builder: (context) {
                      return RecentView();
                    }
                  ),*/
                  //  buildReachBottomView(context, _scrollController) //Bottom View
                  // ,TextFormField(
                  //   initialValue: token
                  //
                  //    ),
                ],
              ),
            ),
          ),
          Visibility(visible: isLoading, child: const Loader())
        ],
      ),
    );
  }

  // ** App refresh function  function **//

  Future<Null> _refreshHomePage() async {
    print(TAG + 'refreshing home');
    //only call api and refresh view some view like-recent product will not change
    /* homePageBloc?.add(HomeScreenDataFetchEvent());
    homePageBloc?.emit(HomeScreenInitial());*/
    //to reload whole page
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoute.bottomTabBAr);
  }

  // ** App token get function **//

  void _registerFcmToken() {
    if (kIsWeb) return; // Firebase not initialized on web
    FirebaseMessaging.instance.getToken().then((value) async {
      print(" FCM token - " + value.toString());
      AppSharedPref.setFcmToken(value ?? "");
      token = value ?? "";
      ApiClient().registerCustomerDeviceToken(
        await AppSharedPref.getWkToken(),
        Platform.isAndroid ? value! : null,
        Platform.isIOS ? value! : null,
      );
    });
    for (var topic in AppConstant.TOPICS) {
      FirebaseMessaging.instance.subscribeToTopic(topic);
    }
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = [];
    bool hasAddedTrustBadges = false;

    if ((homePageModel?.home_sequence?.length ?? 0) > 0)
      for (int i = 0; i < homePageModel!.home_sequence!.length; i++) {
        if (homePageModel!.home_sequence![i].type == "carousel") {
          for (int j = 0; j < homePageModel!.carousels!.length; j++) {
            if (homePageModel!.home_sequence![i].id ==
                homePageModel!.carousels![j].homeSequenceId) {
              if (homePageModel!.carousels![j].type == "Image" &&
                  homePageModel!.carousels![j].imageSubType ==
                      "image_carousel") {
                if (homePageModel!.carousels![j].slider?.length != 0) {
                  widgets.add(HomePageBannerWidget(
                    homePageModel?.carousels![j].slider ?? [],
                    homePageModel?.carousels![j].title ?? "",
                  ));
                  if (!hasAddedTrustBadges) {
                    widgets.add(const HomePageTrustBadgesWidget());
                    hasAddedTrustBadges = true;
                  }
                }
                break;
              } else if (homePageModel!.carousels![j].type == "Image" &&
                  homePageModel!.carousels![j].imageSubType ==
                      "image_all_parrent_category") {
                if (homePageModel!
                        .carousels![j].imageTypeCategoryCarousal?.length !=
                    0) {
                  widgets.add(HomePageCategories(
                      homePageModel?.carousels![j].title ?? "",
                      homePageModel?.carousels![j].imageTypeCategoryCarousal,
                      (index, path) => widget.moveToCategory(index, path)));
                  widgets.add(const HomePagePromoBanner());
                }
                break;
              } else if (homePageModel!.carousels![j].type == "Image" &&
                  homePageModel!.carousels![j].imageSubType ==
                      "image_manufacturer") {
                //widgetSpace(0, AppSizes.size16),
                // widgetSpace(0, AppSizes.size16),
                // widgets.add(widgetSpace(0, AppSizes.size16));
                widgets.add(viewAllButton(
                    context, homePageModel?.carousels![j].title, () {
                  Navigator.of(context).pushNamed(
                    AppRoute.brand,
                    arguments: homePageModel?.carousels![j].homeSequenceId,
                    /* arguments: {
                                    "carouselId": homePageModel?.carousels![j].homeSequenceId,
                                  },*/
                  );
                }, 0));
                // widgets.add(widgetSpace(0, AppSizes.size16));
                widgets.add(homePageCarouselWidget(
                    context, homePageModel?.carousels![j].imageManufacturer));
                // widgets.add( widgetSpace(0, AppSizes.size16));
                break;
              } else if (homePageModel!.carousels![j].type == "Image" &&
                  homePageModel!.carousels![j].imageSubType ==
                      "image_catagory") {
                // Duplicate category section removed — only showing image_all_parrent_category above
                break;
              } else if (homePageModel!.carousels![j].type == "Product") {
                if (homePageModel!.carousels![j].product?.length != 0)
                  widgets.add(homePageProductCollection(
                    context,
                    homePageModel?.carousels![j].product,
                    homePageModel?.carousels![j].title ?? "",
                    /*  homePageModel?.carousels![j].productType??"",*/
                    homePageModel?.carousels![j].homeSequenceId ?? "",
                  ));
                break;
              }
            }
          }
        } else {
          for (int j = 0; j < homePageModel!.banners!.length; j++) {
            if (homePageModel!.home_sequence![i].id ==
                homePageModel!.banners![j].homeSequenceId) {
              widgets.add(HomePageImageCarousel(homePageModel!.banners![j]));
              // widgets.add(widgetSpace(0, AppSizes.size16));
              break;
              //
            }
          }
        }
      }
    return widgets;
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: AppColors.black, size: 26),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        hoverColor: AppColors.background,
        splashColor: const Color(0xFF673AB7).withOpacity(0.2),
        onTap: onTap,
      ),
    );
  }
}
