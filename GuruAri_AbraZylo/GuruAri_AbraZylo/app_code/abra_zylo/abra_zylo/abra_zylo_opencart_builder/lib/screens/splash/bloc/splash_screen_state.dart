import 'package:equatable/equatable.dart';

import 'package:oc_demo/models/splash/splash_screen_model.dart';

import '../../../models/ApiLoginResponse/api_login_response.dart';
import '../../../models/base_model.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

class SplashScreenInitial extends SplashScreenState {}

class ApiLoginSuccessState extends SplashScreenState {
  ApiLoginSuccessState(this.apiLoginResponseModel);

  ApiLoginResponseModel apiLoginResponseModel;

  @override
  List<Object> get props => [];
}

class UpdateLanguageSuccess extends SplashScreenState {
  UpdateLanguageSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

class SplashSuccessState extends SplashScreenState {
  SplashSuccessState(this.splashScreenModel);

  SplashScreenModel splashScreenModel;

  @override
  List<Object> get props => [];
}

class SplashScreenError extends SplashScreenState {
  SplashScreenError(this._message);

  String? _message;
  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}

class EmptyState extends SplashScreenState {
  const EmptyState();
}
