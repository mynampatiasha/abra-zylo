import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';

import '../../../../constants/app_constants.dart';

class OptionsCheckBoxWidget extends StatefulWidget {
  OptionsCheckBoxWidget(
      {Key? key, this.variants, this.options, this.selectedOption})
      : super(key: key);
  List<ProductOptionValue>? variants;
  List<Option>? options;
  ValueChanged<List>? selectedOption = (test) {};

  @override
  _OptionsCheckBoxWidgetState createState() => _OptionsCheckBoxWidgetState();
}

class _OptionsCheckBoxWidgetState extends State<OptionsCheckBoxWidget> {
  var selectedCheckBoxes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCheckBox(widget.variants);
  }

  Widget _buildCheckBox(List<ProductOptionValue>? data) => Padding(
        padding: const EdgeInsets.only(
            top: AppSizes.size8, bottom: AppSizes.size8, left: 0),
        child: Container(
          /* padding:
      EdgeInsets.only(left: AppSizes.size10, right: AppSizes.size10),*/
          decoration: const BoxDecoration(
              border: Border.symmetric(
            horizontal: BorderSide(color: AppColors.dividerColor, width: 0.5),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              data?.length ?? 0,
              (index) {
                String optionString = data?[index].name ?? "";
                if (data?[index].price != "") {
                  optionString += "  (" +
                      (data?[index].pricePrefix ?? "") +
                      (data?[index].price ?? "") +
                      ")";
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      selected: data?[index].isSelected ?? false,
                      title: Text(
                        optionString,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .color),
                      ),
                      activeColor: Colors.black,
                      value: data?[index].isSelected ?? false,
                      onChanged: (value) {
                        /*
                        //Loop to make single checkbox selected at atime
                        for (ProductOptionValue d in data!) {
                          if(d.isSelected==true){
                          d.isSelected = false;}
                        }*/
                        if (data?[index].isSelected == true) {
                          data?[index].isSelected = false;
                          if (selectedCheckBoxes
                              .contains(data?[index].productOptionValueId)) {
                            selectedCheckBoxes
                                .remove(data?[index].productOptionValueId);
                          }
                        } else {
                          data?[index].isSelected = true;
                          if (!selectedCheckBoxes
                              .contains(data?[index].productOptionValueId)) {
                            selectedCheckBoxes
                                .add(data?[index].productOptionValueId);
                          }
                        }
                        setState(() {
                          widget.selectedOption!(selectedCheckBoxes);
                        });
                      },
                    ),
                    if (index < (data?.length ?? 1) - 1)
                      const Divider(
                        color: AppColors.dividerColor,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );
}
