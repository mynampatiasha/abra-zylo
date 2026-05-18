import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oc_demo/common_widgets/dialog_helper.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';

import '../constants/app_constants.dart';
import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';

class PrivacyPolicyCustomCheckbox extends StatefulWidget {
  final Function(bool) isCheckboxSelected;
  final String? title;
  final String? description;
  final bool? dark;

  const PrivacyPolicyCustomCheckbox(
      this.isCheckboxSelected, this.title, this.description,
      {Key? key, this.dark})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _checkboxState();
  }
}

class _checkboxState extends State<PrivacyPolicyCustomCheckbox> {
  bool isSelected = false;
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          side: BorderSide(
            color: AppColors.black,
          ),
          checkColor: AppColors.white,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.black; // Change color based on dark mode
            }
            return Colors.transparent;
          }),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              isSelected = value ?? false;
            });
            widget.isCheckboxSelected(isSelected);
          },
        ),
        Flexible(
          child: Text(
            localizations?.translate(AppStringConstant.readAgreePrivacy) ??
                "23",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        InkWell(
          onTap: () {
            DialogHelper.termsAndPrivacyDialog(
              context,
              widget.title,
              widget.description,
            );
          },
          child: Text(
            localizations?.translate(widget.title ?? "") ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}
