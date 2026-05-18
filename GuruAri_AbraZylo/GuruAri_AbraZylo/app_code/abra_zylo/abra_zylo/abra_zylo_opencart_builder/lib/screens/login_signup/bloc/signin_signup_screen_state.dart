part of 'signin_signup_screen_bloc.dart';

abstract class SigninSignupScreenState extends Equatable {
  const SigninSignupScreenState();

  @override
  List<Object> get props => [];
}

class LoadingState extends SigninSignupScreenState {}

class SignupScreenInitial extends SigninSignupScreenState {}

class SignupScreenFormSuccess extends SigninSignupScreenState {
  SignupScreenFormSuccess(this.data);

  LoginModel data;

  @override
  List<Object> get props => [data];
}

class RegisterDataSuccess extends SigninSignupScreenState {
  RegisterAccountModel? model;

  RegisterDataSuccess(this.model);

  @override
  List<Object> get props => [];
}

class ForgotPasswordState extends SigninSignupScreenState {
  const ForgotPasswordState(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

class CheckEmailStateSuccess extends SigninSignupScreenState {
  const CheckEmailStateSuccess();
}

class CheckEmailStateError extends SigninSignupScreenState {
  const CheckEmailStateError();
}

class LoginState extends SigninSignupScreenState {
  LoginState(this.data);

  LoginModel data;

  @override
  List<Object> get props => [data];
}

// ignore: must_be_immutable
class SigninSignupScreenError extends SigninSignupScreenState {
  SigninSignupScreenError(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}

class CompleteState extends SigninSignupScreenState {}
