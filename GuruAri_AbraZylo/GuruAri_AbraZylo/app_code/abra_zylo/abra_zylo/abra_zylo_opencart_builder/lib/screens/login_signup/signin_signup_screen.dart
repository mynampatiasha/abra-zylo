// ignore_for_file: prefer_const_constructors

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/common_outlined_button.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/open_bottom_model_sheet_helper.dart';
import '../login_signup/bloc/signin_signup_screen_bloc.dart';
import 'view/google_sign_in_web_button.dart';

class SignInSignUpScreen extends StatefulWidget {
  Map<String, dynamic> arguments;
  SignInSignUpScreen(this.arguments, {Key? key}) : super(key: key);

  @override
  _SignInSignUpScreenState createState() => _SignInSignUpScreenState();
}

class _SignInSignUpScreenState extends State<SignInSignUpScreen> {
  bool isFromCartForLogin = false;
  bool isFromCartForSignup = false;
  AppLocalizations? _localizations;
  SigninSignupScreenBloc? bloc;
  late bool _loading;

  @override
  void initState() {
    isFromCartForLogin = widget.arguments["isFromCartForLogin"];
    isFromCartForSignup = widget.arguments["isFromCartForSignup"];
    bloc = context.read<SigninSignupScreenBloc>();
    _loading = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninSignupScreenBloc, SigninSignupScreenState>(
        builder: (context, state) {
      print(state);
      if (state is LoadingState) {
        _loading = true;
      } else if (state is SigninSignupScreenError) {
        _loading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(state.message ?? "", context);
        });
      }
      else if (state is LoginState) {
        _loading = false;
        var model = state.data;
        AppSharedPref.setLoginUserData(model);
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showSuccess(
              (model.firstname?.isNotEmpty ?? false)
                  ? "Welcome back, ${model.firstname}! Thanks for signing in."
                  : "Welcome back! Thanks for signing in.",
              context);
          if (widget.arguments["isFromProductDetailForLogin"] == true) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoute.bottomTabBAr, (route) => false);
          }
        });
      } else if (state is SignupScreenFormSuccess) {
        _loading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showSuccess(state.data.message ?? "", context);
          if (widget.arguments["isFromProductDetailForLogin"] == true) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoute.bottomTabBAr, (route) => false);
          }
        });
      }

      return Stack(
        children: <Widget>[
          _buildUI(),
          Visibility(
            child: Loader(),
            visible: _loading,
          ),
        ],
      );
    });
  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: const Color(0xFFf4f0fb),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFefe6ff), Color(0xFFf4f0fb), Color(0xFFe8fbf3)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                color: const Color(0xFFc8abec),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_back_ios_new, size: 19, color: Color(0xFF5232a8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _localizations?.translate(AppStringConstant.signInRegister) ?? "Sign in or register",
                      style: const TextStyle(
                        fontFamily: 'Baloo 2',
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Color(0xFF5232a8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(26),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 180, // Approximate height minus appbar to center content if possible
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                _localizations?.translate(AppConstant.isMarketPlace
                                    ? AppStringConstant.appNameMarketplace
                                    : AppStringConstant.appNameBuilder) ?? "Abra Zylo",
                                style: const TextStyle(
                                  fontFamily: 'Baloo 2',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                  color: Color(0xFF2b2540),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            (_localizations?.translate(AppStringConstant.signInRegister) ?? "SIGN IN OR REGISTER").toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5,
                              letterSpacing: 1.1,
                              color: Color(0xFF8f889c),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Google Button
                          if (kIsWeb)
                            GoogleSignInWebButton(onSuccess: _handleGoogleUser)
                          else if (!Platform.isIOS)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _signInWithGoogle,
                                icon: const Icon(Icons.g_mobiledata, size: 24, color: Color(0xFF2b2540)), // Placeholder icon
                                label: const FittedBox(child: Text("Sign in with Google", style: TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700, fontSize: 14))),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF2b2540),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    side: const BorderSide(color: Color(0xFFece7f3), width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                          if (!kIsWeb && !Platform.isIOS)
                            const SizedBox(height: 14),
                          // Apple Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _signInWithApple,
                              icon: const Icon(Icons.apple, size: 21, color: Colors.white),
                              label: const FittedBox(child: Text("Sign in with Apple", style: TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700, fontSize: 14))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(_localizations?.translate(AppStringConstant.or) ?? "Or", 
                            style: const TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF8f889c))
                          ),
                          const SizedBox(height: 16),
                          // Email Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                signInSignUpBottomModalSheet(context, false, false, isFromProductDetail: widget.arguments["isFromProductDetailForLogin"] == true);
                              },
                              child: FittedBox(
                                child: Text(_localizations?.translate(AppStringConstant.signInWithEmail) ?? "Sign in with email", 
                                  style: const TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700, fontSize: 14)
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5232a8),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Create Account Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                signInSignUpBottomModalSheet(context, true, false, isFromProductDetail: widget.arguments["isFromProductDetailForLogin"] == true);
                              },
                              child: FittedBox(
                                child: Text(_localizations?.translate(AppStringConstant.createAnAccount) ?? "Create an account", 
                                  style: const TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700, fontSize: 14)
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2b2540),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  side: const BorderSide(color: Color(0xFF2b2540), width: 1.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    var wkToken = await AppSharedPref.getWkToken();
    var fcmToken = await AppSharedPref.getFcmToken();
    bloc?.add(GoogleSignInEvent(wkToken, fcmToken));
  }

  void _signInWithApple() async {
    var wkToken = await AppSharedPref.getWkToken();
    var fcmToken = await AppSharedPref.getFcmToken();
    bloc?.add(AppleSignInEvent(wkToken, fcmToken));
  }

  void _handleGoogleUser(GoogleSignInAccount user) async {
    var wkToken = await AppSharedPref.getWkToken();
    var fcmToken = await AppSharedPref.getFcmToken();
    bloc?.add(GoogleSignInWebEvent(user, wkToken, fcmToken));
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleSignInButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDDDDDD)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'G',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF3C4043),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
