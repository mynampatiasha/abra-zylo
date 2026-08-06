import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_routes.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/common_outlined_button.dart';
import '../../../common_widgets/common_text_field.dart';
import '../../../common_widgets/common_tool_bar.dart';
import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../helper/open_bottom_model_sheet_helper.dart';
import '../../../utils/helper.dart';
import '../../login_signup/bloc/signin_signup_screen_bloc.dart';
// import 'google_sign_in_web_button.dart'; // commented out — google_sign_in disabled

class SignInScreen extends StatefulWidget {
  SignInScreen(this.isComingFromCartPage,
      {this.isFromProductDetail = false, Key? key})
      : super(key: key);
  final bool isComingFromCartPage;
  final bool isFromProductDetail;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SigninSignupScreenBloc? bloc;
  late TextEditingController _emailController, _passwordController;
  late AppLocalizations? _localizations;
  late GlobalKey<FormState> _formKey;
  bool _loading = false;
  bool isFingerprintAdded = false;
  bool loginFromFingerPrint = false;
  String? email = "";

  @override
  void initState() {
    _emailController = TextEditingController(text: AppConstant.demoEmail);
    _passwordController = TextEditingController(
      text: AppConstant.demoPassword,
    );
    bloc = context.read<SigninSignupScreenBloc>();
    _formKey = GlobalKey();
    AppSharedPref.getFingerprintData().then((value) {
      setState(() {
        isFingerprintAdded = value != null;
        email = value?["email"] ?? "";
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  void _validateForm() async {
    if (_formKey.currentState?.validate() == true) {
      Helper.hideSoftKeyBoard();
      var wkToken = await AppSharedPref.getWkToken();
      var fcmToken = await AppSharedPref.getFcmToken();
      loginFromFingerPrint = false;
      bloc?.add(LoginEvent(_emailController.text.trim(),
          _passwordController.text, fcmToken, wkToken));
      bloc?.emit(LoadingState());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninSignupScreenBloc, SigninSignupScreenState>(
      builder: (context, state) {
        if (state is LoadingState) {
          _loading = true;
        } else if (state is ForgotPasswordState) {
          _loading = false;
          var model = state.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(model.message ?? "", context);
          });
        } else if (state is LoginState) {
          _loading = false;
          var model = state.data;
          AppSharedPref.setLoginUserData(model);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                (model.firstname?.isNotEmpty ?? false)
                    ? "Welcome back, ${model.firstname}! Thanks for signing in."
                    : "Welcome back! Thanks for signing in.",
                context);
            if (widget.isFromProductDetail) {
              Navigator.of(context)
                ..pop()
                ..pop();
            } else if (widget.isComingFromCartPage == true) {
              loginFromFingerPrint
                  ? Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoute.cart, (route) => false)
                  : checkFingerprint();
            } else {
              loginFromFingerPrint
                  ? Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.bottomTabBAr, (route) => false)
                  : checkFingerprint();
            }
          });
        } else if (state is SigninSignupScreenError) {
          _loading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(state.message ?? "", context);
          });
        }
        return Stack(
          children: <Widget>[
            _buildContent(),
            Visibility(
              child: Loader(),
              visible: _loading,
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    return Scaffold(
      backgroundColor: const Color(0xFFf4f0fb),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFFc8abec),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 18,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Row(
            children: [
              const BackButton(color: Color(0xFF5232a8)),
              const SizedBox(width: 12),
              Text(
                _localizations?.translate(AppStringConstant.signIn) ??
                    "Sign in",
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
      ),
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Lockup
                  Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFc8abec), Color(0xFF5232a8)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x665232a8),
                              blurRadius: 22,
                              spreadRadius: -10,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Center(
                          child:
                              Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                      ),
                      const Text(
                        "Welcome back",
                        style: TextStyle(
                          fontFamily: 'Baloo 2',
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                          color: Color(0xFF5232a8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Sign in to check out faster and track your orders.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 13.5,
                          color: Color(0xFF8f889c),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Email Field
                  const Text("Email",
                      style: TextStyle(
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: Color(0xFF2b2540))),
                  const SizedBox(height: 7),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                          color: const Color(0xFFece7f3), width: 1.5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.email_outlined,
                            size: 17, color: Color(0xFF8f889c)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(
                                fontFamily: 'Karla',
                                fontSize: 14,
                                color: Color(0xFF2b2540)),
                            decoration: const InputDecoration(
                              hintText: "you@example.com",
                              hintStyle: TextStyle(color: Color(0xFFc2bccf)),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Enter your email';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  const Text("Password",
                      style: TextStyle(
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: Color(0xFF2b2540))),
                  const SizedBox(height: 7),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                          color: const Color(0xFFece7f3), width: 1.5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline,
                            size: 17, color: Color(0xFF8f889c)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                                fontFamily: 'Karla',
                                fontSize: 14,
                                color: Color(0xFF2b2540)),
                            decoration: const InputDecoration(
                              hintText: "••••••••",
                              hintStyle: TextStyle(color: Color(0xFFc2bccf)),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Enter your password';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        DialogHelper.forgotPasswordDialog(
                            context,
                            _localizations,
                            _localizations?.translate(
                                    AppStringConstant.forgotPassword) ??
                                '',
                            _localizations?.translate(
                                    AppStringConstant.forgotPasswordMessage) ??
                                '', onConfirm: (email) async {
                          bloc?.emit(LoadingState());
                          var wkToken = await AppSharedPref.getWkToken();
                          bloc?.add(ForgotPasswordEvent(email, wkToken));
                        }, email: _emailController.text);
                      },
                      child: const Text("Forgot password?",
                          style: TextStyle(
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                              color: Color(0xFF5232a8))),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _validateForm,
                      icon: const Icon(Icons.login,
                          size: 17, color: Colors.white),
                      label: const Text("Sign in",
                          style: TextStyle(
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5232a8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Divider
                  Row(
                    children: const [
                      Expanded(
                          child:
                              Divider(color: Color(0xFFece7f3), thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("OR CONTINUE WITH",
                            style: TextStyle(
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                fontSize: 11.5,
                                letterSpacing: 1.1,
                                color: Color(0xFF8f889c))),
                      ),
                      Expanded(
                          child:
                              Divider(color: Color(0xFFece7f3), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 26),
                  // Social Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _signInWithGoogle,
                          icon: const Icon(Icons.g_mobiledata,
                              size: 17,
                              color: Color(
                                  0xFF2b2540)), // Placeholder icon for Google
                          label: const Text("Google",
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2b2540),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                              side: const BorderSide(
                                  color: Color(0xFFece7f3), width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _signInWithApple,
                          icon: const Icon(Icons.apple,
                              size: 17, color: Color(0xFF2b2540)),
                          label: const Text("Apple",
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2b2540),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                              side: const BorderSide(
                                  color: Color(0xFFece7f3), width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  // Fingerprint login check (optional, but keep it if present)
                  if (isFingerprintAdded && !kIsWeb)
                    Center(
                      child: InkWell(
                        onTap: () => startAuthentication(false),
                        child: Lottie.asset(AppImages.fingerPrintLottie,
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                            repeat: true),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // New here? Create account
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        signInSignUpBottomModalSheet(context, true, false);
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "New here? ",
                          style: TextStyle(
                              fontFamily: 'Karla',
                              fontSize: 13.5,
                              color: Color(0xFF8f889c)),
                          children: [
                            TextSpan(
                                text: "Create an account",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5232a8))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //================Handle Google Sign-In==============//
  void _signInWithGoogle() async {
    var wkToken = await AppSharedPref.getWkToken();
    var fcmToken = await AppSharedPref.getFcmToken();
    bloc?.add(GoogleSignInEvent(wkToken, fcmToken));
  }

  //================Handle Apple Sign-In==============//
  void _signInWithApple() async {
    var wkToken = await AppSharedPref.getWkToken();
    var fcmToken = await AppSharedPref.getFcmToken();
    bloc?.add(AppleSignInEvent(wkToken, fcmToken));
  }

  // Called by the web Google button after successful sign-in — disabled
  // void _handleGoogleUser(GoogleSignInAccount user) async {
  //   var wkToken = await AppSharedPref.getWkToken();
  //   var fcmToken = await AppSharedPref.getFcmToken();
  //   bloc?.add(GoogleSignInWebEvent(user, wkToken, fcmToken));
  // }

  //================Handle Fingerprint Login==============//
  final LocalAuthentication auth = LocalAuthentication(); //----Initialization
  void checkFingerprint() {
    // local_auth uses platform channels — not supported on web
    if (kIsWeb) {
      if (widget.isFromProductDetail) {
        Navigator.of(context)
          ..pop()
          ..pop();
      } else if (widget.isComingFromCartPage == true) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.cart, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
      }
      return;
    }
    auth.isDeviceSupported().then((value) {
      if (value) {
        showFingerprintDialog();
      } else {
        if (widget.isFromProductDetail) {
          Navigator.of(context)
            ..pop()
            ..pop();
        } else if (widget.isComingFromCartPage == true) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.cart, (route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
        }
      }
    });
  }

  void showFingerprintDialog() async {
    if (isFingerprintAdded && _emailController.text == email) {
      // While finger print is added and user is again login with same email
      // startAuthentication(true);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
    } else if (isFingerprintAdded && _emailController.text != email) {
      DialogHelper.forgotPasswordDialog(
          context,
          _localizations,
          _localizations?.translate(AppStringConstant.fingerprintLogin) ?? "",
          _localizations
                  ?.translate(AppStringConstant.replaceFingerprintMessage) ??
              "", onConfirm: (data) {
        startAuthentication(true);
      }, onCancel: (value) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
      }, isForgotPassword: false);
    } else {
      DialogHelper.forgotPasswordDialog(
          context,
          _localizations,
          _localizations?.translate(AppStringConstant.fingerprintLogin) ?? "",
          _localizations?.translate(AppStringConstant.fingerprintMessage) ?? "",
          onConfirm: (data) {
        startAuthentication(true);
      }, onCancel: (value) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
      }, isForgotPassword: false);
    }
  }

  void startAuthentication(bool alreadyLogin) async {
    if (kIsWeb) return; // local_auth not supported on web
    auth.isDeviceSupported().then((value) async {
      if (value) {
        bool didAuthenticate = await auth.authenticate(
            localizedReason:
                _localizations?.translate(AppStringConstant.fingerprintLogin) ??
                    '');
        if (didAuthenticate) {
          if (alreadyLogin) {
            Map<String, String> header = {};
            header["email"] = _emailController.text;
            header["password"] = _passwordController.text;
            AppSharedPref.setFingerprintData(header);
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoute.bottomTabBAr, (route) => false);
          } else {
            loginFromFingerPrint = true;
            bloc?.emit(LoadingState());
            var data = await AppSharedPref.getFingerprintData();
            var wkToken = await AppSharedPref.getWkToken();
            var fcmToken = await AppSharedPref.getFcmToken();
            bloc?.add(LoginEvent(data?["email"] ?? "", data?["password"] ?? "",
                fcmToken, wkToken));
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(
                _localizations
                        ?.translate(AppStringConstant.authenticationFailed) ??
                    '',
                context);
          });
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showError(
              _localizations
                      ?.translate(AppStringConstant.unableToAuthenticate) ??
                  '',
              context);
        });
      }
    });
  }
}

/// Standalone Google Sign-In button widget (mobile)
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

/// Standalone Apple Sign-In button widget (mobile)
class _AppleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AppleSignInButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.apple,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Sign in with Apple',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
