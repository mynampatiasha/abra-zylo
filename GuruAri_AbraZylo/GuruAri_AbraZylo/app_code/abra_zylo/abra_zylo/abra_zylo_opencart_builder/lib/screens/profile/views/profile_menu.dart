import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:oc_demo/screens/profile/views/currencies_selection_bottomsheet.dart';
import 'package:oc_demo/screens/profile/views/language_selection_bottomsheet.dart';
import 'package:oc_demo/screens/profile/views/profile_detail_screen.dart';
import 'package:oc_demo/screens/profile/views/profile_menu_items.dart';


import '../../../common_widgets/dialog_helper.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../helper/app_localizations.dart';
import '../../../network_manager/api_client.dart';
import 'currencies_selection_bottomsheet.dart';

Widget profileMenu(
    Function logoutFunction,
    AppLocalizations? _localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool isUserLogin,
    bool isSeller,
    bool partnerApproveRequired) {
  List<ProfileMenuItems> menuItems = [];
  menuItems.clear();
  if (isUserLogin) {
    menuItems.add(ProfileMenuItems(
        id: 1,
        title: _localizations?.translate(AppStringConstant.dashboard) ?? '',
        icon: AppImages.dashboardIcon));
    menuItems.add(ProfileMenuItems(
        id: 2,
        title: _localizations?.translate(AppStringConstant.accountInfo) ?? '',
        icon: AppImages.accountInfoIcon));
    menuItems.add(ProfileMenuItems(
        id: 3,
        title: 'Saved Addresses',
        iconData: Icons.location_on,
        icon: ""));
    menuItems.add(ProfileMenuItems(
        id: 4,
        title: _localizations?.translate(AppStringConstant.allOrders) ?? '',
        icon: AppImages.ordersIcon));
    menuItems.add(ProfileMenuItems(
      id: 32,
      title: _localizations?.translate(AppStringConstant.reviews) ?? '',
      icon: AppImages.reviewIcon,
    ));
    menuItems.add(ProfileMenuItems(
        id: 5,
        title: _localizations?.translate(AppStringConstant.myWishlist) ?? '',
        icon: AppImages.wishlistsIcon));

    // menuItems.add(ProfileMenuItems(
    //     id: 6,
    //     title: _localizations?.translate(AppStringConstant.loginUSingQr) ?? '',
    //     icon: AppImages.wishlistsIcon,
    //     iconData: Icons.qr_code));
    menuItems.add(ProfileMenuItems(
        id: 7,
        title: _localizations?.translate(
                _localizations.translate(AppStringConstant.newsLetter)) ??
            '',
        icon: AppImages.wishlistsIcon,
        iconData: Icons.email));
    menuItems.add(ProfileMenuItems(
        id: 9,
        title: _localizations
                ?.translate(AppStringConstant.myDownloadableProducts) ??
            '',
        icon: AppImages.wishlistsIcon,
        iconData: Icons.download_rounded));
    menuItems.add(ProfileMenuItems(
        id: 10,
        title:
            _localizations?.translate(AppStringConstant.yourRewardPoints) ?? '',
        icon: AppImages.wishlistsIcon,
        iconData: Icons.star));
    menuItems.add(ProfileMenuItems(
        id: 11,
        title:
            _localizations?.translate(AppStringConstant.yourTransactions) ?? '',
        icon: AppImages.wishlistsIcon,
        iconData: Icons.local_atm));
    menuItems.add(ProfileMenuItems(
        id: 12,
        title: _localizations?.translate(AppStringConstant.returnn) ?? '',
        icon: AppImages.wishlistsIcon,
        iconData: Icons.reply));

    ///*partner menu*/

    if (isSeller && AppConstant.isMarketPlace) {
      menuItems.add(ProfileMenuItems(
          id: 20,
          title: _localizations?.translate(AppStringConstant.addProduct) ?? '',
          icon: AppImages.addProduct // need to change icon
          ));
      menuItems.add(ProfileMenuItems(
        id: 25,
        title: _localizations?.translate(AppStringConstant.productList) ?? '',
        icon: AppImages.productList, // need to change icon
      ));
      menuItems.add(ProfileMenuItems(
          id: 21,
          title:
              _localizations?.translate(AppStringConstant.sellerDashboards) ??
                  '',
          icon: AppImages.sellerDashboard // need to change icon
          ));

      menuItems.add(ProfileMenuItems(
          id: 22,
          title: _localizations?.translate(AppStringConstant.sellerOrder) ?? '',
          icon: AppImages.orderIcons // need to change icon
          ));

      menuItems.add(ProfileMenuItems(
          id: 23,
          title:
              _localizations?.translate(AppStringConstant.sellerReviews) ?? '',
          icon: AppImages.reviewIcon));

      menuItems.add(ProfileMenuItems(
          id: 24,
          title:
              _localizations?.translate(AppStringConstant.sellerTransition) ??
                  '',
          icon: AppImages.transaction // need to change icon
          ));
      // menuItems.add(ProfileMenuItems(
      //     id: 19,
      //     title: _localizations?.translate(AppStringConstant.sellerPage) ?? '',
      //     icon: AppImages.sellerPage // need to change icon
      // ));
    } else {
      /*if(partnerApproveRequired){
        menuItems.add(ProfileMenuItems(
            id: 13,
            title: _localizations?.translate(AppStringConstant.becomeASeller) ?? '',
            icon: AppImages.sellerDashboard));
      }*/
    }

    /*partner menu end*/
  }

  menuItems.add(ProfileMenuItems(
      id: 14,
      title: _localizations?.translate(AppStringConstant.settings) ?? '',
      icon: AppImages.settingsIcon // need to change icon
      ));
  menuItems.add(ProfileMenuItems(
      id: 15,
      title: _localizations?.translate(AppStringConstant.about) ?? '',
      icon: AppImages.accountInfoIcon // need to change icon
      ));
  menuItems.add(ProfileMenuItems(
    id: 26,
    title: _localizations?.translate(AppStringConstant.compare_product) ?? '',
    icon: AppImages.compare,
  ));

//
  if (AppConstant.isMarketPlace) {
    menuItems.add(ProfileMenuItems(
        id: 19,
        title: _localizations?.translate(AppStringConstant.sellerPage) ?? '',
        icon: AppImages.sellerPage // need to change icon
        ));
  }

  if (!isUserLogin) {
    menuItems.add(ProfileMenuItems(
        id: 5,
        title: _localizations?.translate(AppStringConstant.myWishlist) ?? '',
        icon: AppImages.wishlistsIcon));
    menuItems.add(ProfileMenuItems(
        id: 31,
        title: (_localizations?.translate(AppStringConstant.ordersAndReturns) ??
            ''),
        icon: "",
        iconData: Icons.undo));
  }

  return ListView.builder(
      shrinkWrap: true,
      itemCount: menuItems.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, i) {
        var menuItem = menuItems[i];
        return profileTiles(context, logoutFunction, menuItem, _localizations,
            setState, showSellerRequestBottomSheet, isUserLogin);
      });
}

