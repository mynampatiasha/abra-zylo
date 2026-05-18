import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../../../common_widgets/alert_message.dart';
import '../../../../common_widgets/app_bar.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';

class OtherNotificationWidget extends StatefulWidget {
  const OtherNotificationWidget(this.title, this.description, {Key? key})
      : super(key: key);

  final String? title;
  final String? description;

  @override
  State<OtherNotificationWidget> createState() =>
      _OtherNotificationWidgetState();
}

class _OtherNotificationWidgetState extends State<OtherNotificationWidget> {
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppBar(
          AppStringConstant.otherNotification.localized(),
          context,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: AppSizes.size8,
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: AppSizes.size8, right: AppSizes.size8),
                child: Text(widget.title ?? "",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: AppSizes.size18,
                        ))),
            //_successWidget(context),
            Padding(
              padding: const EdgeInsets.all(AppSizes.size16),
              child: Html(
                data: widget.description
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
      ),
    );
  }
}
