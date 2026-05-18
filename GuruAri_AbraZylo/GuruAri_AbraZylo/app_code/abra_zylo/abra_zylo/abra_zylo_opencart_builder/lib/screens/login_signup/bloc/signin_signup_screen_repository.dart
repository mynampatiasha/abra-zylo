import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';

import '../../../network_manager/api_client.dart';

abstract class SigninSignupScreenRepository {
  Future<RegisterAccountModel>? getRegisterPageData(String wkToken);

  Future<LoginModel>? addCustomer(
    String wkToken,
    String customer_group_id,
    String firstname,
    String lastname,
    String email,
    String telephone,
    String password,
    String isSubscribe,
    String agree,
    String tobecomepartner,
    String shoppartner,
    String android_device_id,
  );

  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken);

  Future<BaseModel>? forgotPassword(String wkToken, String email);
  Future<BaseModel>? checkEmail(String wkToken, String email);

  Future<LoginModel>? googleSignIn(
      String wkToken, String googleId, String email,
      String firstname, String lastname, String fcmToken);
}

class SigninSignupScreenRepositoryImp implements SigninSignupScreenRepository {
  @override
  Future<RegisterAccountModel>? getRegisterPageData(String wkToken) async {
    RegisterAccountModel model = await ApiClient().registerAccount(wkToken);
    return model;
  }

  @override
  Future<LoginModel>? addCustomer(
      String wkToken,
      String customer_group_id,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String password,
      String isSubscribe,
      String agree,
      String tobecomepartner,
      String shoppartner,
      String android_device_id) async {
    LoginModel model = await ApiClient().addCustomer(
        wkToken,
        customer_group_id,
        firstname,
        lastname,
        email,
        telephone,
        password,
        isSubscribe,
        agree,
        tobecomepartner,
        shoppartner,
        android_device_id);
    return model;
  }

  @override
  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken) async {
    print('asddsaas---$fcmToken');
    LoginModel model = await ApiClient().loginCustomer(wkToken, name, password,
        (!kIsWeb && Platform.isAndroid) ? fcmToken : null,
        (!kIsWeb && Platform.isIOS) ? fcmToken : null);
    return model;
  }

  @override
  Future<BaseModel>? forgotPassword(String wkToken, String email) async {
    BaseModel model = await ApiClient().forgotPassword(wkToken, email);
    return model;
  }

  @override
  Future<BaseModel>? checkEmail(String wkToken, String email) async {
    BaseModel model = await ApiClient().checkEmail(wkToken, email);
    return model;
  }

  @override
  Future<LoginModel>? googleSignIn(
      String wkToken, String googleId, String email,
      String firstname, String lastname, String fcmToken) async {
    LoginModel model = await ApiClient().googleLogin(
      wkToken,
      googleId,
      email,
      firstname,
      lastname,
      (!kIsWeb && Platform.isAndroid) ? fcmToken : null,
      (!kIsWeb && Platform.isIOS) ? fcmToken : null,
    );
    return model;
  }
}
