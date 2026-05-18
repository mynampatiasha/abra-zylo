/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter/material.dart';
import 'package:oc_demo/models/accountItemsListModel/account_items_list_model.dart';
import 'package:oc_demo/network_manager/apis.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../helper/generic_methods.dart';
import '../../../network_manager/multipart_file_upload.dart';

class HeaderProfileView extends StatefulWidget {
  HeaderProfileView({Key? key}) : super(key: key);

  @override
  _HeaderProfileViewState createState() => _HeaderProfileViewState();
}

class _HeaderProfileViewState extends State<HeaderProfileView> {
  String? bannerImage;
  String? profileImage;
  String name = "";
  String email = "";
  AppLocalizations? _localizations;
  late BannerModel? userModel;

  @override
  void initState() {
    if (mAppStoragePref.getUserData() != null) {
      userModel = mAppStoragePref.getUserData();
      bannerImage = userModel?.banner;
      profileImage = userModel?.banner;
      name = userModel?.firstname ?? "";
      email = userModel?.email ?? "";
    }
    super.initState();
  }

  void getDetails() {
    setState(() {
      if (mAppStoragePref.getUserData() != null) {
        userModel = mAppStoragePref.getUserData();
        bannerImage = userModel?.banner;
        profileImage = userModel?.image;
        name = userModel?.firstname ?? "";
        email = userModel?.email ?? "";
      }
    });
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    getDetails();
    return SizedBox(
        height: AppSizes.deviceWidth * 0.5,
        width: AppSizes.deviceWidth,
        child: _commonBannerView(bannerImage, profileImage, name, email));
  }

  Widget _commonBannerView(
      String? bannerImage, String? profileImage, String name, String email) {
    print("ImageUrl:::$profileImage");
    return SizedBox(
      width: AppSizes.deviceWidth,
      child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Stack(
              children: [
                Container(
                  decoration: ((bannerImage ?? "").isNotEmpty)
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              AppImages.placeholder,
                            ),
                            fit: BoxFit.contain,
                          ),
                        )
                      : const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              AppImages.placeholder,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  top: 0,
                  right: 0,
                  child: Container(
                      width: AppSizes.deviceWidth,
                      decoration: const BoxDecoration(
                        color: AppColors.transparentBackground,
                        shape: BoxShape.rectangle,
                      )),
                ),
                Positioned(
                  left: 0,
                  bottom: 2,
                  child: SizedBox(
                      width: AppSizes.deviceWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.size4,
                          horizontal: AppSizes.size4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: AppSizes.size60,
                              width: AppSizes.size60,
                              child: ImageView(
                                url: profileImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: AppSizes.size8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontSize: AppSizes.size14,
                                      ),
                                ),
                                const SizedBox(
                                  height: AppSizes.size4,
                                ),
                                Text(
                                  email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: AppSizes.size14,
                                      ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
