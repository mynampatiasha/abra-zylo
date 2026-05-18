import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helper/app_localizations.dart';

class OptionsEditTextWidget extends StatefulWidget {
  ValueChanged<String>? selectedText = (test) {};
  String? optionDefaultValue;
  OptionsEditTextWidget({Key? key, this.selectedText, this.optionDefaultValue})
      : super(key: key);

  @override
  _OptionsEditTextWidgetState createState() => _OptionsEditTextWidgetState();
}

class _OptionsEditTextWidgetState extends State<OptionsEditTextWidget> {
  TextEditingController? optionController;
  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    optionController = TextEditingController(text: widget.optionDefaultValue);
    if (optionController?.text.isNotEmpty == true) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) widget.selectedText!(optionController?.text ?? "");
      }); // print("test   "+(optionController?.text)!);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 8.0, left: 8.0),
      child: Container(
        decoration: BoxDecoration(
          //  borderRadius: BorderRadius.circular(0),
          border: Border.all(color: AppColors.gray, width: 1),
        ),
        child:
            // TextField(
            //   controller: optionController,
            //   readOnly: true,
            //   keyboardType: TextInputType.text,
            //   decoration: InputDecoration(
            //     border: InputBorder.none,
            //     hintText: (_localizations
            //             ?.translate(AppStringConstant.enterRequirements) ??
            //         ''),
            //
            //     hintStyle: TextStyle(
            //         fontSize: AppSizes.size16,
            //         fontWeight: FontWeight.w400,
            //         color: AppColors.darkGray),
            //     contentPadding:
            //         EdgeInsets.symmetric(vertical: AppSizes.size12, horizontal: 8),
            //     isDense: true,
            //   ),
            //   style: TextStyle(
            //     fontSize: 14.0,
            //     color: Theme.of(context).textTheme.headlineMedium!.color,
            //   ),
            // ),

            TextFormField(
          autofocus: false,
          readOnly: false,
          minLines: 1,
          maxLines: 2,
          onChanged: widget.selectedText,
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: optionController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: (_localizations
                    ?.translate(AppStringConstant.enterRequirements) ??
                ''),
            hintStyle: const TextStyle(
                fontSize: AppSizes.size16,
                fontWeight: FontWeight.w300,
                color: AppColors.gray),
            contentPadding: const EdgeInsets.only(
                top: AppSizes.size12,
                bottom: AppSizes.size12,
                left: AppSizes.size8),
            isDense: true,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
