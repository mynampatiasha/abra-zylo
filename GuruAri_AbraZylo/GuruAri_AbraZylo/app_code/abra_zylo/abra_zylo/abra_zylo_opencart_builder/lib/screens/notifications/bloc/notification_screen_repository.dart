import 'dart:convert';

import 'package:oc_demo/models/notification/notification_screen_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';
import '../../../models/ApiLoginResponse/api_login_response.dart';
import '../../../network_manager/api_client.dart';
import 'package:crypto/crypto.dart';

abstract class NotificationScreenRepository {
  Future<NotificationScreenModel?> getNotification(String etag);
  Future<NotificationScreenModel?> getNotificationFromDb();
}

class NotificationScreenRepositoryImp implements NotificationScreenRepository {
  Future<NotificationScreenModel?> getNotificationFromDb() async {
    NotificationScreenModel? notificationScreenModel;
    String boxname = HiveConstant.viewNotification;
    print("pankaj ---->>>>>>>>" + boxname);
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxname).then((value) {
          if (value is NotificationScreenModel) {
            print("pankaj getNotificationFromDb()-- " + "${value}");
            notificationScreenModel = value as NotificationScreenModel;
          }
        });
      }
    });

    return notificationScreenModel;
  }

  @override
  Future<NotificationScreenModel?> getNotification(String etag) async {
    var model = await ApiClient().getNotifications(
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken(),
        etag);
    await HiveService.getHive().addBoxes(
        model, HiveConstant.viewNotification); //save notification in hive db
    return model;
  }
}
