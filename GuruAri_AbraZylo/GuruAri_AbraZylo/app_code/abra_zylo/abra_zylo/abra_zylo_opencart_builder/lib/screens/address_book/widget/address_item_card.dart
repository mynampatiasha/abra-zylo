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
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFece7f3), width: 1.5),
        ),
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
                              fontFamily: 'Karla',
                              fontSize: FontSize(14.0),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8f889c)) // ink-soft
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
              color: Color(0xFFece7f3),
              thickness: 1.0,
              height: 1.0,
            ),
            if (actions != null) actions!,
          ],
        ),
      ),
    );
  }
}
