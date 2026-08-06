import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class ProductDetailQuantityWidget extends StatefulWidget {
  int? counter;
  int? minimum;
  int? maximum;
  ValueChanged<int>? counterChangedValue;
  ProductDetailQuantityWidget(
      {this.counterChangedValue, this.counter, this.minimum, this.maximum});

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailQuantityWidgetState();
  }
}

class _ProductDetailQuantityWidgetState
    extends State<ProductDetailQuantityWidget> {
  TextEditingController controller = TextEditingController();
  ProductDetailBloc? bloc;
  AppLocalizations? _localizations;

  @override
  void initState() {
    controller.text =
        "${widget.minimum ?? widget.counter} ${AppStringConstant.unit.localized()}";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size16, vertical: AppSizes.size12),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (_localizations?.translate(AppStringConstant.quantity) ??
                        'Quantity *')
                    .isEmpty
                ? 'Quantity *'
                : (_localizations?.translate(AppStringConstant.quantity) ??
                    'Quantity *'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: SchedulerBinding.instance!.window.platformBrightness ==
                        Brightness.dark
                    ? AppColors.white
                    : AppColors.black),
          ),
          const SizedBox(height: 12),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /*
                    * Decrement quantity
                    * */
                InkWell(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(8)),
                  onTap: () {
                    if (widget.counter! > 1 &&
                        widget.counter! > widget.minimum!) {
                      widget.counter = (widget.counter ?? 1) - 1;
                      controller.text =
                          "${widget.counter} ${_localizations?.translate(AppStringConstant.unit) ?? 'Unit'}";
                      setState(() {
                        widget.counterChangedValue!(widget.counter!);
                      });
                    }
                  },
                  child: Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(Icons.remove,
                        size: 20, color: Colors.grey.shade800),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                /*
                    * quantity
                    * */
                Container(
                  width: 80,
                  alignment: Alignment.center,
                  child: Text(
                    controller.text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                /*
                    * Increment quantity
                    * */
                InkWell(
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(8)),
                  onTap: () {
                    if (widget.maximum != null &&
                        widget.counter != null &&
                        widget.counter! >= widget.maximum!) {
                      AlertMessage.showError(
                          "Out of stock, only ${widget.maximum} products available",
                          context);
                      return;
                    }
                    widget.counter = (widget.counter ?? 1) + 1;
                    controller.text =
                        "${widget.counter} ${_localizations?.translate(AppStringConstant.unit) ?? 'Unit'}";
                    setState(() {
                      widget.counterChangedValue!(widget.counter!);
                    });
                  },
                  child: Container(
                    width: 40,
                    alignment: Alignment.center,
                    child:
                        Icon(Icons.add, size: 20, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
