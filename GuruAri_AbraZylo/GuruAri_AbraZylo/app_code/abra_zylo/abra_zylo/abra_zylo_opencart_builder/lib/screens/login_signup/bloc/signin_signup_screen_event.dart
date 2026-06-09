part of 'signin_signup_screen_bloc.dart';

abstract class SigninSignupScreenEvent extends Equatable {
  const SigninSignupScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends SigninSignupScreenEvent {
  const LoadingEvent();
}

class ForgotPasswordEvent extends SigninSignupScreenEvent {
  const ForgotPasswordEvent(this.email, this.wkToken);

  final String email;
  final String wkToken;

  @override
  List<Object> get props => [email, wkToken];
}

class CheckEmailEvent extends SigninSignupScreenEvent {
  const CheckEmailEvent(this.email, this.wkToken);

  final String email;
  final String wkToken;

  @override
  List<Object> get props => [email, wkToken];
}

class LoginEvent extends SigninSignupScreenEvent {
  const LoginEvent(this.name, this.password, this.fcmToken, this.wkToken);

  final String name;
  final String password;
  final String wkToken;
  final String fcmToken;

  @override
  List<Object> get props => [name, password, fcmToken, wkToken];
}

class SignUpEvent extends SigninSignupScreenEvent {
  SignUpEvent(
      this.wkToken,
      this.customer_group_id,
      this.firstnam,
      this.lastname,
      this.email,
      this.telephone,
      this.password,
      this.isSubscribe,
      this.agree,
      this.tobecomepartner,
      this.shoppartner,
      this.android_device_id);

  String wkToken;
  String customer_group_id;
  String firstnam;
  String lastname;
  String email;
  String telephone;
  String password;
  String isSubscribe;
  String agree;
  String tobecomepartner;
  String shoppartner;
  String android_device_id;

  @override
  List<Object> get props => [
        wkToken,
        customer_group_id,
        firstnam,
        lastname,
        email,
        telephone,
        password,
        isSubscribe,
        agree,
        tobecomepartner,
        shoppartner,
        android_device_id
      ];
}

class GetRegisterDataEvent extends SigninSignupScreenEvent {
  const GetRegisterDataEvent(this.wkToken);

  final String wkToken;

  @override
  List<Object> get props => [wkToken];
}

class GoogleSignInEvent extends SigninSignupScreenEvent {
  const GoogleSignInEvent(this.wkToken, this.fcmToken);

  final String wkToken;
  final String fcmToken;

  @override
  List<Object> get props => [wkToken, fcmToken];
}

/// Used on web — commented out (google_sign_in disabled)
// class GoogleSignInWebEvent extends SigninSignupScreenEvent {
//   const GoogleSignInWebEvent(this.user, this.wkToken, this.fcmToken);
//
//   final GoogleSignInAccount user;
//   final String wkToken;
//   final String fcmToken;
//
//   @override
//   List<Object> get props => [wkToken, fcmToken];
// }

class GoogleSignInWebEvent extends SigninSignupScreenEvent {
  const GoogleSignInWebEvent(this.user, this.wkToken, this.fcmToken);

  final GoogleSignInAccount user;
  final String wkToken;
  final String fcmToken;

  @override
  List<Object> get props => [wkToken, fcmToken];
}

