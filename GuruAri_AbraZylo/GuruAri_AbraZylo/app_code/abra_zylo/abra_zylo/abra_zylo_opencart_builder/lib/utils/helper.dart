import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common_widgets/alert_message.dart';
import '../constants/app_constants.dart';
import '../helper/app_localizations.dart';

class Helper {
  static void hideSoftKeyBoard() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
  }

  Future downloadArData(BuildContext context, String fileUrl) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    try {
      Dio dio = Dio();
      var status = await Permission.storage.status;

      if (status.isGranted) {
        String fileName = "PersonalData." + "usdz";
        var savePath = await getFilePath(fileName);
        Dialogs.showLoadingDialog(context, _keyLoader);

        await dio.download(fileUrl, savePath,
            onReceiveProgress: (received, total) {
          if (received == total)
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          print("file downloaded AR" +
              " Download started received" +
              received.toString() +
              " total " +
              total.toString());
        });

        const platform = MethodChannel(AppConstant.channelName);
        try {
          if (Platform.isAndroid) {
            // await platform.invokeMethod('fileviewer', savePath);
          } else {
            await platform.invokeMethod('fileviewer', fileName);
          }
        } on PlatformException catch (e) {
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          print("Ar product platFrom issue $fileName");
        }
      } else if (status.isDenied) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        Permission.storage.request();
      }
    } catch (e) {
      AlertMessage.showError(
          AppLocalizations.of(context)?.translate(e.toString()) ??
              "Download completed",
          context);
      print("Exceptions Downloading" +
          "exception while downloading invoice " +
          e.toString());
    }
  }

  Future<String> getFilePath(fileName) async {
    String path = '';
    // var pat_h = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    // Directory dir = await getApplicationDocumentsDirectory();
    Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory();
    path = '${dir?.path}/$fileName';
    return path;
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.translate(AppStringConstant.fileDownloaded)}",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
