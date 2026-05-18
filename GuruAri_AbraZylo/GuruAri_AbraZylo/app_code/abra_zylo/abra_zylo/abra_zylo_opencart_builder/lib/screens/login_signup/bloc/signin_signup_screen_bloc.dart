import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';
import 'package:oc_demo/screens/login_signup/bloc/signin_signup_screen_repository.dart';

import '../../../models/base_model.dart';

part 'signin_signup_screen_event.dart';

part 'signin_signup_screen_state.dart';

class SigninSignupScreenBloc
    extends Bloc<SigninSignupScreenEvent, SigninSignupScreenState> {
  SigninSignupScreenRepository? repository;

  // Google Sign-In client
  // On web: clientId must be set explicitly
  // On Android/iOS: clientId must be null — it reads from google-services.json / GoogleService-Info.plist
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '847585068690-74je0ce1r9j6gijli99f5njhm736a555.apps.googleusercontent.com'
        : null,
    scopes: ['email', 'profile'],
  );

  SigninSignupScreenBloc({this.repository}) : super(SignupScreenInitial()) {
    on<SigninSignupScreenEvent>(mapEventToState);
  }

  void mapEventToState(
    SigninSignupScreenEvent event,
    Emitter<SigninSignupScreenState> emit,
  ) async {
    if (event is SignUpEvent) {
      try {
        var model = await repository?.addCustomer(
            event.wkToken,
            event.customer_group_id,
            event.firstnam,
            event.lastname,
            event.email,
            event.telephone,
            event.password,
            event.isSubscribe,
            event.agree,
            event.tobecomepartner,
            event.shoppartner,
            event.android_device_id);
        if (model != null) {
          if ((model.error ?? 0) >= 1) {
            emit(SigninSignupScreenError(model.message));
          } else {
            emit(SignupScreenFormSuccess(model));
            AppSharedPref.setLogin(true);
          }
        } else {
          emit(SigninSignupScreenError(""));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is GetRegisterDataEvent) {
      var model = await repository?.getRegisterPageData(event.wkToken);
      if (model != null) {
        if ((model.error ?? 0) >= 1) {
          SigninSignupScreenError(model.message);
        } else {
          emit(RegisterDataSuccess(model));
        }
      } else {
        emit(SigninSignupScreenError(""));
      }
    } else if (event is LoginEvent) {
      try {
        var model = await repository?.loginCustomer(
            event.wkToken, event.name, event.password, event.fcmToken);
        if (model != null) {
          if ((model.error ?? 0) >= 1) {
            emit(SigninSignupScreenError(model.message));
          } else {
            emit(LoginState(model));
            AppSharedPref.setLogin(true);
            AppSharedPref.setCustomerId(model.customerId);
          }
        } else {
          emit(SigninSignupScreenError(""));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is ForgotPasswordEvent) {
      try {
        var model =
            await repository?.forgotPassword(event.wkToken, event.email);
        if (model != null) {
          if (model.error == 0) {
            emit(ForgotPasswordState(model));
          } else {
            emit(SigninSignupScreenError(model.message));
          }
        } else {
          emit(SigninSignupScreenError(""));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is CheckEmailEvent) {
      try {
        var model = await repository?.checkEmail(event.wkToken, event.email);
        if (model != null) {
          if (model.error != 0) {
            emit(const CheckEmailStateError());
          } else {
            emit(const CheckEmailStateSuccess());
          }
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is GoogleSignInEvent) {
      emit(LoadingState());
      try {
        // Trigger the Google sign-in flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          emit(SigninSignupScreenError("Google sign-in cancelled."));
          await Future.delayed(const Duration(seconds: 2), () {
            emit(CompleteState());
          });
          return;
        }

        final String googleId = googleUser.id;
        final String email = googleUser.email;
        final String displayName = googleUser.displayName ?? '';
        final List<String> nameParts = displayName.split(' ');
        final String firstname = nameParts.isNotEmpty ? nameParts.first : email.split('@').first;
        final String lastname = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        final model = await repository?.googleSignIn(
          event.wkToken, googleId, email, firstname, lastname, event.fcmToken,
        );

        if (model != null) {
          if ((model.error ?? 0) >= 1) {
            emit(SigninSignupScreenError(model.message));
          } else {
            emit(LoginState(model));
            AppSharedPref.setLogin(true);
            AppSharedPref.setCustomerId(model.customerId);
          }
        } else {
          emit(SigninSignupScreenError("Google sign-in failed. Please try again."));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is GoogleSignInWebEvent) {
      // Web: account already obtained from renderButton callback
      emit(LoadingState());
      try {
        final googleUser = event.user;
        final String googleId = googleUser.id;
        final String email = googleUser.email;
        final String displayName = googleUser.displayName ?? '';
        final List<String> nameParts = displayName.split(' ');
        final String firstname = nameParts.isNotEmpty ? nameParts.first : email.split('@').first;
        final String lastname = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        final model = await repository?.googleSignIn(
          event.wkToken, googleId, email, firstname, lastname, event.fcmToken,
        );

        if (model != null) {
          if ((model.error ?? 0) >= 1) {
            emit(SigninSignupScreenError(model.message));
          } else {
            emit(LoginState(model));
            AppSharedPref.setLogin(true);
            AppSharedPref.setCustomerId(model.customerId);
          }
        } else {
          emit(SigninSignupScreenError("Google sign-in failed. Please try again."));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    }
  }
}
