// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';

class ProductDetailsFeatureWidget extends StatefulWidget {
  List<AttributeGroup>? attributeGroup;

  ProductDetailsFeatureWidget(this.attributeGroup, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductDetailsFeatureWidgetState();
}

class _ProductDetailsFeatureWidgetState
    extends State<ProductDetailsFeatureWidget> {
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            initiallyExpanded: false,
            //Title Feature
            title: Text(
                _localizations?.translate(AppStringConstant.feature) ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.darkGray)),
            //List view Of features
            children: [
              const Divider(
                height: 0.5,
                color: AppColors.darkGray,
              ),
              widgetSpace(),
              ListView.builder(
                itemBuilder: (context, index) {
                  return FeatureView(widget.attributeGroup?[index].name ?? "",
                      widget.attributeGroup?[index].attribute ?? []);
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.attributeGroup?.length,
              )
            ]),
      ),
    );
  }

/*
* Feature view
* */
  Widget FeatureView(String attributeGroupName, List<Attribute> attributeList) {
    return Padding(
      padding:
          const EdgeInsets.only(right: AppSizes.size8, left: AppSizes.size16),
      child: Column(
        children: [
          //Feature heading
          Align(
            alignment: Alignment.topLeft,
            child: Text(attributeGroupName,
                style: Theme.of(context).textTheme.headlineSmall),
          ),

          widgetSpace(),
          //Feature description or sub options view
          ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Table(children: [
                  productFeatureTableRowList(
                      attributeList[index].name!, attributeList[index].text!)
                ]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  widgetSpace(1, 8),
              itemCount: attributeList.length),
        ],
      ),
    );
  }

/*
* Feature description rows
*
* */
  TableRow productFeatureTableRowList(String title, String priceValue) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(top: AppSizes.size10),
        child: Text(
          title,
          textAlign: TextAlign.start,
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color),
        ),
      ),
      /*,
      const Padding(
          padding: EdgeInsets.all(AppSizes.linePadding),
          child: Text(
            ":",
            textAlign: TextAlign.start,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          )),*/
      Padding(
          padding: const EdgeInsets.all(AppSizes.size8),
          child: Text(
            priceValue,
            textAlign: TextAlign.end,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.headlineMedium!.color),
            softWrap: true,
          )),
    ]);
  }
}
