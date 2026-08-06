import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/hive/hive_service.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_events.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_state.dart';
import 'package:oc_demo/screens/profile/views/HeaderProfileView.dart';
import 'package:oc_demo/screens/profile/views/profile_menu.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../../common_widgets/common_outlined_button.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../hive/hive_constant.dart';
import '../../network_manager/api_client.dart';
import 'bloc/profile_screen_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _profileState();
  }
}

class _profileState extends State<ProfileScreen> {
  AppLocalizations? _localizations;
  bool isUserLogin = false;
  bool isPartner = false;
  bool partnerApproveRequired = false;
  ProfileScreenBloc? profileScreenBloc;
  bool isLoading = false;
  String? shopName = "";
  String? shopDescription = "";

  @override
  void initState() {
    profileScreenBloc = context.read<ProfileScreenBloc>();
    AppSharedPref.getLoginUserData().then((value) {
      print("Pankaj ${value?.partner ?? ""}" +
          "${value?.partnerApproveRequired ?? ""}");
      isPartner = ((value?.partner ?? 0) == 1);
      partnerApproveRequired =
          (value?.partnerApproveRequired ?? false) == false;
    });
    AppSharedPref.isLogin().then((value) {
      if (value) {
        setState(() {
          isUserLogin = true;
          if (isUserLogin) {
            isLoading = true;
            profileScreenBloc?.add(AccountDetailEvent());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
        builder: (context, currentState) {
      if (currentState is ProfileScreenLoading) {
        isLoading = true;
      } else if (currentState is ToBecomeSellerSuccess) {
        isLoading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showSuccess(
              currentState.baseModel.message ?? '', context);
          if (currentState.baseModel.error == 0) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoute.bottomTabBAr, (Route<dynamic> route) => false);
            //Navigator.pop(context);
            // Navigator.pushNamed(context, AppRoute.homePage);
          }
        });
      } else if (currentState is ProfileScreenSuccess) {
        // isLoading = false;
        if ((currentState.accountInfoModel.status) == 0) {
          isUserLogin = false;
          AppSharedPref.logoutUser();
        }
        profileScreenBloc?.add(const GetAccountItemsDataEvent());
      } else if (currentState is AccountItemDataSuccess) {
        isLoading = false;
        if ((currentState.model.error) == 0) {
          mAppStoragePref.setUserData(currentState.model?.banner);
        }
      } else if (currentState is ProfileScreenImageSuccess) {
        isLoading = false;
        if ((currentState.model?.error) == 1) {
          profileScreenBloc?.add(const GetAccountItemsDataEvent());
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.model?.message ?? '', context);
          });
        }
      } else if (currentState is ProfileScreenError) {
        isLoading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message ?? '', context);
        });
      }
      return buildUI();
    });
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  Widget buildUI() {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Background will be handled by a container
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFf4f0fb), // Fallback
          // We can use a Stack with Positioned containers with blur for the exact gradient effect,
          // but a simple LinearGradient is often enough. For exact match, let's use a subtle gradient:
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFefe6ff), Color(0xFFe8fbf3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFc8abec), // Lavender
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _localizations?.translate(AppStringConstant.profile) ??
                            "Profile",
                        style: const TextStyle(
                          fontFamily: 'Baloo 2',
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                          color: Color(0xFF5232a8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: Stack(
                  children: [
                    Visibility(
                      visible: !isLoading,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (isUserLogin) HeaderProfileView(),
                            profileMenu(() {}, _localizations, () {
                              setState(() {});
                            }, () {
                              requestForSellerBottomSheet();
                            }, isUserLogin, isPartner, partnerApproveRequired),
                            widgetSpace(),
                            if (isUserLogin)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    var wkToken =
                                        await AppSharedPref.getWkToken();
                                    await ApiClient().logoutUser(wkToken);
                                    HiveService.getHive()
                                        .deleteBox(HiveConstant.getAddress);
                                    await AppSharedPref.logoutUser();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            AppRoute.bottomTabBAr,
                                            (route) => false);
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFffe6ea),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: const Icon(Icons.logout,
                                        size: 19, color: Color(0xFFe0405f)),
                                  ),
                                  label: const Text(
                                    'Log out',
                                    style: TextStyle(
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.5,
                                      color: Color(0xFFe0405f),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: const Color(0xFFe0405f),
                                    shadowColor: Colors.transparent,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                            if (!isUserLogin)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    Navigator.of(context).pushNamed(
                                        AppRoute.login,
                                        arguments: getSignInSignUpPageArgument(
                                            false, false));
                                  },
                                  icon: const Icon(Icons.login,
                                      size: 17, color: Colors.white),
                                  label: Text(
                                    _localizations?.translate(
                                            AppStringConstant.signIn) ??
                                        'Sign in',
                                    style: const TextStyle(
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5232a8),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(visible: isLoading, child: const Loader()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void requestForSellerBottomSheet() async {
    showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Scaffold(
        appBar: commonToolBar(
            _localizations?.translate(AppStringConstant.toBecomeSeller) ?? "",
            context,
            isLeadingEnable: true),
        body: StatefulBuilder(
          builder: (context, changeState) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.size8),
              child: Column(
                children: [
                  widgetSpace(),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          _localizations
                                  ?.translate(AppStringConstant.shopName) ??
                              "",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headlineSmall)),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.size8),
                    child: TextField(
                      onChanged: (value) {
                        shopName = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: _localizations
                                ?.translate(AppStringConstant.shopName) ??
                            "",
                        hintStyle:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  widgetSpace(),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          _localizations?.translate(
                                  AppStringConstant.shopDescription) ??
                              "",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headlineSmall)),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.size8),
                    child: TextField(
                      onChanged: (value) {
                        shopDescription = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: _localizations?.translate(
                                AppStringConstant.shopDescription) ??
                            "",
                        hintStyle:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  widgetSpace(),
                  commonButton(context, () {
                    profileScreenBloc
                        ?.add(ToBecomeSellerEvent(shopName, shopDescription));
                    profileScreenBloc?.emit(ProfileScreenInitial());
                    isLoading = true;
                  }, _localizations?.translate(AppStringConstant.submit) ?? "")
                ],
              ),
            );
          },
        ),
      ),
    );
    // }
  }
}
