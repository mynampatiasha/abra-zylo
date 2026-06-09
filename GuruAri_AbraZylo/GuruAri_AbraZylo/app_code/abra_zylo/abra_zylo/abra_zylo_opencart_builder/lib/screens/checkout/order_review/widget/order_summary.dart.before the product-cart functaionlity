import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../common_widgets/image_view.dart';
import '../../../../common_widgets/title_separated_card.dart';
import '../../../../common_widgets/widget_space.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../models/checkout/checkout_review_order_model.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary(this.products, this.localizations, {Key? key})
      : super(key: key);

  final List<Products> products;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.size8),
          child: _cartItem(context, products[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: products.length,
    );
  }

  Widget _cartItem(BuildContext context, Products? product) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image and qty dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageView(
                  url: product?.image,
                  height: AppSizes.cartProductSize,
                  width: AppSizes.cartProductSize,
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),

            const SizedBox(width: AppSizes.size16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(product?.name ?? ""),
                  const SizedBox(height: AppSizes.size8),
                  Row(
                    children: [
                      Text((localizations?.translate(AppStringConstant.price) ??
                          "")),
                      Text(
                        product?.priceText ?? "0.00",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.size8),
                  Row(
                    children: [
                      Text((localizations?.translate(AppStringConstant.qty) ??
                              "") +
                          " "),
                      Text(
                        product?.quantity ?? "0.00",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.size8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text((localizations
                                  ?.translate(AppStringConstant.subtotal) ??
                              "") +
                          ": "),
                      Text(
                        product?.totalText ?? "0.00",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ],
        ),
        PositionedDirectional(
          child: Visibility(
            child: GestureDetector(
              child: const Icon(Icons.info),
              onTap: () {
                if (product?.option != null &&
                    product?.option?.isNotEmpty == true) {
                  openBottomSheetForProductOption(context, product?.option);
                }
              },
            ),
            visible:
                product?.option != null && product?.option?.isNotEmpty == true,
          ),
          bottom: 0,
          start: 0,
        )
      ],
    );
  }

  void openBottomSheetForProductOption(
      BuildContext context, List<Option>? option) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => TitleSeparatedCard(
        (localizations?.translate(AppStringConstant.details) ?? ""),
        ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return customOptionItem(option?[index].name ?? "",
                  option?[index].value ?? "", context);
            },
            separatorBuilder: (BuildContext context, int index) =>
                widgetSpace(1, AppSizes.size8),
            itemCount: option?.length ?? 0),
        showDivider: false,
        asCard: false,
      ),
    );
  }
}

Widget customOptionItem(String title, String price, BuildContext context) =>
    Padding(
      padding: const EdgeInsets.all(AppSizes.size4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Html(
              data: title,
              style: {
                "body": Style(
                  fontSize: FontSize(AppSizes.size12),
                  fontWeight: FontWeight.normal,
                ),
              },
            ),
          ),
          /* Text(title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: AppSizes.size12, fontWeight: FontWeight.normal)),*/
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
