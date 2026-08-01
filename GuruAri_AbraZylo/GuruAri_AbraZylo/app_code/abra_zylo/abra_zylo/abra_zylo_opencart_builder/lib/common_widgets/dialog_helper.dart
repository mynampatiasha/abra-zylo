import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/config/theme.dart';

import '../constants/app_constants.dart';
import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';
import '../utils/helper.dart';
import '../utils/validator.dart';
import 'alert_message.dart';

class DialogHelper {
  static quantityDialog(BuildContext context, AppLocalizations? localizations,
      {ValueChanged<String>? onSave, String? initialValue}) {
    // initial value 0
    final TextEditingController _textEditingController =
        TextEditingController(text: initialValue ?? "0");
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.size16, AppSizes.size16, AppSizes.size16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations?.translate(AppStringConstant.enterQuantity) ?? "",
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: AppSizes.size8),
              TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  hintText:
                      localizations?.translate(AppStringConstant.quantity) ??
                          "",
                  border: const OutlineInputBorder(),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                          localizations?.translate(AppStringConstant.cancel) ??
                              "",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (onSave != null) {
                          onSave(_textEditingController.text);
                          Navigator.of(ctx).pop();
                        }
                      },
                      child: Text(
                        localizations?.translate(AppStringConstant.save) ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static confirmationDialog(
      String text, BuildContext context, AppLocalizations? localizations,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Padding(
          padding:
              const EdgeInsets.only(top: AppSizes.size8, left: AppSizes.size8),
          child: Text(
            localizations?.translate(text) ?? "",
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: 100,
            height: 30,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blueGrey[100],
                side: BorderSide(
                  color: Colors.black, // Set the border color to black
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.size6),
                ),
                // style: OutlinedButton.styleFrom(
                //     side: BorderSide(
                //       color: AppColors.black,
                //     ),),
              ),
              child: Text(
                AppStringConstant.cancel.localized().toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black, fontSize: AppSizes.size10),
                // style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: AppSizes.size14),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 30,
            child: OutlinedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.size6),
                  ),
                ),
                child: Text(
                  AppStringConstant.ok.localized().toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white, fontSize: AppSizes.size10),
                )),
          )
          //   style: OutlinedButton.styleFrom(
          //
          //       backgroundColor:MobikulTheme.primaryColor),
          // ),
        ],
      ),
    );
  }

  static wishlistConfirmationDialog(String text, String title,
      BuildContext context, AppLocalizations? localizations,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        title: Column(
          children: [
            const Icon(Icons.lock_outline, size: 48, color: Color(0xFF673AB7)),
            const SizedBox(height: 16),
            Text(
              localizations?.translate(title) ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        content: Text(
          localizations?.translate(text) ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    AppStringConstant.cancel.localized().toUpperCase(),
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    if (onConfirm != null) {
                      onConfirm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    AppStringConstant.ok.localized().toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static shareWishlistDialog(
      BuildContext context, AppLocalizations? localizations,
      {ValueChanged<String>? onConfirm}) {
    var textEditingController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          localizations?.translate(AppStringConstant.shareWishlistCollection) ??
              "",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText:
                    localizations?.translate(AppStringConstant.emailAddress),
                hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                border: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(
                      color: AppColors.black,
                    )),
                focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(
                      color: AppColors.black,
                    )),
                enabledBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(
                      color: AppColors.black,
                    )),
              ),
            )
          ],
        ),
        titlePadding: const EdgeInsets.fromLTRB(
            AppSizes.size16, AppSizes.size16, AppSizes.size16, 0),
        actionsPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.all(AppSizes.size16),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              String? verifyEmail =
                  Validator.isEmailValid(textEditingController.text, context);
              if (verifyEmail != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AlertMessage.showError(
                      verifyEmail
                      /*localizations
                                ?.translate(AppStringConstant.invalidEmail) ??
                            ''*/
                      ,
                      context);
                });
                return;
              }
              Helper.hideSoftKeyBoard();
              if (onConfirm != null) onConfirm(textEditingController.text);

              Navigator.of(context).pop();
            },
            child: Text(localizations?.translate(AppStringConstant.ok) ?? '',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
                localizations?.translate(AppStringConstant.cancel) ?? "",
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ],
      ),
    );
  }

  //==============Forgot Password Dialog===========//
  static forgotPasswordDialog(BuildContext context,
      AppLocalizations? localizations, String title, String message,
      {ValueChanged<String>? onConfirm,
      ValueChanged<bool>? onCancel,
      String? email,
      bool isForgotPassword = true}) {
    var textEditingController = TextEditingController(text: email ?? "");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: AppSizes.size8,
            ),
            if (isForgotPassword)
              TextField(
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                controller: textEditingController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText:
                      localizations?.translate(AppStringConstant.emailAddress),
                  hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                  border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: AppColors.black,
                      )),
                  focusedBorder: const UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: AppColors.black,
                      )),
                  enabledBorder: const UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: AppColors.black,
                      )),
                ),
              )
          ],
        ),
        titlePadding: const EdgeInsets.fromLTRB(
            AppSizes.size16, AppSizes.size16, AppSizes.size16, 0),
        actionsPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.all(AppSizes.size16),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (isForgotPassword) {
                String? verifyEmail =
                    Validator.isEmailValid(textEditingController.text, context);
                if (verifyEmail != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AlertMessage.showError(
                        verifyEmail
                        /*localizations
                                ?.translate(AppStringConstant.invalidEmail) ??
                            ''*/
                        ,
                        context);
                  });
                  return;
                }
                Helper.hideSoftKeyBoard();
                if (onConfirm != null) onConfirm(textEditingController.text);
              } else {
                if (onConfirm != null) {
                  onConfirm("");
                } //----Just to receive empty callback
              }
              Navigator.of(context).pop();
            },
            child: Text(localizations?.translate(AppStringConstant.ok) ?? '',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onCancel != null) {
                onCancel(true);
              }
            },
            child: Text(
                localizations?.translate(AppStringConstant.cancel) ?? "",
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ],
      ),
    );
  }

  static locationPermissionDialog(String text, BuildContext context,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          AppStringConstant.requiredLocationPermission.localized(),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /* Icon(
              Icons.privacy_tip_sharp,
              color: Theme.of(context).iconTheme.color,
            ),*/
            Text(
              text.localized(),
            ),
            /*TextButton.icon(
              onPressed: () {
              //  DialogHelper.termsAndPrivacyDialog(context, "widget.title", "widget.description",);
                // SplashScreenModel? model =
                // AppSharedPref().getSplashData();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             PrivacyPolicy(model?.privacyPolicyUrl)));
              },
              icon: Icon(
                Icons.privacy_tip_sharp,
                color: Theme.of(context).iconTheme.color,
              ),
              label: Text(AppStringConstant.privacyPolicy.localized(),
                  style: Theme.of(context).textTheme.labelLarge),
            ),*/
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              AppStringConstant.cancel.localized().toUpperCase(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: Text(
              AppStringConstant.ok.localized().toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }

  //===============Search Screen Text/Image selection=========//
  static searchDialog(BuildContext context, AppLocalizations? localizations,
      GestureTapCallback onImageTap, GestureTapCallback onTextTap) {
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (ctx) => AlertDialog(
        // titlePadding: const EdgeInsets.all(AppSizes.genericPadding),
        title: Text(
            localizations?.translate(AppStringConstant.searchByScanning) ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.lightGray)),
        backgroundColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.all(AppSizes.size16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: onTextTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.format_color_text),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.size16),
                    child: Text(
                        localizations
                                ?.translate(AppStringConstant.textSearch) ??
                            "",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onImageTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.image_search),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.size16),
                    child: Text(
                        localizations
                                ?.translate(AppStringConstant.imageSearch) ??
                            "",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static termsAndPrivacyDialog(
    BuildContext context,
    String? title,
    String? description,
  ) =>
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title ?? "Privacy Policy"),
          content: SingleChildScrollView(
            child: Html(data: description ?? ""),
          ),
        ),
      );
}
