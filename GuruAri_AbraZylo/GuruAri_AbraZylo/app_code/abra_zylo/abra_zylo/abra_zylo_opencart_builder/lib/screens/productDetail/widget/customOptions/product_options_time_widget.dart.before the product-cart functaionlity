import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/generic_methods.dart';

import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';

class ProductOptionsTimeWidget extends StatefulWidget {
  ValueChanged<String>? time = (test) {};
  String? optionDefaultValue;
  ProductOptionsTimeWidget({Key? key, this.time, this.optionDefaultValue})
      : super(key: key);

  @override
  _ProductOptionsTimeWidgetState createState() =>
      _ProductOptionsTimeWidgetState();
}

class _ProductOptionsTimeWidgetState extends State<ProductOptionsTimeWidget> {
  final TextEditingController selectedTime = TextEditingController();

  AppLocalizations? _localizations; //
  @override
  void initState() {
    selectedTime.text = "";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
    if (widget.optionDefaultValue?.isNotEmpty == true) {
      selectedTime.text = widget.optionDefaultValue!;
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) widget.time!(selectedTime.text ?? "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0, bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: AppColors.lightGray, width: 1),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: TextField(
                  controller: selectedTime,
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,

                    hintText: "Choose Time",
                    hintStyle: TextStyle(
                        fontSize: AppSizes.size16,
                        fontWeight: FontWeight.w300,
                        color: AppColors.gray),
                    // hintStyle: TextStyle(
                    //     color: Theme.of(context).textTheme.headlineMedium!.color),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.headlineMedium!.color,
                  ),
                ),
              ),
              Expanded(
                  child: IconButton(
                icon: const Icon(
                  Icons.access_time,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  selectedTime.text = await GenericMethods()
                      .showTimePickerAndGetSelectedTime(
                          context,
                          _localizations
                                  ?.translate(AppStringConstant.chooseTime) ??
                              "");

                  setState(() {
                    widget.time!("${selectedTime.text?.toString()}");
                  });
                },
              )),
            ],
          ),
        ),
      );
    });
  }
}
