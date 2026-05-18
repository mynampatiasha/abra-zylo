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
    return Container(
        margin: const EdgeInsets.all(AppSizes.size8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.0),
          color: AppColors.white,
          boxShadow: const [
            BoxShadow(
              color: AppColors.lightGray,
              blurRadius: 1.0,
            )
          ],
        ),
        child: GestureDetector(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(AppSizes.size16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Text(
                            widget.data?.title ?? "",
                            style: Theme.of(context).textTheme.labelLarge,
                          )),
                          const SizedBox(
                            height: AppSizes.size8 / 2,
                          ),
                          Flexible(
                              child: Text(widget.data?.content ?? "",
                                  style:
                                      Theme.of(context).textTheme.bodySmall)),
                        ],
                      ),
                    ),
                    /*GestureDetector(
                    onTap: (){
                      */ /*if(widget.data?.isRead ?? false){

                      }*/ /*
                    */ /*  lese*/ /**/ /**/ /* {
                        setState(() {
                          //.data?.isRead = true;
                        });
                      */ /*  widget.callback!(
                            widget.data?.id ?? 0, widget.data?.isRead ?? false);*/ /*
                      }
                    },
                 */ /*   child: Icon(Icons.notifications,
                      color: (widget.data?.isRead ?? false) ? AppColors.blue : AppColors.lightGray,),*/ /*
                  )*/
                  ],
                ),
              ),
              SizedBox(
                width: AppSizes.deviceWidth,
                child: ImageView(
                  url: widget.data?.image ?? '',
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ));
  }
}
