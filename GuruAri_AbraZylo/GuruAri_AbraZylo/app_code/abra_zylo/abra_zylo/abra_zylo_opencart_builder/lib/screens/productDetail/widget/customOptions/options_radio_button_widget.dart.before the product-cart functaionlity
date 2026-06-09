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
        padding:
            const EdgeInsets.only(top: AppSizes.size8, bottom: AppSizes.size8),
        child: Container(
          /*  padding:
              EdgeInsets.only(left: AppSizes.size10, right: AppSizes.size10),*/
          decoration: const BoxDecoration(
              border: Border.symmetric(
            horizontal: BorderSide(color: AppColors.dividerColor, width: 0.5),
          )),
          child: Column(
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
                  children: [
                    //Divider(color: AppColors.red,),
                    RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      selected: false,
                      title: Text(
                        optionString,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .color),
                      ),
                      activeColor:
                          Theme.of(context).textTheme.headlineMedium!.color,
                      value: data?[index].name ?? "",
                      groupValue: (data?[index].isSelected ?? false)
                          ? (data?[index].name)
                          : "",
                      onChanged: (value) {
                        for (ProductOptionValue d in data!) {
                          d.isSelected = false;
                        }
                        data[index].isSelected = true;
                        setState(() {
                          widget.selectedOption!(
                              data[index].productOptionValueId as String);
                        });
                      },
                    ),
                    if (index < (data?.length ?? 1) - 1)
                      Divider(
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
