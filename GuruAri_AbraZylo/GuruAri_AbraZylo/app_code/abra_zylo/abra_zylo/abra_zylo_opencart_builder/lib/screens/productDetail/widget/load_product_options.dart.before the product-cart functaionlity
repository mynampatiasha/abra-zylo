import 'package:flutter/material.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/screens/productDetail/widget/customOptions/options_checkbox_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/customOptions/product_options_File_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/customOptions/product_options_date_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/customOptions/product_options_time_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/customOptions/options_edit_text_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/customOptions/options_radio_button_widget.dart';

import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import 'customOptions/options_drop_down_widget.dart';

class LoadProductCustomOptions extends StatefulWidget {
  List<Option>? options;
  ValueChanged<Map<String, dynamic>>? productOptionsSelectedByUser;

  LoadProductCustomOptions(
      {Key? key, this.options, this.productOptionsSelectedByUser})
      : super(key: key);

  @override
  _LoadProductCustomOptionsState createState() =>
      _LoadProductCustomOptionsState();
}

class _LoadProductCustomOptionsState extends State<LoadProductCustomOptions> {
  Map<String, dynamic> productOptions = {};
  static const String tag = "LoadProductOptions:-  ";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(tag + "${widget.options}");
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.size10),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          Widget variationWidget = Container();
          switch (widget.options?[i].type) {
            case "select":
              //Drop Down View
              variationWidget = OptionsDropDownWidget(
                variants: widget.options?[i].productOptionValue,
                selectedOption: (String val) {
                  print(tag + "drop down selected item${val}");
                  setState(() {
                    productOptions["${widget.options?[i].productOptionId}"] =
                        val;
                    widget.productOptionsSelectedByUser!(productOptions);
                  });
                },
              );
              break;
            case "radio":
              //RadioView
              variationWidget = OptionsRadioButtonView(
                  optionsValueList: widget.options?[i].productOptionValue,
                  selectedOption: (String val) {
                    print(tag + "Radio selected item ${val}");
                    setState(() {
                      productOptions["${widget.options?[i].productOptionId}"] =
                          val;
                      widget.productOptionsSelectedByUser!(productOptions);
                    });
                  });
              break;
            case "checkbox":
              //CheckBoxView
              variationWidget = OptionsCheckBoxWidget(
                  options: widget.options,
                  variants: widget.options?[i].productOptionValue,
                  selectedOption: (selectedVal) {
                    setState(() {
                      print(tag + "checkbox selected item ${selectedVal}");
                      productOptions["${widget.options?[i].productOptionId}"] =
                          selectedVal;
                      widget.productOptionsSelectedByUser!(productOptions);
                      //  widget.options?[i].variants?[selectedVal[1]].isSelected = true;
                    });
                  });
              break;
            case "textarea":
              //EditTextView
              variationWidget = OptionsEditTextWidget(
                selectedText: (value) {
                  print(tag + "enter value in text field is : ${value}");
                  productOptions["${widget.options?[i].productOptionId}"] =
                      value;
                  widget.productOptionsSelectedByUser!(productOptions);
                },
                optionDefaultValue: widget.options?[i].value ?? "",
              );

              break;
            case "text":
              //EditTextView
              variationWidget = OptionsEditTextWidget(
                selectedText: (value) {
                  print(tag + "enter value in text field is : ${value}");
                  productOptions["${widget.options?[i].productOptionId}"] =
                      value;
                  widget.productOptionsSelectedByUser!(productOptions);
                },
                optionDefaultValue: widget.options?[i].value ?? "",
              );
              break;
            case "date":
              /*
              * show date picker
              * */
              variationWidget = ProductOptionsDateWidget(
                  optionDefaultValue: widget.options?[i].value ?? "",
                  selectedDate: (value) {
                    print(tag + "selected date is : ${value}");
                    productOptions["${widget.options?[i].productOptionId}"] =
                        value;
                    widget.productOptionsSelectedByUser!(productOptions);
                  });
              break;
            case "time":
              /*
              * show time picker
              * */
              variationWidget = ProductOptionsTimeWidget(
                  optionDefaultValue: widget.options?[i].value ?? "",
                  time: (value) {
                    print(tag + "selected value is : ${value}");
                    productOptions["${widget.options?[i].productOptionId}"] =
                        value;
                    widget.productOptionsSelectedByUser!(productOptions);
                  });
              break;
            case "datetime":
              /*
              * show date picker
              * */
              variationWidget = ProductOptionsDateWidget(
                  optionDefaultValue: widget.options?[i].value ?? "",
                  alsoShowTime: true,
                  selectedDate: (value) {
                    print(tag + "selected date  & Time is : ${value}");
                    productOptions["${widget.options?[i].productOptionId}"] =
                        value;
                    widget.productOptionsSelectedByUser!(productOptions);
                  });
              break;
            case "file":
              /*
              *File picker
              * */
              variationWidget =
                  ProductOptionsFileWidget(uploadedFileCode: (value) {
                print(tag + "uploaded file code is : ${value}");
                productOptions["${widget.options?[i].productOptionId}"] = value;
                widget.productOptionsSelectedByUser!(productOptions);
              });
              break;

            default:
              variationWidget = Container();
              break;
          }
          //Option name view
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetSpace(),
              if (widget.options?[i].required == "0") ...[
                Padding(
                  padding: const EdgeInsets.only(left: AppSizes.size6),
                  child: Text(
                    widget.options?[i].name ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.black),
                  ),
                ),
              ] else ...[
                //If any filed is required show star icon on it
                Padding(
                  padding: const EdgeInsets.only(left: AppSizes.size6),
                  child: RichText(
                    text: TextSpan(
                        text: widget.options?[i].name ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .color),
                        children: const [
                          TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: AppColors.black,
                              ))
                        ]),
                  ),
                ),
              ],
              widgetSpace(0, AppSizes.size10),
              variationWidget,
            ],
          );
        },
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: widget.options?.length,
      ),
    );
  }
}
