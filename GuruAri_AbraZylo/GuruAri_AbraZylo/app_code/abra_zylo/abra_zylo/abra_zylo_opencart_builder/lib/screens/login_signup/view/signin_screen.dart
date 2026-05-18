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
import 'google_sign_in_web_button.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen(this.isComingFromCartPage, {Key? key}) : super(key: key);
  final bool isComingFromCartPage;

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
            if (widget.isComingFromCartPage == true) {
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
      backgroundColor: Theme.of(context).cardColor,
      appBar: commonToolBar(
          (_localizations?.translate(AppStringConstant.signInWithEmail) ?? ""),
          context,
          isLeadingEnable: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size8, vertical: AppSizes.size26),
        child: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: AppSizes.size4),
                  CommonTextField(
                    controller: _emailController,
                    isRequired: true,
                    isPassword: false,
                    validationType: AppStringConstant.email,
                    inputType: TextInputType.emailAddress,
                    hintText: _localizations
                            ?.translate(AppStringConstant.emailAddress) ??
                        "",
                  ),

                  const SizedBox(height: AppSizes.size16),
                  CommonTextField(

                      // isPassword: true,
                      controller: _passwordController,
                      isRequired: true,
                      isPassword: true,
                      validationType: AppStringConstant.password,
                      hintText: _localizations
                              ?.translate(AppStringConstant.password) ??
                          ""),

                  const SizedBox(height: AppSizes.size16 * 1.5),

                  /// Forgot password
                  GestureDetector(
                    child: Text(
                      _localizations
                              ?.translate(AppStringConstant.forgotPassword) ??
                          "",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontSize: 13),
                    ),
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
                  ),
                  const SizedBox(height: AppSizes.size16 * 1.5),
                  commonButton(
                    context,
                    _validateForm,
                    (_localizations?.translate(AppStringConstant.signIn) ?? ""),
                    //  .toUpperCase(),
                    // backgroundColor: MobikulTheme.primaryColor,

                    // textColor: Colors.white),
                  ),

                  const SizedBox(height: AppSizes.size16),

                  /// Create account

                  commonButton(
                    context,
                    () {
                      Navigator.pop(context);
                      signInSignUpBottomModalSheet(context, true, false);
                    },
                    (_localizations
                            ?.translate(AppStringConstant.createAnAccount) ??
                        ""),
                    // .toUpperCase(),
                    textColor: AppColors.black,
                    //Theme.of(context).colorScheme.onPrimary
                    backgroundColor: MobikulTheme.iconColor,

                    //  backgroundColor: AppColors.white
                  ),

                  const SizedBox(height: AppSizes.size16),
                  if (isFingerprintAdded && !kIsWeb)
                    Center(
                      child: InkWell(
                        child: Lottie.asset(AppImages.fingerPrintLottie,
                            width: AppSizes.deviceWidth / 6,
                            height: AppSizes.deviceWidth / 6,
                            fit: BoxFit.fill,
                            repeat: true),
                        onTap: () {
                          startAuthentication(false);
                        },
                      ),
                    ),

                  // ── Google Sign-In ──────────────────────────────────
                  const SizedBox(height: AppSizes.size16),
                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR', style: TextStyle(fontSize: 12)),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: AppSizes.size16),
                  // On web: use Google's own rendered button (GIS requirement)
                  // On mobile: use our custom styled button
                  if (kIsWeb)
                    GoogleSignInWebButton(onSuccess: _handleGoogleUser)
                  else
                    _GoogleSignInButton(onTap: _signInWithGoogle),
                  const SizedBox(height: AppSizes.size16),
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

  // Called by the web Google button after successful sign-in
  void _handleGoogleUser(GoogleSignInAccount user) async {
    var wkToken = await AppSharedPref.getWkToken();
    var fcmToken = await AppSharedPref.getFcmToken();
    bloc?.add(GoogleSignInWebEvent(user, wkToken, fcmToken));
  }

  //================Handle Fingerprint Login==============//
  final LocalAuthentication auth = LocalAuthentication(); //----Initialization
  void checkFingerprint() {
    // local_auth uses platform channels — not supported on web
    if (kIsWeb) {
      if (widget.isComingFromCartPage == true) {
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
        if (widget.isComingFromCartPage == true) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.cart, (route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
        }
        /* Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);*/
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
