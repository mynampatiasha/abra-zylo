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
                  (widget.labelText ?? '').toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: Color(0xFF8f889c), // ink-soft
                  )),
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
            style: const TextStyle(
                fontFamily: 'Karla',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF2b2540)), // ink
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
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    suffixIcon: suffix,
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        borderSide: BorderSide(
      color: Color(0xFFece7f3),
      width: 1.5,
    )),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        borderSide: BorderSide(
      color: Color(0xFF5232a8),
      width: 1.5,
    )),
    disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        borderSide: BorderSide(
      color: Color(0xFFece7f3),
      width: 1.5,
    )),
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        borderSide: BorderSide(
      color: Color(0xFFece7f3),
      width: 1.5,
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
