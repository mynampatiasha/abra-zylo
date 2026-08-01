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
import '../../../constants/app_routes.dart';
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
    String initials = name.isNotEmpty ? name[0].toUpperCase() : "U";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 26),
      decoration: const BoxDecoration(
        color: Colors.transparent, // Background handles the gradient
        border: Border(bottom: BorderSide(color: Color(0xFFece7f3), width: 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 84,
            height: 84,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFc8abec), Color(0xFF5232a8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5232a8).withOpacity(0.45),
                  blurRadius: 22,
                  spreadRadius: -10,
                  offset: const Offset(0, 12),
                )
              ],
            ),
            alignment: Alignment.center,
            child: (profileImage != null && profileImage!.isNotEmpty)
                ? ClipOval(
                    child: ImageView(
                      url: profileImage,
                      fit: BoxFit.cover,
                      width: 84,
                      height: 84,
                    ),
                  )
                : Text(
                    initials,
                    style: const TextStyle(
                      fontFamily: 'Baloo 2',
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
          ),
          Text(
            name.isNotEmpty ? name : "User",
            style: const TextStyle(
              fontFamily: 'Baloo 2',
              fontWeight: FontWeight.w700,
              fontSize: 19,
              color: Color(0xFF5232a8),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            email.isNotEmpty ? email : "user@email.com",
            style: const TextStyle(
              fontFamily: 'Karla',
              fontSize: 13.5,
              color: Color(0xFF8f889c),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.accountInfo);
            },
            icon: const Icon(Icons.edit, size: 14),
            label: const Text(
              "Edit profile",
              style: TextStyle(
                fontFamily: 'Karla',
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5232a8),
              backgroundColor: const Color(0xFFefebf8),
              side: const BorderSide(color: Color(0xFFefebf8), width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
