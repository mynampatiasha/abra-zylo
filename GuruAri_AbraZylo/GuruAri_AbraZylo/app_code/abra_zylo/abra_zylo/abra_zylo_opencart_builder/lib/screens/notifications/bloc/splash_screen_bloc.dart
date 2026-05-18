import 'package:bloc/bloc.dart';
import 'package:oc_demo/screens/notifications/bloc/notification_screen_repository.dart';
import 'package:oc_demo/screens/notifications/bloc/notification_screen_state.dart';
import 'package:oc_demo/screens/notifications/bloc/splash_screen_event.dart';

class NotificationScreenBloc
    extends Bloc<NotificationScreenEvent, NotificationScreenState> {
  NotificationScreenRepository? repository;
  static const String Tag = "NotificationScreenBloc:- ";

  NotificationScreenBloc({this.repository})
      : super(NotificationScreenInitial()) {
    on<NotificationScreenEvent>(mapEventToState);
  }

  @override
  void mapEventToState(NotificationScreenEvent event,
      Emitter<NotificationScreenState> emit) async {
    if (event is NotificationEvent) {
      try {
        var model = await repository?.getNotificationFromDb();
        if (model != null && model.error != 1) {
          print(Tag + " success ");
          emit(NotificationScreenSuccess(model));
        }

        model = await repository?.getNotification(model?.eTag ?? "");
        if (model != null && model.error != 1) {
          print(Tag + " success ");
          emit(NotificationScreenSuccess(model));
        } else {
          print(Tag + " api login_signup Fail");
          emit(NotificationScreenError(''));
        }
      } catch (error, _) {
        print(Tag + " Exception " + error.toString());
        emit(NotificationScreenError(error.toString()));
      }
    }
  }
}
