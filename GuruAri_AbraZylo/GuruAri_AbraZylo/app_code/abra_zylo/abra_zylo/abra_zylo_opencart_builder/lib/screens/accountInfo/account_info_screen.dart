import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/screens/accountInfo/bloc/account_info_events.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/common_outlined_button.dart';
import '../../common_widgets/common_switch_button.dart';
import '../../common_widgets/common_text_field.dart';
import '../../common_widgets/dialog_helper.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../models/loginModel/login_model.dart';
import 'bloc/account_info_bloc.dart';
import 'bloc/account_info_state.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool changePassword = false;
  bool changeEmail = false;
  bool isLoading = false;
  bool isEmailVerified = false;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final _deleteDialogFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController deletePasswordController = TextEditingController();
  AppLocalizations? _localizations;
  AccountInfoBloc? _accountInfoBloc;

  LoginModel? userDefaultData;
  var userEmail = "";

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    AppSharedPref.getLoginUserData().then((value) => userDefaultData = value);
    _accountInfoBloc = context.read<AccountInfoBloc>();
    AppSharedPref.getWkToken()
        .then((value) => _accountInfoBloc?.add(AccountDetailEvent(value)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountInfoBloc, AccountInfoState>(
        builder: (BuildContext context, AccountInfoState currentState) {
      if (currentState is AccountInfoLoadingState) {
        isLoading = true;
      } else if (currentState is AccountInfoSuccessState) {
        isLoading = false;
        var model = currentState.data;
        if (model.error == 0) {
          if (userDefaultData != null) {
            userDefaultData!.firstname = firstNameController.text;
            userDefaultData!.lastname = lastNameController.text;
            userDefaultData!.email = emailController.text;
            userDefaultData!.phone = telephoneController.text;
          }
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(model.message ?? "", context);
            Navigator.of(context).pop();
          });
        } else {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(model.message ?? "", context);
          });
        }
      } else if (currentState is AccountDetailSuccessState) {
        isLoading = false;
        var data = currentState.data;
        print("qdada--${data.error}");
        if (data.error == null) {
          firstNameController.text = data.firstname ?? "";
          lastNameController.text = data.lastname ?? "";
          emailController.text = data.email ?? "";
          telephoneController.text = data.telephone ?? "";
          faxController.text = data.fax ?? "";
          userEmail = data.email ?? "";
        } else {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(data.message ?? "", context);
          });
        }
      } else if (currentState is LoginState) {
        isLoading = false;
        LoginModel loginModel = currentState.data;
        if (loginModel.error != 1) {
          _accountInfoBloc?.add(DeleteAccountEvent());
          _accountInfoBloc?.emit(AccountInfoLoadingState());
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(loginModel.message ?? "", context);
          });
        }
      } else if (currentState is DeleteAccountState) {
        isLoading = false;
        if (currentState.data.error == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            AlertMessage.showSuccess(currentState.data.message ?? "", context);
            await AppSharedPref.logoutUser();
            Navigator.of(context).pushNamed(AppRoute.bottomTabBAr);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.data.message ?? "", context);
          });
        }
      } else if (currentState is AccountInfoErrorState) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message, context);
        });
      }

      return _buildUI();
    });
  }

  Widget _buildUI() {
    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(AppStringConstant.accountInfo) ?? '',
          context),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              accountInfoForm(),
            ],
          ),
        ),
        Visibility(visible: isLoading, child: Loader())
      ]),
    );
  }

  Widget accountInfoForm() {
    return Card(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        child: Padding(
            // padding: const EdgeInsets.all(AppSizes.size16),
            padding: const EdgeInsets.fromLTRB(
                AppSizes.size16, AppSizes.size16, AppSizes.size16, 80),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: AppSizes.size8,
                    ),
                    CommonTextField(
                      controller: firstNameController,
                      isPassword: false,
                      labelText: _localizations
                              ?.translate(AppStringConstant.firstName) ??
                          "",
                      isRequired: true,
                      inputType: TextInputType.name,
                    ),
                    const SizedBox(height: AppSizes.size20),
                    CommonTextField(
                      controller: lastNameController,
                      isPassword: false,
                      labelText: _localizations
                              ?.translate(AppStringConstant.lastName) ??
                          "",
                      isRequired: true,
                      inputType: TextInputType.name,
                    ),
                    const SizedBox(height: AppSizes.size20),
                    CommonTextField(
                      controller: telephoneController,
                      isPassword: false,
                      labelText: _localizations
                              ?.translate(AppStringConstant.telephone) ??
                          "",
                      isRequired: true,
                      inputType: TextInputType.phone,
                    ),
                    // const SizedBox(height: AppSizes.size20),
                    // CommonTextField(
                    //   controller: faxController,
                    //   isPassword: false,
                    //   labelText:
                    //       _localizations?.translate(AppStringConstant.fax) ?? "",
                    //   isRequired: false,
                    // ),
                    const SizedBox(height: AppSizes.size10),
                    CommonSwitchButton(
                        _localizations
                                ?.translate(AppStringConstant.changeEmail) ??
                            '', (value) {
                      setState(() {
                        changeEmail = value;
                      });
                    }, changeEmail),
                    if (changeEmail)
                      Column(
                        children: [
                          const SizedBox(height: AppSizes.size8),
                          CommonTextField(
                            controller: emailController,
                            isPassword: false,
                            labelText: _localizations?.translate(
                                    AppStringConstant.emailAddress) ??
                                "",
                            isRequired: true,
                            validationType: AppStringConstant.email,
                            inputType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    const SizedBox(height: AppSizes.size10),
                    CommonSwitchButton(
                        _localizations
                                ?.translate(AppStringConstant.changePassword) ??
                            '', (value) {
                      setState(() {
                        if (userEmail.isNotEmpty == true &&
                            userEmail != "demo@webkul.com") {
                          changePassword = value;
                          passwordController.clear();
                          confirmPasswordController.clear();
                          confirmPasswordController.clear();
                        } else {
                          AlertMessage.showError(
                              _localizations?.translate(AppStringConstant
                                      .youAreNotAuthriseToDeleteAccount) ??
                                  "",
                              context);
                        }
                      });
                    }, changePassword),
                    const SizedBox(height: AppSizes.size8),
                    if (changePassword)
                      Column(
                        children: [
                          CommonTextField(
                            controller: passwordController,
                            isRequired: changePassword,
                            isPassword: true,
                            validationType: AppStringConstant.password,
                            labelText: _localizations?.translate(
                                    AppStringConstant.newPassword) ??
                                '',
                            inputType: TextInputType.visiblePassword,
                          ),
                          const SizedBox(height: AppSizes.size16),
                          CommonTextField(
                            labelText: _localizations?.translate(
                                    AppStringConstant.confirmPassword) ??
                                "",
                            controller: confirmPasswordController,
                            isRequired: changePassword,
                            isPassword: true,
                            inputType: TextInputType.visiblePassword,
                            validationType: AppStringConstant.password,
                            validation: (value) {
                              if (confirmPasswordController.text !=
                                  passwordController.text) {
                                return _localizations?.translate(
                                        AppStringConstant.passwordNotMatch) ??
                                    '';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: AppSizes.size16),
                        ],
                      ),
                    const SizedBox(height: AppSizes.size10),
                    commonButton(
                      context,
                      () async {
                        if (_formKey.currentState?.validate() == true) {
                          var wkToken = await AppSharedPref.getWkToken();
                          _accountInfoBloc?.add(SaveAccountInfoEvent(
                              wkToken,
                              firstNameController.text,
                              lastNameController.text,
                              changeEmail
                                  ? emailController.text
                                  : userDefaultData!.email ?? "",
                              telephoneController.text,
                              faxController.text,
                              changePassword,
                              changePassword ? passwordController.text : null));
                        }
                      },
                      _localizations
                              ?.translate(AppStringConstant.save)
                              .toUpperCase() ??
                          '',
                    ),
                    //Delete Button
                    const SizedBox(height: AppSizes.size16),
                    commonButton(context, () async {
                      if (userEmail.isEmpty) {
                        return;
                      }
                      if (userEmail.isNotEmpty == true &&
                          userEmail != "demo@webkul.com") {
                        DialogHelper.confirmationDialog(
                            AppStringConstant.areYouSureToDeleteAccount,
                            context,
                            _localizations, onConfirm: () async {
                          displayPasswordAuthenticationDialog(context);
                        });
                      } else {
                        AlertMessage.showError(
                            _localizations?.translate(AppStringConstant
                                    .youAreNotAuthriseToDeleteAccount) ??
                                "",
                            context);
                        // show authrosize warnign message
                      }
                    },
                        _localizations
                                ?.translate(AppStringConstant.deleteAccount)
                                .toUpperCase() ??
                            '',
                        // backgroundColor: AppColors.red,
                        textColor: AppColors.red,
                        borderSideColor: AppColors.white),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<void> displayPasswordAuthenticationDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${_localizations?.translate(AppStringConstant.deleteAccount) ?? ""}",
                      style: TextStyle(fontWeight: FontWeight.w700),
                      // maxLines: 4,
                    ),
                  ),
                  Text(
                    "${_localizations?.translate(AppStringConstant.pleaseEnterPasswordToDeleteAccount) ?? ""}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: AppSizes.size14),
                  ),
                  Text(
                    "${_localizations?.translate(AppStringConstant.pleaseEnterPasswordToDeleteAccount2) ?? ""}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: AppSizes.size14),
                  )
                  // Html(
                  //   data: "${_localizations?.translate(AppStringConstant
                  //       .pleaseEnterPasswordToDeleteAccount) ?? "" }" +
                  //       userEmail+" "+"${_localizations?.translate(AppStringConstant
                  //       .pleaseEnterPasswordToDeleteAccount2) ?? "" }",
                  //   // maxLines: 4,
                  // ),
                ],
              ),
              content: Form(
                  key: _deleteDialogFormKey,
                  child: TextFormField(
                      controller: deletePasswordController,
                      obscureText: _isObscure,
                      decoration: formFieldDecoration(
                          context,
                          "",
                          _localizations
                                  ?.translate(AppStringConstant.password) ??
                              "",
                          isRequired: true,
                          suffix: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: suffixIconColor(context),
                              ),
                              onPressed: () => setState(
                                    () {
                                      _isObscure = !_isObscure;
                                    },
                                  ))),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return (deletePasswordController.text.isNotEmpty)
                            ? null
                            : (_localizations
                                    ?.translate(AppStringConstant.required) ??
                                "");
                      })),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    _localizations?.translate(AppStringConstant.cancel) ??
                        "Cancel",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.red,
                      ),
                      backgroundColor: AppColors.red),
                ),
                OutlinedButton(
                  onPressed: () async {
                    if (_deleteDialogFormKey.currentState?.validate() ==
                        true /*deletePasswordController.text.isNotEmpty==true*/) {
                      _accountInfoBloc?.add(LoginEvent(
                          userEmail,
                          deletePasswordController.text,
                          "",
                          await AppSharedPref.getWkToken()));
                      _accountInfoBloc?.emit(AccountInfoLoadingState());
                    }

                    /* if (userDefaultData!.email?.isNotEmpty == true && userDefaultData!.email != "demo@webkul.com") {
                        DialogHelper.confirmationDialog(
                            AppStringConstant.deleteAccount, context, _localizations,
                            onConfirm: () async {
                              var wkToken = await AppSharedPref.getWkToken();
                              await ApiClient().deleteUser(wkToken).then((value) async {
                                if (value.message?.isNotEmpty == true)
                                  AlertMessage.showSuccess(value.message ?? '', context);
                                if (value.error == 0) {
                                  await AppSharedPref.logoutUser();
                                  Navigator.of(context).pushNamed(AppRoute.bottomTabBAr);
                                } else {
                                  //show error message
                                  AlertMessage.showError( _localizations?.translate(AppStringConstant.accountCannotbeDeleted)??"", context);
                                }
                              });

                            });
                      } else {
                        AlertMessage.showError( _localizations?.translate(AppStringConstant.youAreNotAuthriseToDeleteAccount)??"", context);
                        // show authrosize warnign message
                      }*/
                  },
                  child: Text(
                    _localizations
                            ?.translate(AppStringConstant.deleteAccount) ??
                        "Delete Account",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.red,
                      ),
                      backgroundColor: AppColors.red),
                )
                /*  TextButton(

                    child: Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),*/
                /*  TextButton(

                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        //codeDialog = valueText;
                        Navigator.pop(context);
                      });
                    },
                  ),*/
              ],
            );
          });
        });
  }
}