Widget dropdownProfileTile(
    BuildContext context,
    ProfileMenuItems data,
    Function logoutFunction,
    AppLocalizations? _localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    List<ProfileMenuItems> children) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: const Color(0xFF8f889c),
        collapsedIconColor: const Color(0xFF8f889c),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFefebf8),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child: Icon(
                  data.id == 14 ? Icons.settings : Icons.info,
                  size: 19,
                  color: const Color(0xFF5232a8),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                data.title,
                style: const TextStyle(
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                  color: Color(0xFF2b2540),
                ),
              ),
            ),
          ],
        ),
        children: children
            .map((e) => expansionChildren(
                context,
                e.title,
                e.id,
                logoutFunction,
                _localizations,
                setState,
                showSellerRequestBottomSheet,
                isUserLogin,
                e.cmsData))
            .toList(),
      ),
    ),
  );
}

// Widget dropdownProfileTile(
//     BuildContext context,
//     ProfileMenuItems data,
//     Function logoutFunction,
//     AppLocalizations? _localizations,
//     VoidCallback setState,
//     VoidCallback showSellerRequestBottomSheet,
//     bool? isUserLogin,
//     List<ProfileMenuItems> children) {
//   return Theme(
//     data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//     child: ExpansionTile(
//       // leading: Padding(
//       //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
//       //   child: Icon(Icons.phone_missed),
//       // ),
//       iconColor: Theme.of(context).iconTheme.color,
//       tilePadding: EdgeInsets.zero,
//       childrenPadding: EdgeInsets.zero,
//       title: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Icon(Icons.home),
//           ),
//           Text(data.title, style: Theme.of(context).textTheme.titleLarge),
//         ],
//       ),
//       children: children
//           .map((e) => expansionChildren(
//               context,
//               e.title,
//               e.id,
//               logoutFunction,
//               _localizations,
//               setState,
//               showSellerRequestBottomSheet,
//               isUserLogin,
//               e.cmsData))
//           .toList(),
//     ),
//   );
// }

