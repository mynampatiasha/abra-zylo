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
import '../../screens/home/widgets/home_page_categories_widget.dart';
import '../../screens/home/widgets/home_page_product_collection_view.dart';
import '../../screens/home/widgets/reach_bottom_view.dart';
import 'bloc/home_screen_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.moveToCategory, {Key? key}) : super(key: key);

  final Function(int, int) moveToCategory;

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
        appBar: commonAppBar(
            _localizations?.translate(AppConstant.isMarketPlace
                    ? AppStringConstant.appNameMarketplace
                    : AppStringConstant.appNameBuilder) ??
                '',
            context,
            hideSearch: true,
            hideNotification: true,
            isHomeEnable: true),
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

    if ((homePageModel?.home_sequence?.length ?? 0) > 0)
      for (int i = 0; i < homePageModel!.home_sequence!.length; i++) {
        if (homePageModel!.home_sequence![i].type == "carousel") {
          for (int j = 0; j < homePageModel!.carousels!.length; j++) {
            if (homePageModel!.home_sequence![i].id ==
                homePageModel!.carousels![j].homeSequenceId) {
              if (homePageModel!.carousels![j].type == "Image" &&
                  homePageModel!.carousels![j].imageSubType ==
                      "image_carousel") {
                if (homePageModel!.carousels![j].slider?.length != 0)
                  widgets.add(HomePageBannerWidget(
                    homePageModel?.carousels![j].slider ?? [],
                    homePageModel?.carousels![j].title ?? "",
                  ));
                break;
              } else if (homePageModel!.carousels![j].type == "Image" &&
                  homePageModel!.carousels![j].imageSubType ==
                      "image_all_parrent_category") {
                if (homePageModel!
                        .carousels![j].imageTypeCategoryCarousal?.length !=
                    0)
                  widgets.add(HomePageCategories(
                      homePageModel?.carousels![j].title ?? "",
                      homePageModel?.carousels![j].imageTypeCategoryCarousal,
                      (index, path) => widget.moveToCategory(index, path)));
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
                if (homePageModel!.carousels![j].imageCatagory?.length != 0)
                  widgets.add(HomePageCategories(
                      homePageModel?.carousels![j].title ?? "",
                      homePageModel?.carousels![j].imageCatagory,
                      (index, path) => widget.moveToCategory(index, path)));
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
}
