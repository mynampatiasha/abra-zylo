import 'package:flutter/material.dart';
import 'package:oc_demo/helper/generic_methods.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';

class ProductOptionsDateWidget extends StatefulWidget {
  ValueChanged<String>? selectedDate = (test) {};
  String? optionDefaultValue;
  ProductOptionsDateWidget(
      {Key? key, this.alsoShowTime, this.selectedDate, this.optionDefaultValue})
      : super(key: key);
  bool? alsoShowTime = false;

  @override
  _ProductOptionsDateWidgetState createState() =>
      _ProductOptionsDateWidgetState();
}

class _ProductOptionsDateWidgetState extends State<ProductOptionsDateWidget> {
  // TextEditingController? optionController; /*= TextEditingController();*/
  TextEditingController textValue = TextEditingController();

  AppLocalizations? _localizations; //
  DateTime? selectedDate = DateTime.now();

  //used for time if need to show time selector
  String? selectedTime = "";
  // String? textValue = "";
  @override
  void initState() {
    textValue.text = "";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /* optionController =
        TextEditingController(text: widget.optionDefaultValue ?? "");*/
    if (widget.optionDefaultValue?.isNotEmpty == true) {
      textValue.text = widget.optionDefaultValue!;
      /* WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) widget.selectedText!(optionController?.text ?? "");*/
    } else {
      textValue.text =
          "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year} ${selectedTime?.toString()}";
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) widget.selectedDate!(textValue.text ?? "");
    });

    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(
            top: 4.0, right: 8.0, left: 12.0, bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: AppColors.textBorderColor, width: 2),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: TextField(
                  controller: textValue,
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "YY/MM/DD",
                    hintStyle: TextStyle(
                        fontSize: AppSizes.size16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGray),
                    // hintStyle: TextStyle(color:Theme.of(context).textTheme.headlineMedium!.color),
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
                      onPressed: () async {
                        selectedDate = await GenericMethods()
                            .showDatePickerAndGetSelectedDate(
                                context,
                                selectedDate!,
                                (_localizations?.translate(
                                        AppStringConstant.chooseDate) ??
                                    "Select Date")
                                /* (widget.alsoShowTime == true
                              ? (_localizations?.translate(
                              AppStringConstant.chooseDate) ??
                              "")
                              : (_localizations
                              ?.translate(AppStringConstant.chooseDate) ??
                              ""))*/
                                );
                        if (widget.alsoShowTime == true) {
                          selectedTime = await GenericMethods()
                              .showTimePickerAndGetSelectedTime(
                                  context,
                                  _localizations?.translate(
                                          AppStringConstant.chooseTime) ??
                                      "Choose Time");
                        }

                        setState(() {
                          widget.selectedDate!(
                              "${selectedDate?.day}-${selectedDate?.month}-${selectedDate?.year} ${selectedTime?.toString()}");
                          textValue.text =
                              "${selectedDate?.day}-${selectedDate?.month}-${selectedDate?.year} ${selectedTime?.toString()}";
                        });
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.gray,
                      ))),
            ],
          ),
        ),
      );
    });
  }
}
