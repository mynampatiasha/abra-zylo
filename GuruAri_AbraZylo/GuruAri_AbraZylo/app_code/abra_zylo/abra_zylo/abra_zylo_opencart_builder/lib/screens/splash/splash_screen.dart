import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/models/splash/splash_screen_model.dart';
import 'package:oc_demo/screens/checkout/guest/bloc/guest_checkout_state.dart';
import 'package:oc_demo/screens/splash/dynamicTheme.dart';

import '../../constants/app_constants.dart';
import '../../config/theme.dart';
import '../../helper/app_shared_pref.dart';
import '../../helper/extension.dart';
import '../../helper/generic_methods.dart';
import '../../models/ApiLoginResponse/api_login_response.dart';
import '../../screens/splash/bloc/splash_screen_bloc.dart';
import '../../screens/splash/bloc/splash_screen_event.dart';
import '../../screens/splash/bloc/splash_screen_state.dart';
import '../../theme_bloc/theme_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  bool isLoading = true;
  ThemeBloc? bloc;
  SplashScreenBloc? splashScreenBloc;
  SplashScreenModel? _splashScreenModel;
  ApiLoginResponseModel? apiLoginResponseModel;
  String? splash;
  // bool isArabic = false;

  @override
  void initState() {
    splashScreenBloc = context.read<SplashScreenBloc>();
    bloc = context.read<ThemeBloc>();
    // checkAndUpdateTheme();
    print("rtcf ${apiLoginResponseModel?.wkToken}");
    checkWkToken();
    super.initState();
  }

  void checkWkToken() async {
    // isArabic=await AppSharedPref.getIsArabicApp();
    String wkToken = await AppSharedPref.getWkToken();
    if (wkToken.isEmpty) {
      splashScreenBloc?.add(const ApiLoginEvent());
    } else {
      splashScreenBloc?.add(const GetSplashScreen());
      /*if (isArabic) {
        splashScreenBloc?.add(UpdateLanguageEvent("ar"));
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SplashScreenBloc, SplashScreenState>(
          builder: (context, currentState) {
        if (currentState is InitialState) {
          isLoading = true;
        } else if (currentState is ApiLoginSuccessState) {
          // Api login_signup response success
          // save response detail in shared preference for further use
          apiLoginResponseModel = currentState.apiLoginResponseModel;
          isLoading = false;
          setWkTokenData();
        } else if (currentState is UpdateLanguageSuccess) {
          isLoading = false;
          AppSharedPref.setCustomerLanguage("en");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoute.bottomTabBAr, (Route<dynamic> route) => false);
          });
        } else if (currentState is SplashSuccessState) {
          isLoading = false;
          _splashScreenModel = currentState.splashScreenModel;
          setApplicationData();
          DynamicTheme().manageThemeData(
              _splashScreenModel, splashScreenBloc, bloc, context);
        } else if (currentState is SplashScreenError) {
          isLoading = false;
          // AlertMessage.showSuccess("Splash Error", context);
          //Api Login error
          //Stop app to move to home page and show error
        } else if (currentState is EmptyState) {}
        return splashView();
      }),
    );
  }

  splashView() {
    return Stack(
      children: [
        if (Theme.of(context).brightness == Brightness.dark &&
            mAppStoragePref.getDarkThemeSplashImage().isNotEmpty == true) ...[
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(
                    ApiConstant.imageUrl(mAppStoragePref.getDarkThemeSplashImage() ?? ''),
                  ),
                  fit: BoxFit.fitHeight,
                )),
          )
        ] else if (Theme.of(context).brightness == Brightness.light &&
            mAppStoragePref.getLightThemeSplashImage().isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(
                  ApiConstant.imageUrl(mAppStoragePref.getLightThemeSplashImage()),
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          )
        ] else ...[
          if (Theme.of(context).brightness == Brightness.light) ...[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            )
          ] else ...[
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
            )
          ]
          // SizedBox(
          //     width: AppSizes.deviceWidth.toDouble(),
          //     height: AppSizes.deviceHeight.toDouble(),
          //     child: Image.asset(
          //       // isArabic==false?
          //       "assets/images/splash_screen.png"  /*"assets/images/marketplace_splash_screen.png" "assets/images/arabic_splash_screen.png" */,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
        ],
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: isLoading,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom
    ]); // Revert the status bar visiblity
  }

  void setApplicationData() async {
    //  Custom theme and splash related data
    mAppStoragePref.setDarkThemeSplash(
        _splashScreenModel?.dark_theme_config?.darkSplashScreen ?? "");
    mAppStoragePref.setDarkThemeLogo(
        _splashScreenModel?.dark_theme_config?.mobikulThemeDarkLogo ?? "");

    mAppStoragePref.setLightThemeSplash(
        _splashScreenModel?.light_theme_config?.lightSplashScreen ?? "");
    mAppStoragePref.setLightThemeLogo(
        _splashScreenModel?.light_theme_config?.mobikulThemeBrightLogo ?? "");

    mAppStoragePref
        .setLauncherType(_splashScreenModel?.launcherIconConfiguration ?? "0");

    mAppStoragePref.setIsTabCategoryView(
        _splashScreenModel?.appCategoryViewConfiguration ?? "0");

    checkAppIconUpdate();

    setWalkThrough();
  }

  void setWalkThrough() {
    AppSharedPref.getWalkThrough().then((value) async {
      // if (value && await AppSharedPref.getWalkThroughStatus() == "1") {
      //   print("rishabh 1");
      //   Future.delayed(const Duration(seconds: 1)).then((value) =>
      //       Navigator.of(context).pushNamedAndRemoveUntil(
      //           AppRoute.walkThrough, (Route<dynamic> route) => false,
      //           arguments: _splashScreenModel?.walkthroughDataResponse));
      // } else {
      print("rishabh 2");
      Future.delayed(const Duration(seconds: 1)).then((value) =>
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoute.bottomTabBAr, (Route<dynamic> route) => false));
      // }
    });
  }

  void setWkTokenData() async {
    AppSharedPref.setWkToken(apiLoginResponseModel?.wkToken ?? "");
    AppSharedPref.setWalkThroughStatus(
        apiLoginResponseModel?.walkThroughStatus ?? "0");

    // AppSharedPref.setCustomerLanguage(apiLoginResponseModel?.language ?? "ar");
    AppSharedPref.setCustomerLanguage("en");
    AppSharedPref.setCurrency(apiLoginResponseModel?.currency ?? "");
    splashScreenBloc?.add(const GetSplashScreen());
  }

  void checkAndUpdateTheme() async {
    // if ((await AppSharedPref.getLightTheme()).isNotEmpty && (await AppSharedPref.getDarkTheme()).isNotEmpty) {
    //   try {
    //     var lightTheme = LightThemeConfigure.fromJson(jsonDecode(await AppSharedPref.getLightTheme()));
    //     var darkTheme = DarkThemeConfigure.fromJson(jsonDecode(await AppSharedPref.getDarkTheme()));
    //     // await _updateLightTheme(lightTheme);
    //     // await _updateDarkTheme(darkTheme);
    //     // bloc?.add(ThemeChangeEvent(lightTheme: AppTheme.lightTheme, darkTheme: AppTheme.darkTheme,));
    //   } catch (e) {
    //     // ignore
    //   }
    // }
  }

  void checkAppIconUpdate() async {
    if (kIsWeb) return; // MethodChannel not available on web
    const platform = MethodChannel("com.webkul.oc.methodchannel");
    try {
      if (mAppStoragePref.getLauncherType() !=
          mAppStoragePref.getIsLauncherUsed()) {
        mAppStoragePref.setLauncherUsed(mAppStoragePref.getLauncherType());
        if (Platform.isIOS) {
          await platform.invokeMethod(
              'dynamicLauncher', mAppStoragePref.getLauncherType());
        } else {
          await platform.invokeMethod(
              'dynamicLauncher', mAppStoragePref.getLauncherType());
        }
      }
    } catch (e) {
      print("Error icons-----> ${e.toString()}");
    }
  }
}
