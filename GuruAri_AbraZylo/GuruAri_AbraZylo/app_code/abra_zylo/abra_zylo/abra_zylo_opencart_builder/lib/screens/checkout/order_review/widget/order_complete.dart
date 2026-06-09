import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/helper/push_notifications_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../../../common_widgets/alert_message.dart';
import '../../../../common_widgets/app_bar.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';

class OrderComplete extends StatefulWidget {
  const OrderComplete(this.data, this.orderId, {Key? key}) : super(key: key);

  final String? data, orderId;

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomTabbarWidget()),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        appBar: commonAppBar(
          AppStringConstant.orderCompleted.localized(),
          context,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: AppSizes.deviceHeight / 1.4,
                child: Card(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _successWidget(context),
                          Padding(
                            padding: const EdgeInsets.all(AppSizes.size16),
                            child: Html(
                              data: widget.data
                                  ?.trim()
                                  .replaceAll(r"\\n", "")
                                  .replaceAll(r"\t", ""),
                              onAnchorTap: (link, _, ele) async {
                                if (link != null) {
                                  if (await canLaunch(link)) {
                                    launch(link);
                                  } else {
                                    AlertMessage.showWarning(
                                      "Error launching url",
                                      context,
                                    );
                                  }
                                } else {
                                  // ignore
                                }
                              },
                            ),
                          ),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSizes.size16),
                        child: SizedBox(
                          width: AppSizes.deviceWidth,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.size8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => BottomTabbarWidget(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              AppStringConstant.continueShopping.localized().toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: AppSizes.size16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _successWidget(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: AppSizes.size30),
            Image.asset(
              'assets/images/success.gif',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: AppSizes.size24),
            Text(
              "Order placed successfully!",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: AppSizes.size22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: AppSizes.size8),
            Text(
              "${AppStringConstant.yourOrderNumberIs.localized()} ${widget.orderId}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: AppSizes.size16, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            const SizedBox(height: AppSizes.size16),
            const Divider(),
          ],
        ),
      );
}
