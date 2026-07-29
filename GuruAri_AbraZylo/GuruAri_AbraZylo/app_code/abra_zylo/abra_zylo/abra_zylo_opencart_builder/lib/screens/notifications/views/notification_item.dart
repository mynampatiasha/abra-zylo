import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/models/notification/notification_screen_model.dart';
import 'package:oc_demo/screens/notifications/views/other_notifications_widget.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/arguments_map.dart';
import '../../../constants/global_data.dart';

class NotificationItem extends StatefulWidget {
  NotificationItem(this.data, this.callback, {Key? key}) : super(key: key);
  Notifications? data;
  Function(int, bool)? callback;

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool isRead = false;

  @override
  void initState() {
    //isRead = widget.data?.isRead ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.data?.type == "Custom") {
          Navigator.of(context).pushNamed(
            AppRoute.catalog,
            arguments: categoryMap(widget.data?.id ?? "",
                widget.data?.title ?? "", GlobalData.custom_collection),
          );
        } else if (widget.data?.type == "category") {
          Navigator.of(context).pushNamed(
            AppRoute.catalog,
            arguments: categoryMap(
                widget.data?.id ?? "", widget.data?.title ?? "", ""),
          );
        } else if (widget.data?.type == "other") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => OtherNotificationWidget(
                    widget.data?.title ?? "", widget.data?.content ?? "")),
          );
        } else {
          Navigator.of(context).pushNamed(AppRoute.productPage,
              arguments: getProductDataAttributeMap(
                widget.data?.title ?? "",
                widget.data?.id ?? "",
              ));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Purple notification icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF673AB7).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      color: Color(0xFF673AB7),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title + content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data?.title ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  const Icon(Icons.chevron_right, color: Color(0xFF673AB7), size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
