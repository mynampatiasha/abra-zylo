import 'dart:convert';
import 'dart:io' show Platform;

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/address/address_datum.dart';
import 'package:oc_demo/models/address/get_address.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/category.dart';
import 'package:oc_demo/models/catalog/category_data.dart';
import 'package:oc_demo/models/catalog/filter.dart';
import 'package:oc_demo/models/catalog/filter_group.dart';
import 'package:oc_demo/models/catalog/module_data.dart';
import 'package:oc_demo/models/catalog/sort.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:oc_demo/models/notification/notification_screen_model.dart';
import 'package:oc_demo/models/orderListModel/order_list_model.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/models/returnOrderListModel/return_order_list_model.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';
import 'package:oc_demo/models/wishlist/wishlist_datum.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_bloc.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_repository.dart';
import 'package:oc_demo/theme_bloc/theme_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/theme.dart';
import '../../constants/app_constants.dart';
import '../../helper/app_localizations.dart';
import 'constants/app_routes.dart';
import 'helper/app_restart.dart';
import 'helper/push_notifications_manager.dart';
import 'models/product/product.dart' as pro;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message?.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

FirebaseDatabase? secondaryDatabase;
final facebookAppEvents = FacebookAppEvents();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  // On web: Firebase requires a registered web app in Firebase Console.
  // For local development on web, Firebase features (push notifications,
  // realtime database) are skipped. Add your web appId from Firebase Console
  // to enable Firebase on web.
  if (!kIsWeb) {
    await Firebase.initializeApp();
    await notification.init();
    secondaryDatabase = FirebaseDatabase.instance;
    await facebookAppEvents.setAutoLogAppEventsEnabled(true);
  }
  GlobalData.selectedLanguage = await AppSharedPref.getLanguage();

  //For force restrict to portrait (mobile only)
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }
  await Hive.initFlutter();
  // Hive.registerAdapter(DynamicModelAdapter());
  /*Home model*/
  /* Hive.registerAdapter(HomePageDataAdapter());
  Hive.registerAdapter(BannersAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CarouselAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(LanguagesAdapter());
  Hive.registerAdapter(LanguageAdapter());
  Hive.registerAdapter(CurrenciesAdapter());
  Hive.registerAdapter(CurrencyAdapter());
  Hive.registerAdapter(FooterMenuAdapter());*/
  Hive.registerAdapter(BaseModelAdapter());
  //Product detail
  /*Product detail page*/
  //Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductDetailScreenModelAdapter());
  Hive.registerAdapter(OptionAdapter());
  Hive.registerAdapter(ReviewDataAdapter());
  Hive.registerAdapter(ReviewsAdapter());
  Hive.registerAdapter(ProductNextAdapter());
  Hive.registerAdapter(DiscountAdapter());
  Hive.registerAdapter(AttributeGroupAdapter());
  Hive.registerAdapter(AttributeAdapter());
  Hive.registerAdapter(RelatedProductAdapter());
  Hive.registerAdapter(ImagesAdapter());
  Hive.registerAdapter(ProductOptionValueAdapter());
  /*Category - catalog*/
  Hive.registerAdapter(SubCategoryModelAdapter());
  Hive.registerAdapter(CatalogModelAdapter());
  Hive.registerAdapter(SortAdapter());
  Hive.registerAdapter(pro.ProductAdapter());
  Hive.registerAdapter(FilterGroupAdapter());
  Hive.registerAdapter(FilterAdapter());
  Hive.registerAdapter(CategoryDataAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ModuleDataAdapter());
