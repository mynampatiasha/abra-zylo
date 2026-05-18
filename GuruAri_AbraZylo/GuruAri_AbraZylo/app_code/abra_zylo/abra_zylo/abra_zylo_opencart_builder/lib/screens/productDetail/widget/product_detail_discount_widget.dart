// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';

class ProductDiscountWidget extends StatefulWidget {
  List<Discount>? discountList;

  ProductDiscountWidget(this.discountList, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductDiscountWidgetState();
}

class _ProductDiscountWidgetState extends State<ProductDiscountWidget> {
  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(top: AppSizes.size8),
      child: ExpansionTile(
          initiallyExpanded: false,
          title: Text(
            _localizations?.translate(AppStringConstant.discount) ?? '',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: AppColors.darkGray),
          ),
          children: [
            const Divider(
              height: 0.5,
              thickness: 2,
              color: AppColors.dividerColor,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Table(children: [
                    productDiscountTableRowList(
                        widget.discountList![index].quantity!,
                        widget.discountList![index].price!)
                  ]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    widgetSpace(1, 8),
                itemCount: widget.discountList?.length ?? 0),
          ]),
    );
  }

  /*
  * Discount table view.
  * */
  TableRow productDiscountTableRowList(String title, String priceValue) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(AppSizes.size8),
        child: Text(
            "${title + " " + (_localizations?.translate(AppStringConstant.qty) ?? "")}",
            textAlign: TextAlign.start,
            softWrap: true,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            )),
      ),

      /*const Padding(
          padding: EdgeInsets.all(AppSizes.size8),
          child: Text(
            ":",
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          )),*/
      Padding(
          padding: const EdgeInsets.all(AppSizes.size8),
          child: Text(
            priceValue,
            textAlign: TextAlign.end,
            softWrap: true,
          )),
    ]);
  }
}
