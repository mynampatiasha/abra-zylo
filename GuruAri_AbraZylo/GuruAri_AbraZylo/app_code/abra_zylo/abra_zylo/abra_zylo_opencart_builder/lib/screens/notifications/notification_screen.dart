import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/notification/notification_screen_model.dart';
import 'package:oc_demo/screens/notifications/bloc/notification_screen_state.dart';
import 'package:oc_demo/screens/notifications/bloc/splash_screen_bloc.dart';
import 'package:oc_demo/screens/notifications/bloc/splash_screen_event.dart';
import 'package:oc_demo/screens/notifications/views/notification_item.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  NotificationScreenBloc? _notificationBloc;
  AppLocalizations? _localizations;
  NotificationScreenModel? data;
  //NotificationList? readNotification;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _notificationBloc = context.read<NotificationScreenBloc>();
    _notificationBloc?.add(const NotificationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationScreenBloc, NotificationScreenState>(
        builder: (context, currentState) {
      if (currentState is NotificationScreenInitial) {
        isLoading = true;
      } else if (currentState is NotificationScreenSuccess) {
        isLoading = false;
        data = currentState.notificationScreenModel;
      } else if (currentState is NotificationScreenError) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message ?? "", context);
        });
      }

      return _buildUI();
    });
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Scaffold(
          appBar: commonToolBar(
              _localizations?.translate(AppStringConstant.notifications) ?? '',
              context,
              isLeadingEnable: true,
              isElevated: true),
          body: (data != null)
              ? (data?.notifications?.isNotEmpty ?? false)
                  ? ListView.builder(
                      itemCount: data?.notifications?.length ?? 0,
                      itemBuilder: (context, index) => NotificationItem(
                              data?.notifications?[index], (id, isRead) {
                            // _notificationBloc?.add(NotificationReadEvent(id , isRead));
                          }))
                  : emptyNotification()
              : Container(),
        ),
        Visibility(visible: isLoading, child: Loader())
      ],
    );
  }

  Widget emptyNotification() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.notifications,
            size: 160,
          ),
          Text(
            _localizations?.translate(AppStringConstant.emptyNotification) ??
                '',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
