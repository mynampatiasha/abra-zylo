import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/network_manager/multipart_file_upload.dart';

import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../helper/generic_methods.dart';
import '../../../../network_manager/apis.dart';

class ProductOptionsFileWidget extends StatefulWidget {
  ValueChanged<String>? uploadedFileCode = (test) {};
  static const String tag = "_ProductOptionsFileWidgetState:- ";

  ProductOptionsFileWidget({Key? key, this.uploadedFileCode}) : super(key: key);

  @override
  _ProductOptionsFileWidgetState createState() =>
      _ProductOptionsFileWidgetState();
}

class _ProductOptionsFileWidgetState extends State<ProductOptionsFileWidget> {
  final TextEditingController optionController = TextEditingController();
  String? selectedFileName = "";
  static const String tag = "_ProductOptionsFileWidgetState:- ";
  AppLocalizations? _localizations; //
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              //getting file path using  library
              var filePath =
                  await GenericMethods().showFilePickerAndGetPath(context);
              //extracting name and extension from file path
              selectedFileName = filePath.split("/").last;
              var extension = selectedFileName?.split(".").last;

              //if file path or extension is not null then proceed for multipart request to upload file oin server else show error
              if (filePath != null && filePath != "" && extension != "") {
                var stringResponse = await MultiPartImageUpload.asyncFileUpload(
                    ApiConstant.baseUrl + Apis.fileUpload,
                    filePath,
                    selectedFileName,
                    extension);

                print(tag + "${stringResponse}");
                //Convert return string response to json to extact value from response
                var jsonResponse = json.decode(stringResponse);
                print(tag + " ${jsonResponse}");

                //If response contain success then show success message and  set code to options
                if (jsonResponse["success"] != null) {
                  GenericMethods.showAlertMessages(
                      context, jsonResponse["success"]);
                  setState(() {
                    widget.uploadedFileCode!(jsonResponse["code"] ?? "");
                  });
                } else if (jsonResponse["error"] != null) {
                  //if response contain error then show error message
                  GenericMethods.showErrorAlertMessages(
                      context, jsonResponse["error"]);
                }
              } else {
                //else show error for extension or path is not correct
                GenericMethods.showErrorAlertMessages(context,
                    "${_localizations?.translate(AppStringConstant.selectCorrectExtensionFile)}");
              }
            },
            child: Text(
                "${_localizations?.translate(AppStringConstant.chooseFile)}"),
          ),
          Text("${selectedFileName}")
        ],
      );
    });
  }
}