List<ProfileMenuItems> getSettingsChildren(AppLocalizations? _localizations) {
  return [
    ProfileMenuItems(
        id: 17,
        title: _localizations?.translate(AppStringConstant.language) ?? '',
        icon: "",
        iconData: Icons.language),
    // ProfileMenuItems(
    //     id: 18,
    //     title: _localizations?.translate(AppStringConstant.currency) ?? '',
    //     icon: "",
    //     iconData: Icons.money)
  ];
}

List<ProfileMenuItems> getAboutChildren() {
  var cmsList = <ProfileMenuItems>[];
  cmsList.addAll([
    ProfileMenuItems(id: 100, title: 'About Us', icon: ""),
    ProfileMenuItems(id: 101, title: 'Delivery Information', icon: ""),
    ProfileMenuItems(id: 102, title: 'Privacy Policy', icon: ""),
    ProfileMenuItems(id: 103, title: 'Terms & Conditions', icon: ""),
  ]);
  return cmsList;
}

// Widget profileTiles(
//     BuildContext context,
//     Function logoutFunction,
//     ProfileMenuItems item,
//     AppLocalizations? _localizations,
//     VoidCallback setState,
//     VoidCallback showSellerRequestBottomSheet,
//     bool? isUserLogin,
//     {double iconWidth = AppSizes.size20,
//     double? iconHeight = AppSizes.size20}) {
//   return ListTile(
//     onTap: () {
//       callBack(context, item.id, logoutFunction, _localizations, setState,
//           showSellerRequestBottomSheet, isUserLogin);
//     },
//     leading: item.iconData != null
//         ? CircleAvatar(
//             backgroundColor: AppColors.lightGray.withAlpha(50),
//             child: Icon(item.iconData!,
//                 size: iconHeight, color: Theme.of(context).iconTheme.color),
//           )
//         : CircleAvatar(
//             backgroundColor: AppColors.lightGray.withAlpha(50),
//             //backgroundColor: Colors.red,
//             child: Image.asset(
//               item.icon,
//               height: iconHeight,
//               width: iconWidth,
//               color: Theme.of(context).textTheme.titleLarge?.color,
//             ),
//           ),
//     title: item.id == 14
//         ? dropdownProfileTile(
//             context,
//             item,
//             logoutFunction,
//             _localizations,
//             setState,
//             showSellerRequestBottomSheet,
//             isUserLogin,
//             getSettingsChildren(_localizations),
//           )
//         : item.id == 15
//             ? dropdownProfileTile(
//                 context,
//                 item,
//                 logoutFunction,
//                 _localizations,
//                 setState,
//                 showSellerRequestBottomSheet,
//                 isUserLogin,
//                 getAboutChildren())
//             : Text(item.title, style: Theme.of(context).textTheme.titleLarge),
//   );
// }

