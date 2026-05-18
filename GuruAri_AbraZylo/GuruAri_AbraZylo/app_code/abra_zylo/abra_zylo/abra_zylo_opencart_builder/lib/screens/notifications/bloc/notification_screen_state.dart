import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/notification/notification_screen_model.dart';

import '../../../models/ApiLoginResponse/api_login_response.dart';

abstract class NotificationScreenState extends Equatable {
  const NotificationScreenState();

  @override
  List<Object> get props => [];
}

class NotificationScreenInitial extends NotificationScreenState {}

class NotificationScreenSuccess extends NotificationScreenState {
  NotificationScreenSuccess(this.notificationScreenModel);

  NotificationScreenModel notificationScreenModel;

  @override
  List<Object> get props => [];
}

class NotificationScreenError extends NotificationScreenState {
  NotificationScreenError(this._message);

  String? _message;
  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}
