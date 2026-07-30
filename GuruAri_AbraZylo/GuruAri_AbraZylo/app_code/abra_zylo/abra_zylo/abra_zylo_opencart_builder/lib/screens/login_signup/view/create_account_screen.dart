import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';
import 'package:oc_demo/screens/login_signup/view/signup_extra_views.dart';
import 'package:oc_demo/utils/validator.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/common_outlined_button.dart';
import '../../../common_widgets/common_text_field.dart';
import '../../../common_widgets/common_tool_bar.dart';
import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/loader.dart';
import '../../../common_widgets/privacy_policy_checkbox_widget.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../helper/open_bottom_model_sheet_helper.dart';
import '../../../utils/helper.dart';
import '../../login_signup/bloc/signin_signup_screen_bloc.dart';

class CreateAnAccount extends StatefulWidget {
  CreateAnAccount(this.isComingFromCartPage, {Key? key}) : super(key: key);
  final bool isComingFromCartPage;

  @override
  _CreateAnAccountState createState() => _CreateAnAccountState();
}

class _CreateAnAccountState extends State<CreateAnAccount> {
  SigninSignupScreenBloc? bloc;
  RegisterAccountModel? registerDataModel;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  late FocusNode _emailFocusNode,
      _passwordFocusNode,
      _lastnameFocusNode,
      _confirmPasswordFocusNode,
      _firstnameFocusNode,
      _telephoneFocusNode,
      _shopNameFocusNode;

  late AppLocalizations? _localizations;
  late bool _loading;
  String isNewsletter = "0";
  bool isPrivacyAccepted = false;
  bool toBecomeSellerSelected = false;
  late GlobalKey<FormState> _formKey;
  String? emailErrorMessage;
  String? selectedId;

  void _validateForm() async {
    if (_formKey.currentState?.validate() == true) {
      Helper.hideSoftKeyBoard();
      var wkToken = await AppSharedPref.getWkToken();
      var fcmToken = await AppSharedPref.getFcmToken();
      if (!isPrivacyAccepted) {
        AlertMessage.showError(
            _localizations?.translate(AppStringConstant.privacyError) ?? "",
            context);
      } else {
        bloc?.add(SignUpEvent(
            wkToken,
            "0",
            _firstNameController.text,
            _lastNameController.text,
            _emailController.text,
            _telephoneController.text,
            _passwordController.text,
            isNewsletter,
            isPrivacyAccepted ? "1" : "0",
            toBecomeSellerSelected ? "1" : "0",
            _shopNameController.text,
            fcmToken));
        bloc?.emit(LoadingState());
      }
    } else {
      _focusErrorNode();
    }
  }