Widget profileTiles(
    BuildContext context,
    Function logoutFunction,
    ProfileMenuItems item,
    AppLocalizations? _localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    {double iconWidth = AppSizes.size20,
    double? iconHeight = AppSizes.size20}) {
  Widget childWidget = item.id == 14 || item.id == 15 // Check if the item is a dropdown menu
      ? dropdownProfileTile(
          context,
          item,
          logoutFunction,
          _localizations,
          setState,
          showSellerRequestBottomSheet,
          isUserLogin,
          item.id == 14
              ? getSettingsChildren(_localizations)
              : getAboutChildren())
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: InkWell(
            onTap: () {
              callBack(context, item.id, logoutFunction, _localizations, setState,
                  showSellerRequestBottomSheet, isUserLogin);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFefebf8),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: item.iconData != null
                          ? Icon(item.iconData!,
                              size: 19,
                              color: const Color(0xFF5232a8))
                          : Image.asset(
                              item.icon,
                              height: 19,
                              width: 19,
                              color: const Color(0xFF5232a8),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                        color: Color(0xFF2b2540),
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF8f889c)),
                ],
              ),
            ),
          ),
        );

  if (isUserLogin == true) {
    if (item.id == 1) { // Dashboard is the first item in the Account section
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 14, 12, 6),
            child: Text(
              "ACCOUNT",
              style: TextStyle(
                fontFamily: 'Karla',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: Color(0xFF8f889c),
              ),
            ),
          ),
          childWidget,
        ],
      );
    } else if (item.id == 4) { // All Orders is the first item in the Orders section
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 14, 12, 6),
            child: Text(
              "ORDERS",
              style: TextStyle(
                fontFamily: 'Karla',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: Color(0xFF8f889c),
              ),
            ),
          ),
          childWidget,
        ],
      );
    }
  }

  return childWidget;
}

