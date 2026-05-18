// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      else if (state is SigninSignupScreenError) {
        _loading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showSuccess(state.message ?? "", context);
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
    /*  Future.delayed(const Duration(milliseconds: 500), () {
      if(widget.isFromCartForLogin){
        _openBottomModalSheet(ModalType.signin);
      }

      if(widget.isFromCartForSignup){
        _openBottomModalSheet(ModalType.createAccount);
      }
    });*/

    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(
                AppStringConstant.signInRegister,
              ) ??
              '',
          context,
          isLeadingEnable: false, onPressed: () {
        Navigator.pop(context);
      }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  _localizations?.translate(AppConstant.isMarketPlace
                          ? AppStringConstant.appNameMarketplace
                          : AppStringConstant.appNameBuilder) ??
                      "",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.size12),
              child: Text(
                ((_localizations?.translate(AppStringConstant.signInRegister) ??
                        "")
                    .toUpperCase()),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 12),
              ),
            ),
            commonButton(
              context,
              () {
                signInSignUpBottomModalSheet(context, false, false);
              },
              _localizations?.translate(AppStringConstant.signInWithEmail)
                  //.toUpperCase()
                  ??
                  "",
              // backgroundColor: MobikulTheme.primaryColor,
              //   textColor: Theme.of(context).cardColor

              // textColor: Colors.white),
            ),
            SizedBox(height: AppSizes.size16),
            commonButton(context, () {
              signInSignUpBottomModalSheet(context, true, false);
            },
                _localizations?.translate(AppStringConstant.createAnAccount)
                    //  .toUpperCase()
                    ??
                    "",
                backgroundColor: Colors.white,
                textColor: Colors.black
                // textColor:Colors.white
                ),
            SizedBox(height: AppSizes.size16),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[
            //     Expanded(child: Divider(thickness: 1)),
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 8.0),
            //       child: Text(
            //           _localizations?.translate(AppStringConstant.or) ?? ''),
            //     ),
            //     Expanded(child: Divider(thickness: 1)),
            //   ],
            // ),
            SizedBox(
              height: AppSizes.size16,
            )
          ],
        )),
      ),
    );
  }
}
