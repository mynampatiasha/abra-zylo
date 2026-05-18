import 'package:flutter/material.dart';
import 'package:oc_demo/models/cart/cart_shipping_model.dart';

import '../../../common_widgets/common_tool_bar.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../bloc/cart_screen_bloc.dart';

class CartShippingMethodWidget extends StatefulWidget {
  CartShippingMethodWidget(this.shippingMethodList, this.bloc, {Key? key})
      : super(key: key);
  List<ShippingMethod>? shippingMethodList;
  CartScreenBloc? bloc;

  @override
  _CartShippingMethodWidgetState createState() =>
      _CartShippingMethodWidgetState();
}

class _CartShippingMethodWidgetState extends State<CartShippingMethodWidget> {
  AppLocalizations? _localizations;
  String? selectedMethodId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.deviceHeight / 2,
      child: Stack(children: [
        Scaffold(
            appBar: commonToolBar(
                _localizations?.translate(AppStringConstant.selectShipping) ??
                    "",
                context,
                isElevated: true),
            body: _buildRadio(0, widget.shippingMethodList))
      ]),
    );
  }

  Widget _buildRadio(int attributeId, List<ShippingMethod>? data) =>
      ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => buildShippingMethodList(
            widget.shippingMethodList?[index].title,
            widget.shippingMethodList?[index].quote),
        separatorBuilder: (BuildContext context, int index) =>
            widgetSpace(1, AppSizes.size8),
        itemCount: data?.length ?? 0,
      );

  Widget buildShippingMethodList(String? title, List<Quote>? quote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: AppSizes.size14, left: AppSizes.size12),
          child: Text((title ?? "").toUpperCase(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: AppSizes.size16, top: AppSizes.size8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                quote?.length ?? 0,
                (index) {
                  String optionString = quote?[index].title ?? "";
                  if (quote?[index].text != "") {
                    optionString += "  (" + (quote?[index].text!)! + ")";
                  }
                  return RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    selected: false,
                    title: Text(
                      optionString,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    activeColor: Colors.black,
                    value: quote?[index].title ?? "",
                    groupValue: (quote?[index].isSelected ?? false)
                        ? (quote?[index].title)
                        : "",
                    onChanged: (value) {
                      for (Quote d in quote!) {
                        d.isSelected = false;
                      }
                      quote[index].isSelected = true;
                      setState(() {
                        selectedMethodId = quote[index].code;
                        widget.bloc?.add(ApplyShippingEvent(selectedMethodId!));
                      });
                    },
                  );
                },
              )),
        ),
      ],
    );
  }
}