/*wishlist*/
  Hive.registerAdapter(WishlistDatumAdapter());
  /*Order list*/
  Hive.registerAdapter(OrderListDataAdapter());
  Hive.registerAdapter(OrderListModelAdapter());
  /*Return Order List*/
  Hive.registerAdapter(ReturnListDataAdapter());
  Hive.registerAdapter(ReturnOrderListModelAdapter());

  /*GetAddress*/
  Hive.registerAdapter(GetAddressAdapter());
  Hive.registerAdapter(AddressDatumAdapter());

  /*Notification*/
  Hive.registerAdapter(NotificationsAdapter());
  Hive.registerAdapter(NotificationScreenModelAdapter());

  /*Manufacture*/
  Hive.registerAdapter(ManufacturersAdapter());

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(AppRestart(child: const MyApp(/*lang*/)));
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<String?> fontNotifier =
      ValueNotifier(GoogleFonts.montserrat().fontFamily);

  //var language;
  const MyApp(/*this.language*/ {Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging? _messaging;

  void _registerBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _checkForInitialMessage() async {
    var message = await _messaging?.getInitialMessage();
    debugPrint("Firebase Notification data----->" + jsonEncode(message));
    if (message != null) {
      if (message.notification != null) {
        String? title = message.notification?.title;
        String? body = message.notification?.body;
        String? imageUrl = "";
        if (!kIsWeb && Platform.isAndroid) {
          imageUrl = message.notification?.android?.imageUrl;
        } else if (!kIsWeb) {
          imageUrl = message.notification?.apple?.imageUrl;
        }
        if (!kIsWeb && Platform.isAndroid) {
          await notification.showNotification(
            title,
            body,
            jsonEncode(message.data),
            imageUrl,
          );
        }
      } else {
        String? title = message.data["title"];
        String? body = message.data["body"];
        String? imageUrl = message.data["attachment"];
        if (!kIsWeb && Platform.isAndroid) {
          await notification.showNotification(
            title,
            body,
            jsonEncode(message.data),
            imageUrl,
          );
        }
      }
    }
  }

  void _requestPermissions() async {
    if (!kIsWeb && Platform.isIOS) {
      await _messaging?.requestPermission();
    }

    _messaging?.getToken().then((value) {
      print(value);
    });
  }

  void _registerForegroundMessageHandler() async {
    // FirebaseMessaging.instance.subscribeToTopic(topic);
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      debugPrint("_registerForegroundMessageHandler" + "${message?.toMap()}");

      if (message != null) {
        if (message.notification != null) {
          String? title = message.notification?.title ?? message.data["title"];
          String? body = message.notification?.body ?? message.data["body"];
          String? imageUrl = "";
          if (!kIsWeb && Platform.isAndroid) {
            imageUrl = message.notification?.android?.imageUrl;
          } else if (!kIsWeb) {
            imageUrl = message.notification?.apple?.imageUrl;
          }
          if (!kIsWeb && Platform.isAndroid) {
            await notification.showNotification(
              title,
              body,
              jsonEncode(message.data),
              imageUrl,
            );
          }
        } else {
          // return;
          String? title = message.data["title"];
          String? body = message.data["body"];
          String? imageUrl = message.data["attachment"];
          if (!kIsWeb && Platform.isAndroid) {
            await notification.showNotification(
              title,
              body,
              jsonEncode(message.data),
              imageUrl,
            );
          }
        }
      }
    }, onError: (_, stk) {
      debugPrint("sanjeev error");
      debugPrint(stk);
    }, onDone: () {
      debugPrint("done");
    });
  }

  @override
  void initState() {
    if (!kIsWeb) {
      _messaging = FirebaseMessaging.instance;
      _requestPermissions();
      _checkForInitialMessage();
      _registerForegroundMessageHandler();
      _registerBackgroundMessageHandler();
    }
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("selected locale --> ${GlobalData.selectedLanguage}");
    /* notification
        .showNotification("Test title", "Test message", "Payload", "image");*/
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => ThemeBloc(),
        ),
        BlocProvider<ItemCardBloc>(
          create: (context) => ItemCardBloc(
            repository: ItemCardRepositoryImp(),
          ),
        ),
      ],
      child: BlocConsumer<ThemeBloc, ThemeState>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            ThemeData? light, dark;
            if (state is ThemeInitialState) {
              light = state.lightTheme;
              dark = state.lightTheme;
            } else if (state is ThemeChangeState) {
              light = state.lightTheme;
              dark = state.lightTheme;
            }
            return MaterialApp(
                builder: (context, child) {
                  return MediaQuery.withNoTextScaling(child: child!);
                },
                title: 'Opencart ',
                theme: light,
                darkTheme: light,
                themeMode: ThemeMode.system,
                onGenerateRoute: AppRoute.generateRoute,
                initialRoute: AppRoute.splash,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [routeObserver],
                locale: Locale(GlobalData.selectedLanguage ?? "ar"),
                navigatorKey: navigatorKey,
                supportedLocales:
                    AppConstant.supportedLanguages.map((e) => Locale(e)),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  var lang = GlobalData.selectedLanguage;
                  var langloc = Locale(lang ?? "ar");
                  if (supportedLocales.contains(langloc)) {
                    return langloc;
                  } else {
                    return supportedLocales.first;
                  }
                });
          }),
    );
  }
}
