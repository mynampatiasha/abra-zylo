import 'package:flutter/material.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class PriceDetails extends StatelessWidget {
  const PriceDetails({
    this.totals,
    super.key,
    this.localizations,
  });

  final List<Totals>? totals;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: AppSizes.size4, right: AppSizes.size4),
      child: Container(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.only(top: AppSizes.size8),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(

              //backgroundColor: AppColors.background,
              backgroundColor: Theme.of(context).cardColor,
              initiallyExpanded: true,
              title: Row(
                children: [
                  Icon(Icons.money, color: Theme.of(context).iconTheme.color),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      localizations
                              ?.translate(AppStringConstant.priceDetails)
                              .toUpperCase() ??
                          '',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontSize: AppSizes.size14,
                          fontWeight: FontWeight.w600

                          // Theme.of(context)
                          //     .textTheme
                          //     .titleLarge
                          //     ?.copyWith(color: AppColors.black

                          )),
                ],
              ),
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border: Border.symmetric(
                    horizontal:
                        BorderSide(color: AppColors.lightGray, width: 0.5),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.size10,
                        right: AppSizes.size10,
                        bottom: AppSizes.size10),
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (_, index) {
                          return _priceItem(totals?[index].title ?? "",
                              totals?[index].text ?? "", context);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            widgetSpace(1, AppSizes.size10),
                        itemCount: totals?.length ?? 0),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _priceItem(String title, String price, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(AppSizes.size4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: AppSizes.size12,
                    fontWeight: FontWeight.normal,
                    color: AppColors.darkGray)),
            Text(price,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: AppSizes.size14,
                    fontWeight: FontWeight.w500)
                // TextStyle(
                //     fontWeight: FontWeight.w700,
                //     color: Theme.of(context).textTheme.headlineMedium!.color),
                )
          ],
        ),
      );
}
