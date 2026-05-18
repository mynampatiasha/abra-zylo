import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oc_demo/common_widgets/Tabbar/bottom_tabbar.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/main.dart';
import 'package:oc_demo/screens/notifications/views/other_notifications_widget.dart';

import '../constants/arguments_map.dart';

class Notifications {
  final _flutterPlugin = FlutterLocalNotificationsPlugin();

  final CHANNEL_ID = "CHANNEL_ID_OC";
  final CHANNEL_NAME = "NOTIFICATION_CHANNEL_OC";
  final CHANNEL_DESCRIPTION = "NOTIFICATION_CHANNEL_DESC_OC";

  late BuildContext _context;

  Future<void> init() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    const android = AndroidInitializationSettings("@drawable/ic_status");

    // flutter_local_notifications 19 renamed iOS settings to Darwin settings.
    const ios = DarwinInitializationSettings();
    final setting = InitializationSettings(android: android, iOS: ios);
    await _flutterPlugin.initialize(
      setting,
      // New callback wraps the old payload string in a NotificationResponse.
      onDidReceiveNotificationResponse: (response) =>
          _onSelectNotification(response.payload),
    );
  }

  Future<void> onDidReceiveNotification(
      int id, String? title, String? body, String? payload) async {}

  Future<void> _onSelectNotification(String? payload) async {
    try {
      handleNotificationCLick(
          jsonDecode(payload ?? ""), navigatorKey.currentContext!);
      // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (ctx) => BottomTabbarWidget()),
      //   (route) => false,
      // );
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<StyleInformation?> getNotificationStyle(String? image) async {
    if (image != null) {
      try {
        final ByteData imageData =
            await NetworkAssetBundle(Uri.parse(image)).load("");
        return BigPictureStyleInformation(
            ByteArrayAndroidBitmap(imageData.buffer.asUint8List()));
      } catch (e, stk) {
        print(stk);
      }
    } else {
      return null;
    }
    return null;
  }

  Future<void> showNotification(
      String? title, String? message, String? payload, String? image) async {
    print("pankaj showNotification");
    var notificationStyle = await getNotificationStyle(image);
    await _flutterPlugin.show(
      101,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          CHANNEL_ID,
          CHANNEL_NAME,
          // CHANNEL_DESCRIPTION,
          priority: Priority.high,
          importance: Importance.max,
          styleInformation: notificationStyle,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void checkInitialMessage(BuildContext context) {
    if (kIsWeb) return; // Firebase not initialized on web
    var firebase = FirebaseMessaging.instance;
    firebase.subscribeToTopic("OpenCart");
    firebase.getInitialMessage().then((RemoteMessage? message) {
      print("open app data");
      handleNotificationCLick(message?.data, context);
    });
  }

  void handleNotificationCLick(
      Map<String, dynamic>? data, BuildContext context) {
    print("dataReceive---${data}");
    if (data != null) {
      if (data['type'] == "product") {
        Navigator.of(context).pushNamed(AppRoute.productPage,
            arguments: getProductDataAttributeMap(
              data["title"] ?? "",
              data["id"] ?? "",
            ));
      } else if (data['type'] == "category") {
        Navigator.of(context).pushNamed(
          AppRoute.catalog,
          arguments: categoryMap(data["id"] ?? "", data["title"] ?? "", ""),
        );
      } else if (data['type'] == "Custom") {
        Navigator.of(context).pushNamed(
          AppRoute.catalog,
          arguments: categoryMap(data["id"] ?? "", data["title"] ?? "",
              GlobalData.custom_collection),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => OtherNotificationWidget(data["title"] ?? "",
                  (data["content"] ?? "") + "\n" + data["comment"] ?? "")),
        );
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data != null) {
        if (event.data['type'] == "product") {
          Navigator.of(context).pushNamed(AppRoute.productPage,
              arguments: getProductDataAttributeMap(
                event.data["title"] ?? "",
                event.data["id"] ?? "",
              ));
        } else if (event.data['type'] == "category") {
          Navigator.of(context).pushNamed(
            AppRoute.catalog,
            arguments: categoryMap(
                event.data["id"] ?? "", event.data["title"] ?? "", ""),
          );
        } else if (event.data['type'] == "Custom") {
          Navigator.of(context).pushNamed(
            AppRoute.catalog,
            arguments: categoryMap(event.data["id"] ?? "",
                event.data["title"] ?? "", GlobalData.custom_collection),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => OtherNotificationWidget(
                    event.data["title"] ?? "",
                    (event.data["content"] ?? "") +
                            "\n" +
                            event.data["comment"] ??
                        "")),
          );
        }
      }
    });
  }
}

final notification = Notifications();
