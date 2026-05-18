import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/constants/app_constants.dart';

class AddressItemCard extends StatelessWidget {
  const AddressItemCard({
    required this.address,
    this.onTap,
    this.actions,
    Key? key,
  }) : super(key: key);

  final String address;
  final Widget? actions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.only(top: AppSizes.size8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSizes.size8),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Html(
                        data: address,
                        style: {
                          "body": Style(
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.color)
                        },
                      ),
                    ),
                    // Text(address),
                    /*if (onTap != null)
                      const Icon(
                        Icons.navigate_next,
                        color: AppColors.lightGray,
                      )*/
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 0.5,
              height: 0.5,
            ),
            if (actions != null) actions!,
          ],
        ),
      ),
    );
  }
}
