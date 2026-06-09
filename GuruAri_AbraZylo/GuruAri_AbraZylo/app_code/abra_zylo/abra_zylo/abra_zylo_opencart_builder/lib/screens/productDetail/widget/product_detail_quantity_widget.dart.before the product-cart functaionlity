import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';

import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class ProductDetailQuantityWidget extends StatefulWidget {
  int? counter;
  int? minimum;
  ValueChanged<int>? counterChangedValue;
  ProductDetailQuantityWidget(
      {this.counterChangedValue, this.counter, this.minimum});

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
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSizes.size8),
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizations?.translate(AppStringConstant.quantity) ?? '',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: SchedulerBinding.instance!.window.platformBrightness ==
                        Brightness.dark
                    ? AppColors.white
                    : AppColors.black),
          ),
          const SizedBox(
            height: AppSizes.size8,
          ),
          const Divider(),
          SizedBox(
            height: AppSizes.deviceWidth / 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /*
                * Decrement quantity
                * */
                Container(
                  width: AppSizes.deviceWidth / 6,
                  color: Colors.black,
                  child: InkWell(
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
                      child: const Icon(Icons.remove,
                          size: 30, color: AppColors.white)),
                ),
                const Spacer(),
                /*
                * quantity
                * */
                SizedBox(
                    width: AppSizes.deviceWidth / 6,
                    child: TextField(
                      enabled: false,
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    )),
                const Spacer(),
                /*
                * Increment quantity
                * */
                Container(
                  width: AppSizes.deviceWidth / 6,
                  color: Colors.black,
                  child: InkWell(
                      onTap: () {
                        widget.counter = (widget.counter ?? 1) + 1;
                        controller.text =
                            "${widget.counter} ${_localizations?.translate(AppStringConstant.unit) ?? 'Unit'}";
                        setState(() {
                          widget.counterChangedValue!(widget.counter!);
                        });
                      },
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: AppColors.white,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
