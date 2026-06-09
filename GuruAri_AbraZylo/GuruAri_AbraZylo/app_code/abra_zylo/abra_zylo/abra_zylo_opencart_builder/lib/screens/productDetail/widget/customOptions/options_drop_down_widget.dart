import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';

import '../../../../common_widgets/common_text_field.dart';
import '../../../../constants/app_constants.dart';

class OptionsDropDownWidget extends StatefulWidget {
  OptionsDropDownWidget({Key? key, this.variants, this.selectedOption})
      : super(key: key);
  List<ProductOptionValue>? variants;
  ValueChanged<String>? selectedOption = (test) {};
  @override
  _OptionsDropDownWidgetState createState() => _OptionsDropDownWidgetState();
}

class _OptionsDropDownWidgetState extends State<OptionsDropDownWidget> {
  String selectedVariant = AppStringConstant.select.localized();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: SizedBox(
        width: AppSizes.deviceWidth,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: (widget.variants ?? []).map((ProductOptionValue value) {
            String optionString = value.name ?? "";
            if (value.price != "") {
              optionString += " (" + (value.pricePrefix ?? "") + (value.price ?? "") + ")";
            }
            bool isSelected = selectedVariant == optionString;

            return ChoiceChip(
              label: Text(
                optionString,
                style: TextStyle(
                  color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    selectedVariant = optionString;
                    widget.selectedOption!(value.productOptionValueId as String);
                  });
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
