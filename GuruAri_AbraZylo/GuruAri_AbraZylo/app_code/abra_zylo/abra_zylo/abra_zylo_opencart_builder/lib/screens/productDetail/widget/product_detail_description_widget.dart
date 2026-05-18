import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class ProductDetailsDescriptionWidget extends StatefulWidget {
  String? description;

  ProductDetailsDescriptionWidget(this.description, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ProductDetailsDescriptionWidgetState();
}

class _ProductDetailsDescriptionWidgetState
    extends State<ProductDetailsDescriptionWidget> {
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
            iconColor: Theme.of(context).textTheme.headlineMedium!.color,
            collapsedIconColor:
                Theme.of(context).textTheme.headlineMedium!.color,
            title: Text(
                _localizations?.translate(AppStringConstant.details) ?? '',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).textTheme.headlineMedium!.color,
                    )),
            children: [
              Container(
                  padding: const EdgeInsets.all(AppSizes.size8),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Html(
                        data: widget.description ?? '',
                        style: {
                          "*": Style(
                              fontSize: FontSize(15.0),
                              // width:MediaQuery.of(context).size.w,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .color),
                        },
                      )
                    ],
                  )),
            ]),
      ),
    );
  }
}
