import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common_widgets/alert_message.dart';
import '../constants/app_constants.dart';
import 'app_localizations.dart';
import 'app_shared_pref.dart';

class GenericMethods {
  static String getStringValue(BuildContext context, String key) {
    return AppLocalizations.of(context)?.translate(key) ?? key;
  }

  static showAlertMessages(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertMessage.showSuccess(message, context);
    });
  }

  static showErrorAlertMessages(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertMessage.showError(message, context);
    });
  }

  /*
  *
  * Method to show time picker and return time
  *
  * */
  Future<String> showTimePickerAndGetSelectedTime(
      BuildContext context, String title) async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: title,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.black,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      return result.format(context);
    }
    return "";
  }

  /*
  *
  * Method to pick file from gallery
  *
  * */
  Future<String> showFilePickerAndGetPath(BuildContext context) async {
    // file_picker 11 exposes pickFiles as a static API instead of FilePicker.platform.
    FilePickerResult? result = await FilePicker.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024);
      print("sizeInKB ${sizeInMb}");
      return file.path;
    } else {
      return "";
    }
  }

  /*
  * Method will return the selected date from Date picker
  * */

  showDatePickerAndGetSelectedDate(
      BuildContext context, DateTime currentDate, String title) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      helpText: title,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.black,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
            textTheme: TextTheme(
              bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: AppSizes.size14), // Selected Date landscape
              // days
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) return selectedDate;
    return "";
  }
}
