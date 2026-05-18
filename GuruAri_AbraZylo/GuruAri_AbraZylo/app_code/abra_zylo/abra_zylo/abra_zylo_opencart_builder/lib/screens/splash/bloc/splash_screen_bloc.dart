import 'package:bloc/bloc.dart';
import 'package:oc_demo/screens/splash/bloc/splash_screen_event.dart';
import 'package:oc_demo/screens/splash/bloc/splash_screen_repository.dart';
import 'package:oc_demo/screens/splash/bloc/splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenRepository? repository;
  static const String Tag = "SplashScreenBloc:- ";

  SplashScreenBloc({this.repository}) : super(SplashScreenInitial()) {
    on<SplashScreenEvent>(mapEventToState);
  }

  @override
  void mapEventToState(
      SplashScreenEvent event, Emitter<SplashScreenState> emit) async {
    if (event is ApiLoginEvent) {
      try {
        var model = await repository?.apiLogin();
        if (model != null && model.error != 1) {
          print(Tag + " success ");
          emit(ApiLoginSuccessState(model));
        } else {
          print(Tag + " api login_signup Fail");
          emit(SplashScreenError(''));
        }
      } catch (error, _) {
        print(Tag + " Exception " + error.toString());
        emit(SplashScreenError(error.toString()));
      }
    }
    if (event is UpdateLanguageEvent) {
      try {
        var model = await repository?.updateLanguage(event.code);
        if (model != null && model.error != 1) {
          print(Tag + " success ");
          emit(UpdateLanguageSuccess(model));
        } else {
          print(Tag + " api login_signup Fail");
          emit(SplashScreenError(''));
        }
      } catch (error, _) {
        print(Tag + " Exception " + error.toString());
        emit(SplashScreenError(error.toString()));
      }
    }
    if (event is GetSplashScreen) {
      emit(SplashScreenInitial());
      try {
        var model = await repository?.getSplashScreen();
        if (model != null && model.error != 1) {
          print(Tag + " success ");
          emit(SplashSuccessState(model));
        } else {
          print(Tag + " Splash login_signup Fail");
          emit(SplashScreenError(''));
        }
      } catch (error, _) {
        print(Tag + " Exception " + error.toString());
        emit(SplashScreenError(error.toString()));
      }
    }
  }
}