void callBack(
    BuildContext context,
    int id,
    Function logoutFunction,
    AppLocalizations? _localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    {FooterMenu? cmsData}) async {
  if (id > 18 && cmsData != null) {
    print("dwaasa---$id");
    Navigator.of(context).pushNamed(AppRoute.cmsPage,
        arguments: getCmsPageArguments(
            cmsData.informationId ?? "1", cmsData.title ?? ""));
  } else {
    print("dwaasa---$id");
    switch (id) {
      case 1:
        Navigator.of(context).pushNamed(AppRoute.dashboardScreen);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoute.accountInfo);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoute.addressBook);
        break;
      case 4:
        Navigator.of(context).pushNamed(AppRoute.orderList, arguments: false);
        break;
      case 5:
        if (isUserLogin ?? false) {
          Navigator.of(context).pushNamed(AppRoute.wishlist);
        } else {
          DialogHelper.wishlistConfirmationDialog(
              "${AppLocalizations.of(context)?.translate(AppStringConstant.wishlistDesc)}",
              "${AppLocalizations.of(context)?.translate(AppStringConstant.loginRequired)}",
              context,
              AppLocalizations.of(context), onConfirm: () async {
            Navigator.of(context).pushNamed(
              AppRoute.login,
              arguments: getSignInSignUpPageArgument(false, false),
            );
          });
        }

        break;
      case 6:
        Navigator.of(context).pushNamed(AppRoute.loginUsingQr);
        break;
      case 7:
        Navigator.of(context).pushNamed(AppRoute.newsLetter);
        break;
      // case 8:
      //--------------Item removed
      //   break;
      case 9:
        Navigator.of(context).pushNamed(AppRoute.downloadableProducts);
        break;
      case 10:
        Navigator.of(context).pushNamed(AppRoute.rewardScreen);
        break;
      case 11:
        Navigator.of(context).pushNamed(AppRoute.transactionScreen);
        break;
      case 12:
        Navigator.of(context).pushNamed(AppRoute.returnOrders);
        break;
      case 13:
        showSellerRequestBottomSheet();
        /* Navigator.of(context).pushNamed(AppRoute.login,
            arguments: getSignInSignUpPageArgument(false, false));*/
        break;
      case 14:
        //-----Expansion Tile Setting
        break;
      case 15:
        //-----Expansion Tile About
        break;
      case 16:
        var wkToken = await AppSharedPref.getWkToken();
        await ApiClient().logoutUser(wkToken);
        await AppSharedPref.logoutUser();
        Navigator.of(context).pushNamed(AppRoute.bottomTabBAr);
        break;
      case 17:
        showLanguageBottomSheet(context);
        break;
      case 18:
        showCurrenciesBottomSheet(context);
        break;
      case 19:
        Navigator.of(context).pushNamed(AppRoute.sellerPage);
        break;
      case 20:
        Navigator.of(context).pushNamed(AppRoute.addProduct, arguments: "");
        break;
      case 21:
        Navigator.of(context).pushNamed(AppRoute.sellerDashboard);
        break;
      case 22:
        Navigator.of(context).pushNamed(AppRoute.sellerOrders);
        break;
      case 23:
        Navigator.of(context).pushNamed(AppRoute.sellerReviews);
        break;
      case 24:
        Navigator.of(context).pushNamed(AppRoute.sellerTransition);
        break;
      case 25:
        Navigator.of(context).pushNamed(AppRoute.productList);
        break;
      case 26:
        Navigator.of(context).pushNamed(AppRoute.compareProduct);
        break;
      case 31:
        Navigator.of(context).pushNamed(AppRoute.ordersAndReturns);
        break;
      case 32:
        Navigator.of(context)
            .pushNamed(AppRoute.productReview, arguments: false);
        break;
      case 100:
        Navigator.push(context, MaterialPageRoute(builder: (_) => 
          ProfileDetailScreen(
            title: 'About Us',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Who we are", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("Abra Zylo started as a two-person operation packing orders on a kitchen table, and grew into a store that ships across the country without losing that same attention to detail. We pick every product we sell, not just what sells fastest.", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
                SizedBox(height: 20),
                Text("What we care about", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("• Honest pricing — the price you see on the product page is the price you pay.\n• Quality checked before it leaves our warehouse, not after you complain.\n• Real people answering support messages, not a bot loop.", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
              ]
            )
          )
        ));
        break;
      case 101:
        Navigator.push(context, MaterialPageRoute(builder: (_) => 
          ProfileDetailScreen(
            title: 'Delivery Information',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Delivery times", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("• Metro cities: 1–3 business days\n• Other cities & towns: 3–6 business days\n• Remote / rural pin codes: 5–8 business days", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
                SizedBox(height: 20),
                Text("Shipping charges", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("Orders above ₹499 ship free. Orders below that carry a flat ₹49 delivery fee, shown at checkout before you pay.", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
              ]
            )
          )
        ));
        break;
      case 102:
        Navigator.push(context, MaterialPageRoute(builder: (_) => 
          ProfileDetailScreen(
            title: 'Privacy Policy',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("What we collect", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("We collect the details you give us directly — name, address, phone, and payment information — plus basic usage data like pages viewed, to keep the app working smoothly and to personalize recommendations.", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
                SizedBox(height: 20),
                Text("How we use it", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("• Processing and delivering your orders\n• Sending order updates and, if you opt in, offers\n• Improving search and product recommendations", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
              ]
            )
          )
        ));
        break;
      case 103:
        Navigator.push(context, MaterialPageRoute(builder: (_) => 
          ProfileDetailScreen(
            title: 'Terms & Conditions',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Using this app", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("By creating an account or placing an order, you agree to use Abra Zylo for personal, lawful shopping only — not for resale or bulk commercial purchase without our written consent.", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
                SizedBox(height: 20),
                Text("Returns & refunds", style: TextStyle(fontFamily: 'Baloo 2', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5232a8))),
                SizedBox(height: 8),
                Text("Most items can be returned within 7 days of delivery in original condition. Refunds are issued to your original payment method within 5–7 business days of us receiving the return.", style: TextStyle(fontFamily: 'Karla', fontSize: 13.8, height: 1.65, color: Color(0xFF2b2540))),
              ]
            )
          )
        ));
        break;
      /* case 19:
        await AppSharedPref.getLoginUserData().then((value) {
          var email = value?.email;
          if (email?.isNotEmpty == true && email != "demo@webkul.com") {
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
          }
        });

        break;*/
      default:
    }
  }
}

Widget expansionChildren(
    BuildContext context,
    String title,
    int id,
    Function logoutFunction,
    AppLocalizations? _localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    FooterMenu? cmsData) {
  return InkWell(
    onTap: () {
      callBack(context, id, logoutFunction, _localizations, setState,
          showSellerRequestBottomSheet, isUserLogin,
          cmsData: cmsData);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
      child: Row(
        children: [
          const SizedBox(width: 38), // Indent to align with text above
          Expanded(
            child: Text(
              _localizations?.translate(title) ?? title,
              style: const TextStyle(
                fontFamily: 'Karla',
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                color: Color(0xFF8f889c),
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF8f889c)),
        ],
      ),
    ),
  );
}
