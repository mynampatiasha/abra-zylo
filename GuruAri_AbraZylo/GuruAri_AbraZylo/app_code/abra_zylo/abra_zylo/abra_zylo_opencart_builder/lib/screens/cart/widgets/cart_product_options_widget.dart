import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oc_demo/models/cart/cart_model.dart';

import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class CartProductOptionWidget extends StatelessWidget {
  const CartProductOptionWidget({
    this.options,
    Key? key,
    this.localizations,
  }) : super(key: key);

  final List<Option>? options;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ExpansionTile(
          initiallyExpanded: false,
          title: Text(localizations?.translate(AppStringConstant.options) ?? '',
              style: Theme.of(context).textTheme.titleLarge),
          children: [
            ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Table(children: [
                    optionTableRowList(options?[index].name ?? "",
                        options?[index].value ?? "", context)
                  ]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    widgetSpace(1, AppSizes.size2),
                itemCount: options?.length ?? 0),
          ]),
    );
  }

  /*
  * Method will return option row
  * */
  TableRow optionTableRowList(
      String optionName, String optionValue, BuildContext context) {
    return TableRow(children: [
      Text(
        optionName,
        textAlign: TextAlign.start,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      const Center(
        child: Text(
          ":",
          textAlign: TextAlign.start,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Text(
        optionValue,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    ]);
  }
}
