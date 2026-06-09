import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';
import 'package:oc_demo/screens/login_signup/bloc/signin_signup_screen_repository.dart';
import 'package:oc_demo/screens/login_signup/bloc/signin_signup_screen_repository.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

import '../../../models/base_model.dart';

part 'signin_signup_screen_event.dart';

part 'signin_signup_screen_state.dart';

class SigninSignupScreenBloc
    extends Bloc<SigninSignupScreenEvent, SigninSignupScreenState> {
  SigninSignupScreenRepository? repository;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '960143902854-ct0jco0ntkrriu82fvl6m1m83nr8jag4.apps.googleusercontent.com'
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
            try {
              FacebookAppEvents().logEvent(name: "complete_registration");
            } catch (e) {}
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
            AppSharedPref.setCustomerId(model.customerId.toString());
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
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser != null) {
          String email = googleUser.email;
          String id = googleUser.id;
          String displayName = googleUser.displayName ?? '';
          
          List<String> names = displayName.split(' ');
          String firstname = names.isNotEmpty ? names.first : 'User';
          String lastname = names.length > 1 ? names.sublist(1).join(' ') : '';

          var model = await repository?.googleSignIn(
              event.wkToken, id, email, firstname, lastname, event.fcmToken);
              
          if (model != null) {
            if ((model.error ?? 0) >= 1) {
              emit(SigninSignupScreenError(model.message?.toString()));
            } else {
              emit(LoginState(model));
              AppSharedPref.setLogin(true);
              AppSharedPref.setCustomerId(model.customerId.toString());
            }
          } else {
            emit(SigninSignupScreenError("Failed to sign in with Google."));
          }
        } else {
          emit(SigninSignupScreenError("Google sign-in was canceled."));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 2), () {
        emit(CompleteState());
      });
    } else if (event is GoogleSignInWebEvent) {
      try {
        final GoogleSignInAccount googleUser = event.user;
        String email = googleUser.email;
        String id = googleUser.id;
        String displayName = googleUser.displayName ?? '';
        
        List<String> names = displayName.split(' ');
        String firstname = names.isNotEmpty ? names.first : 'User';
        String lastname = names.length > 1 ? names.sublist(1).join(' ') : '';

        var model = await repository?.googleSignIn(
            event.wkToken, id, email, firstname, lastname, event.fcmToken);
            
        if (model != null) {
          if ((model.error ?? 0) >= 1) {
            emit(SigninSignupScreenError(model.message?.toString()));
          } else {
            emit(LoginState(model));
            AppSharedPref.setLogin(true);
            AppSharedPref.setCustomerId(model.customerId.toString());
          }
        } else {
          emit(SigninSignupScreenError("Failed to sign in with Google on Web."));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 2), () {
        emit(CompleteState());
      });
    }
  }
}
