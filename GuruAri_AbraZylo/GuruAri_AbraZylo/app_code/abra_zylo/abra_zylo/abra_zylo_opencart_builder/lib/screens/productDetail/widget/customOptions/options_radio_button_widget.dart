import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';

class OptionsRadioButtonView extends StatefulWidget {
  OptionsRadioButtonView({Key? key, this.optionsValueList, this.selectedOption})
      : super(key: key);
  List<ProductOptionValue>? optionsValueList;
  ValueChanged<String>? selectedOption = (test) {};

  @override
  _OptionsRadioButtonViewState createState() => _OptionsRadioButtonViewState();
}

class _OptionsRadioButtonViewState extends State<OptionsRadioButtonView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRadio(0, widget.optionsValueList);
  }

  Widget _buildRadio(int attributeId, List<ProductOptionValue>? data) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.size8, horizontal: AppSizes.size8),
        child: SizedBox(
          width: AppSizes.deviceWidth,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              data?.length ?? 0,
              (index) {
                String optionString = data?[index].name ?? "";
                if (data?[index].price != "") {
                  optionString += " (" +
                      (data?[index].pricePrefix ?? "") +
                      (data?[index].price ?? "") +
                      ")";
                }
                
                bool isSelected = data?[index].isSelected ?? false;

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
                      for (ProductOptionValue d in data!) {
                        d.isSelected = false;
                      }
                      data[index].isSelected = true;
                      setState(() {
                        widget.selectedOption!(
                            data[index].productOptionValueId as String);
                      });
                    }
                  },
                );
              },
            ),
          ),
        ),
      );
}
