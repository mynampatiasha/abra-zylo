import 'dart:convert';

import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/notification/notification_screen_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/ApiLoginResponse/api_login_response.dart';
import '../../../network_manager/api_client.dart';
import 'package:crypto/crypto.dart';

abstract class NewsLetterScreenRepository {
  Future<BaseModel?> getNewsLetter();
  Future<BaseModel?> setNewsLetter(String newsLetter);
}

class NewsLetterScreenRepositoryImp implements NewsLetterScreenRepository {
  @override
  Future<BaseModel?> getNewsLetter() async {
    var model =
        await ApiClient().getNewsLetter(await AppSharedPref.getWkToken());
    return model;
  }

  @override
  Future<BaseModel?> setNewsLetter(String newsLetter) async {
    var model = await ApiClient()
        .subscribeNewsletter(await AppSharedPref.getWkToken(), newsLetter);
    return model;
  }
}
