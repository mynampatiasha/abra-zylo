// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';

import '../config/theme.dart';
import '../constants/app_constants.dart';
import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';
import '../utils/validator.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  String? labelText;
  final String? helperText;
  bool? isRequired;
  final TextInputType inputType;
  final String? validationType;
  final String? validationMessage;
  bool readOnly;
  bool? enable;
  bool? isDense;
  bool isPassword;
  Function(String)? onChange;
  int? maxLine;
  Widget? suffix;
  Function()? onEditingComplete;
  String? Function(String?)? validation;
  TextDirection? textDirection;
  FocusNode? focusNode;

  CommonTextField(
      {required this.controller,
      required this.isPassword,
      this.hintText = '',
      this.labelText = '',
      this.helperText,
      this.isRequired = false,
      this.inputType = TextInputType.text,
      this.validationType,
      this.validationMessage = '',
      this.maxLine = 1,
      this.readOnly = false,
      this.enable = true,
      this.onChange,
      this.validation,
      this.suffix,
      this.textDirection,
      this.onEditingComplete,
      this.focusNode,
      this.isDense = true});

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != "")
          Row(
            children: [
              Text(
                  (widget.labelText ??
                      '') /*+
                    ((widget.isRequired ?? false) ? "*" : ""*/
                  ,
                  style: TextStyle(color: AppColors.darkGray)),
              if (widget.isRequired == true)
                const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
        const SizedBox(height: AppSizes.size8),
        TextFormField(
            focusNode: widget.focusNode,
            textDirection: widget.textDirection,
            cursorColor: SchedulerBinding.instance!.window.platformBrightness ==
                    Brightness.dark
                ? AppColors.white
                : AppColors.black,
            enabled: widget.enable,
            readOnly: widget.readOnly,
            maxLines: widget.maxLine,
            obscureText: _obscureText,
            keyboardType: widget.inputType,
            controller: widget.controller,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
            onChanged: widget.onChange,
            onEditingComplete: widget.onEditingComplete,
            decoration: formFieldDecoration(
              context,
              widget.helperText,
              widget.hintText,
              isRequired: widget.isRequired,
              suffix: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: suffixIconColor(context),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffix,
              isDense: widget.isDense,
            ),
            validator:
                ((widget.isRequired == true) && (widget.validation == null))
                    ? (value) {
                        if (widget.isRequired == true) {
                          if (value?.isEmpty ?? false) {
                            return (widget.validationMessage != '')
                                ? widget.validationMessage
                                : "${AppLocalizations.of(context)?.translate(AppStringConstant.required)}";
                          } else if (widget.validationType ==
                              AppStringConstant.email) {
                            return Validator.isEmailValid(value ?? '', context);
                          } else if (widget.validationType ==
                              AppStringConstant.password) {
                            return Validator.isValidPassword(
                                AppLocalizations.of(context)
                                        ?.translate(value ?? "") ??
                                    '',
                                context);
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      }
                    : widget.validation),
      ],
    );
  }
}

InputDecoration formFieldDecoration(
  BuildContext context,
  String? helperText,
  String? hintText, {
  bool? isDense = true,
  bool? isRequired,
  Widget? suffix,
}) {
  return InputDecoration(
    isDense: isDense,
    errorMaxLines: 2,
    hintText: helperText,
    labelText: (hintText ?? "") +
        ((isRequired ?? false) && (hintText != '') ? "*" : ""),
    hintStyle: Theme.of(context)
        .textTheme
        .titleSmall
        ?.copyWith(fontWeight: FontWeight.normal, color: AppColors.darkGray),
    labelStyle: Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(fontWeight: FontWeight.normal, color: AppColors.darkGray),
    fillColor: MobikulTheme.primaryColor,
    suffixIcon: suffix,
    border: OutlineInputBorder(
        // borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
      color: AppColors.darkGray,
    )),
    focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
      color: AppColors.darkGray,
    )),
    disabledBorder: OutlineInputBorder(
        // borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
      color: AppColors.darkGray,
    )),
    enabledBorder: OutlineInputBorder(
        //  borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
      color: AppColors.darkGray,
    )),
  );
}

Color suffixIconColor(BuildContext context) {
  switch (Theme.of(context).brightness) {
    case Brightness.light:
      return Colors.grey.shade700;
    case Brightness.dark:
      return Colors.white70;
  }
}