  void _focusErrorNode() {
    if (_firstNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_firstnameFocusNode);
    } else if (_lastNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_lastnameFocusNode);
    } else if (_emailController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    } else if (_telephoneController.text.isEmpty && emailErrorMessage != null) {
      FocusScope.of(context).requestFocus(_telephoneFocusNode);
    } else if (_passwordController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    } else if (_confirmPasswordController.text.isEmpty ||
        _confirmPasswordController.text != _passwordController.text) {
      FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
    } else if (toBecomeSellerSelected && _shopNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_shopNameFocusNode);
    }
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _loading = true;
    _formKey = GlobalKey();
    bloc = context.read<SigninSignupScreenBloc>();
    AppSharedPref.getWkToken()
        .then((value) => bloc?.add(GetRegisterDataEvent(value)));

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _lastnameFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _firstnameFocusNode = FocusNode();
    _telephoneFocusNode = FocusNode();
    _shopNameFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninSignupScreenBloc, SigninSignupScreenState>(
      builder: (context, state) {
        if (state is LoadingState) {
          _loading = true;
        } else if (state is SigninSignupScreenError) {
          _loading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(state.message ?? "", context);
          });
        } else if (state is RegisterDataSuccess) {
          registerDataModel = state.model;
          _loading = false;
        } else if (state is CheckEmailStateSuccess) {
          emailErrorMessage = null;
        } else if (state is CheckEmailStateError) {
          emailErrorMessage =
              _localizations?.translate(AppStringConstant.emailAlreadyExist) ??
                  "Email Already Exist";
        } else if (state is SignupScreenFormSuccess) {
          _loading = false;
          var model = state.data;
          model.firstname = _firstNameController.text;
          model.lastname = _lastNameController.text;
          model.email = _emailController.text;
          print("pankaj , ${model.firstname},${model.lastname},${model.email}");
          AppSharedPref.setLoginUserData(model);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                _localizations?.translate(
                        AppStringConstant.accountCreatedSuccessfully) ??
                    "success message",
                context);
            if (widget.isComingFromCartPage == true) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.cart, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.bottomTabBAr, (route) => false);
            }
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
      backgroundColor: Colors.grey.shade100,
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.createAnAccount) ?? "",
          context,
          isLeadingEnable: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF673AB7), Color(0xFF9C27B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_add_outlined, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Create Your Account',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
                            SizedBox(height: 2),
                            Text('Join thousands of happy customers',
                                style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  CommonTextField(
                    focusNode: _firstnameFocusNode,
                    controller: _firstNameController,
                    isRequired: true,
                    isPassword: false,
                    hintText: _localizations
                            ?.translate(AppStringConstant.firstName) ??
                        '',
                    inputType: TextInputType.name,
                  ),

                  const SizedBox(height: AppSizes.size16),
                  CommonTextField(
                    focusNode: _lastnameFocusNode,
                    controller: _lastNameController,
                    isRequired: true,
                    isPassword: false,
                    hintText:
                        _localizations?.translate(AppStringConstant.lastName) ??
                            '',
                    inputType: TextInputType.name,
                  ),
                  const SizedBox(height: AppSizes.size16),
                  TextFormField(
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: formFieldDecoration(
                        context,
                        "",
                        _localizations
                                ?.translate(AppStringConstant.emailAddress) ??
                            "",
                        isRequired: true),
                    autovalidateMode: (_emailController.text.isNotEmpty)
                        ? AutovalidateMode.always
                        : AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return Validator.isEmailValid(value ?? '', context);
                    },
                    onChanged: (value) async {
                      if (Validator.isEmailValid(value, context) == null) {
                        var wkToken = await AppSharedPref.getWkToken();
                        bloc?.add(CheckEmailEvent(value, wkToken));
                      } else {
                        emailErrorMessage = null;
                      }
                    },
                  )

                  /* CommonTextField(
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    isPassword: false,
                    hintText: _localizations
                            ?.translate(AppStringConstant.emailAddress) ??
                        "",
                    isRequired: true,
                    inputType: TextInputType.emailAddress,
                    validationType: AppStringConstant.email,
                    onChange: (value) async {
                      if (Validator.isEmailValid(value,context) == null) {
                        var wkToken = await AppSharedPref.getWkToken();
                        bloc?.add(CheckEmailEvent(value, wkToken));
                      }
                    },
                  )*/
                  ,
                  if (emailErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.size4),
                      child: Text(
                        emailErrorMessage!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.red),
                      ),
                    ),
                  const SizedBox(height: AppSizes.size16),
                  CommonTextField(
                    focusNode: _telephoneFocusNode,
                    controller: _telephoneController,
                    isPassword: false,
                    hintText: _localizations
                            ?.translate(AppStringConstant.telephone) ??
                        "",
                    isRequired: true,
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppSizes.size16),

                  CommonTextField(
                    focusNode: _passwordFocusNode,
                    hintText:
                        _localizations?.translate(AppStringConstant.password) ??
                            "",
                    controller: _passwordController,
                    isRequired: true,
                    isPassword: true,
                    inputType: TextInputType.visiblePassword,
                    validationType: AppStringConstant.password,
                  ),
                  const SizedBox(height: AppSizes.size16),
                  CommonTextField(
                    focusNode: _confirmPasswordFocusNode,
                    hintText: _localizations
                            ?.translate(AppStringConstant.confirmPassword) ??
                        "",
                    controller: _confirmPasswordController,
                    isRequired: true,
                    isPassword: true,
                    inputType: TextInputType.visiblePassword,
                    validation: (value) {
                      if (_confirmPasswordController.text !=
                          _passwordController.text) {
                        return _localizations?.translate(
                                AppStringConstant.passwordMismatch) ??
                            '';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: AppSizes.size16),
                  /*
                  *
                  * To becoame seller view start
                  * Uncomment below code for marketplace and comment for OC builder
                  *
                  * */

                  /*   Row(
                    children: [
                      Checkbox(
                          value: toBecomeSellerSelected,
                          onChanged: (value) {
                            toBecomeSellerSelected=value??false;
                            setState(() {

                            });

                          }),
                      Text(
                        _localizations
                                ?.translate(AppStringConstant.toBecomeSeller) ??
                            "",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                    ],
                  ),
                  Visibility(
                    visible: toBecomeSellerSelected,
                    child:    CommonTextField(
                    focusNode: _shopNameFocusNode,
                    controller: _shopNameController,
                    isRequired: true,
                    isPassword: false,
                    hintText:
                    _localizations?.translate(AppStringConstant.shopName) ??
                        '',
                    inputType: TextInputType.name,
                  ),),*/

                  /*
                  *
                  * To becoame seller view start
                  * Uncomment above code for marketplace and comment for OC builder
                  *
                  * */

                  const SizedBox(height: AppSizes.size16),
                  Newsletter(
                    (value) {
                      isNewsletter = value;
                      selectedId = value;
                    },
                    AppStringConstant.newsLetter,
                    showHeading: true,
                    selectedId: selectedId ?? "",
                  ),
                  const SizedBox(height: AppSizes.size16),
                  PrivacyPolicyCustomCheckbox(
                    (value) {
                      isPrivacyAccepted = value;
                    },
                    _localizations?.translate(AppStringConstant.privacyPolicy),
                    registerDataModel?.agreeInfo?.data?.description,
                  ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _validateForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          _localizations?.translate(AppStringConstant.createAnAccount) ?? "Create an Account",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                  ),
                ),
                const SizedBox(height: 16),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        _localizations
                                ?.translate(AppStringConstant.alreadyHaveAccount)
                                .toUpperCase() ??
                            '',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        signInSignUpBottomModalSheet(context, false, false);
                      },
                      child: Text(
                        (_localizations?.translate(AppStringConstant.signIn) ?? '').toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
