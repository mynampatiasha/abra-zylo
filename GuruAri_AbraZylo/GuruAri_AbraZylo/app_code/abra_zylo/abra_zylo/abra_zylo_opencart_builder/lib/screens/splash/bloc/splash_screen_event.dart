import 'package:equatable/equatable.dart';

abstract class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object> get props => [];
}

class ApiLoginEvent extends SplashScreenEvent {
  const ApiLoginEvent();

  @override
  List<Object> get props => [];
}

class GetSplashScreen extends SplashScreenEvent {
  const GetSplashScreen();

  @override
  List<Object> get props => [];
}

class UpdateLanguageEvent extends SplashScreenEvent {
  UpdateLanguageEvent(this.code);

  String code;

  @override
  List<Object> get props => [];
}
