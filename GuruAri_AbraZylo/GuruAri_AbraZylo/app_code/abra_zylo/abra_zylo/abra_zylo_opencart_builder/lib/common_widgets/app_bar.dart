import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/main.dart';

import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
import '../constants/app_string_constant.dart';
import '../constants/arguments_map.dart';
import '../helper/app_shared_pref.dart';
import '../helper/open_bottom_model_sheet_helper.dart';
import 'dialog_helper.dart';

AppBar commonAppBar(String heading, BuildContext context,
    {bool isHomeEnable = false,
    bool isElevated = true,
    bool isLeadingEnable = false,
    List<Widget>? actions,
    bool hideSearch = false,
    bool hideNotification = false,
    bool hideCart = false,
    bool isCart = false,
    bool hideAll = false,
    VoidCallback? onPressed}) {
  if (hideAll) {
    hideCart = true;
    hideNotification = true;
    hideSearch = true;
  }
  AppLocalizations? _localizations;
  Widget setAppLogoWidget() {
    return (Theme.of(context).brightness == Brightness.dark &&
            mAppStoragePref.getDarkThemeLogo().isNotEmpty)
        ? CachedNetworkImage(
            imageUrl: ApiConstant.imageUrl(mAppStoragePref.getDarkThemeLogo()),
            fit: BoxFit.fill,
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/app_logo.png", // Local fallback image
              fit: BoxFit.fill,
            ),
          )
        : (Theme.of(context).brightness == Brightness.light &&
                mAppStoragePref.getLightThemeLogo().isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: ApiConstant.imageUrl(mAppStoragePref.getLightThemeLogo()),
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => Image.asset(
                  "assets/images/app_logo.png", // Local fallback image
                  fit: BoxFit.fill,
                ),
              )
            : Image.asset(
                "assets/images/app_logo.png", // Local fallback image
                fit: BoxFit.fill,
              );
  }

  return AppBar(
    // leading: BackButton(
    //     color: Colors.white
    // ),
    leading: isHomeEnable
        ? null
        : isLeadingEnable
            ? IconButton(
                onPressed: () {
                  onPressed!();
                },
                icon: const Icon(
                  Icons.clear,
                  color: MobikulTheme.iconColor,
                ))
            : const BackButton(color: MobikulTheme.iconColor),
    elevation: isElevated ? null : 0,
    title: Row(
      children: [
        if (isHomeEnable)
          if (isHomeEnable ?? false)
            Container(
              height: AppBar().preferredSize.height / 2,
              width: AppBar().preferredSize.height / 2,
              child: setAppLogoWidget(),
            ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isHomeEnable ? AppSizes.size8 : 0),
            child: SizedBox(
              child: Text(
                heading,

                // style: Theme.of(context).textTheme.headlineMedium?.copyWith(/*color:  MobikulTheme.iconColor*/),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ),
        ),
      ],
    ),
    actions: actions ??
        <Widget>[
          if (isCart)
            IconButton(
                onPressed: () async {
                  //Navigator.of(context).pushNamed(AppRoute.wishlist);
                  /*
                    * WishList labelLarge functionality
                    *
                    * */

                  if (await AppSharedPref.isLogin() == true) {
                    Navigator.of(context).pushNamed(AppRoute.wishlist);
                  } else {
                    DialogHelper.confirmationDialog(
                        "${AppStringConstant.signInToContinue.localized()}",
                        context,
                        _localizations, onConfirm: () async {
                      Navigator.of(context).pushNamed(
                        AppRoute.login,
                        arguments: getSignInSignUpPageArgument(false, false),
                      );
                    });
                  }
                },
                icon: const Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                )),
          if (hideSearch)
            IconButton(
              iconSize: 28,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoute.searchScreen);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          if (hideNotification)
            IconButton(
                onPressed: () {
                  notificationBottomModelSheet(context);
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                )),
        ],
  );
}
