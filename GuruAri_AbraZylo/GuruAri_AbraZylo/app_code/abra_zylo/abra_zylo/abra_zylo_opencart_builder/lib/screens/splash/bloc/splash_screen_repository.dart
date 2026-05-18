import 'dart:convert';

import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/splash/splash_screen_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/ApiLoginResponse/api_login_response.dart';

import '../../../network_manager/api_client.dart';
import 'package:crypto/crypto.dart';

abstract class SplashScreenRepository {
  /*Future<HomePageData?> getHomeData();*/
  Future<ApiLoginResponseModel?> apiLogin();
  Future<BaseModel?> updateLanguage(String code);
  Future<SplashScreenModel?> getSplashScreen();
}

class SplashScreenRepositoryImp implements SplashScreenRepository {
  @override
  Future<ApiLoginResponseModel?> apiLogin() async {
    ApiLoginResponseModel? model = await ApiClient().apiLogin(
        ApiConstant.apiKey,
        (ApiConstant.apiPassword),
        await AppSharedPref.getCustomerId(),
        await AppSharedPref.getLanguage(),
        await AppSharedPref.getCurrency());
    return model;
    return null;
  }

  @override
  Future<BaseModel?> updateLanguage(String code) async {
    var model = await ApiClient()
        .updateLanguage(await AppSharedPref.getWkToken(), code);
    return model;
  }

  @override
  Future<SplashScreenModel?> getSplashScreen() async {
    var model = await ApiClient().getSplashScreen(
        AppSizes.deviceHeight.toString(),
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken());
    return model;
  }
  /* @override
  Future<HomePageData?> getHomeData() async {
    HomePageData? model = await ApiClient().getHomePage(
        "1", "5", AppSizes.deviceWidth.toInt(), "mb3q78ietdj4rapsbksttaksp1");
    return model;
  }*/
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
