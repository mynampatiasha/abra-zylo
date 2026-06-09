import 'dart:convert';
import 'dart:io';

import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../models/accountInfoModel/account_info_model.dart';
import '../../../models/accountItemsListModel/account_items_list_model.dart';
import '../../../models/loginModel/login_model.dart';
import '../../../models/saveImageModel/save_image_model.dart';

abstract class ProfileRepository {
  Future<AccountInfoModel> getAccountAccountInfo();

  Future<BaseModel> toBecomeSeller(String shopName, String description);

  Future<AccountItemsListModel> getAccountItemsList();

  Future<SaveImageModel> uploadProfileImage({String? profileImage});

  Future<SaveImageModel> uploadBannerImage({String? bannerImage});
}

class ProfileRepositoryImp implements ProfileRepository {
  @override
  Future<AccountInfoModel> getAccountAccountInfo() async {
    var model = await ApiClient().userDetail(await AppSharedPref.getWkToken());
    return model;
  }

  @override
  Future<BaseModel> toBecomeSeller(String shopName, String description) async {
    var model = await ApiClient().toBecomeSeller(
        await AppSharedPref.getWkToken(), shopName, description);
    return model;
  }

  @override
  Future<AccountItemsListModel> getAccountItemsList() async {
    var model = await ApiClient().getAccountItemsList(
        await AppSharedPref.getCustomerId(), await AppSharedPref.getWkToken());
    return model;
  }

  @override
  Future<SaveImageModel> uploadProfileImage({String? profileImage = ""}) async {
    var model = await ApiClient().uploadProfileImage(
        await AppSharedPref.getCustomerId(),
        await AppSharedPref.getWkToken(),
        File(profileImage ?? ""));
    return model;
  }

  @override
  Future<SaveImageModel> uploadBannerImage({String? bannerImage = ""}) async {
    var model = await ApiClient().uploadBannerImage(
        await AppSharedPref.getCustomerId(),
        await AppSharedPref.getWkToken(),
        File(bannerImage ?? ""));
    return model;
  }
}
