import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../models/accountInfoModel/account_info_model.dart';
import '../../../models/loginModel/login_model.dart';

abstract class AccountInfoRepository {
  Future<AccountInfoModel> getAccountAccountInfo(String wkToken);
  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken);
  Future<BaseModel> editCustomer(
      String wkToken,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String fax,
      bool changePassword,
      String? password);
  Future<BaseModel>? deleteAccount();
}

class AccountInfoRepositoryImp implements AccountInfoRepository {
  @override
  Future<AccountInfoModel> getAccountAccountInfo(String wkToken) async {
    var model = await ApiClient().userDetail(wkToken);
    return model;
  }

  @override
  Future<BaseModel> editCustomer(
      String wkToken,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String fax,
      bool changePassword,
      String? password) async {
    BaseModel? baseModel;
    if (changePassword) {
      baseModel = await ApiClient().editPassword(wkToken, password ?? "");
    }
    var model = await ApiClient()
        .editCustomer(wkToken, firstname, lastname, email, telephone, fax);
    if (baseModel != null && baseModel.error != null) {
      model.error = baseModel.error;
      model.message = baseModel.message;
    }
    return model;
  }

  @override
  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken) async {
    LoginModel model = await ApiClient().loginCustomer(wkToken, name, password,
        (!kIsWeb && Platform.isAndroid) ? fcmToken : null,
        (!kIsWeb && Platform.isIOS) ? fcmToken : null);
    // Platform.isAndroid ? value! : null,
    //         Platform.isIOS ? value! : null,
    return model;
  }

  @override
  Future<BaseModel>? deleteAccount() async {
    BaseModel model =
        await ApiClient().deleteUser(await AppSharedPref.getWkToken());
    return model;
  }
}
