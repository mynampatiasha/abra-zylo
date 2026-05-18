import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/accountItemsListModel/account_items_list_model.dart';
import '../config/theme.dart';
import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';
import '../helper/exif_rotation_helper.dart';
import 'package:image_picker/image_picker.dart';
import '../helper/app_shared_pref.dart';
import '../screens/profile/bloc/profile_screen_bloc.dart';
import '../screens/profile/bloc/profile_screen_events.dart';
import '../screens/profile/bloc/profile_screen_state.dart';
import 'alert_message.dart';

class CommonBannerView extends StatefulWidget {
  CommonBannerView({Key? key}) : super(key: key);
  @override
  _CommonBannerViewState createState() => _CommonBannerViewState();
}

class _CommonBannerViewState extends State<CommonBannerView> {
  bool isLoading = false;
  String? bannerImage;
  String? profileImage;
  String name = "";
  String email = "";
  File? pickedBannerImage;
  File? pickedProfileImage;
  final ImagePicker _picker = ImagePicker();
  AppLocalizations? _localizations;
  ProfileScreenBloc? profileScreenBloc;
  @override
  void initState() {
    profileScreenBloc = context.read<ProfileScreenBloc>();
    BannerModel? userModel = mAppStoragePref.getUserData();
    bannerImage = userModel?.banner;
    profileImage = userModel?.image;
    name = userModel?.firstname ?? "";
    super.initState();
  }

  void getDetails() {
    setState(() {
      BannerModel? userModel = mAppStoragePref.getUserData();
      bannerImage = userModel?.banner;
      profileImage = userModel?.image;
      name = userModel?.firstname ?? "";
      email = userModel?.email ?? "";
    });
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
        builder: (context, currentState) {
      if (currentState is ProfileScreenLoading) {
        isLoading = true;
      } else if (currentState is AccountItemDataSuccess) {
        isLoading = false;
        if ((currentState.model.error) == 0) {
          mAppStoragePref.setUserData(currentState.model?.banner);
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            getDetails();
          });
        }
      } else if (currentState is ProfileScreenImageSuccess) {
        if ((currentState.model?.error) == 0) {
          profileScreenBloc?.add(const GetAccountItemsDataEvent());
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.model?.message ?? '', context);
          });
        } else {
          isLoading = false;
        }
      } else if (currentState is ProfileScreenError) {
        isLoading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message ?? '', context);
        });
      }
      return SizedBox(
          height: AppSizes.deviceHeight / 3,
          width: AppSizes.deviceWidth,
          child: commonBannerView(bannerImage, profileImage, name, email, () {
            setState(() {
              _showChoiceBottomSheet(context, false);
            });
          }, () {
            setState(() {
              _showChoiceBottomSheet(context, true);
            });
          }));
    });
  }

  Widget commonBannerView(
      String? bannerImage,
      String? profileImage,
      String name,
      String email,
      VoidCallback? changeBannerImage,
      VoidCallback changeProfileImage) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SizedBox(
          height: AppSizes.deviceHeight / 3,
          width: AppSizes.deviceWidth,
          child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: ApiConstant.imageUrl(bannerImage ?? ''),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: const DecorationImage(
                            image: AssetImage(
                              AppImages.dashboardImage, // AppImages.bgImage,
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: const DecorationImage(
                            image: AssetImage(
                              AppImages.dashboardImage, // AppImages.bgImage,
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      // Flutter 3.38 requires named Border.all args; zero width keeps old no-border UI.
                                      width: 0.0,
                                    )),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiConstant.imageUrl(profileImage ?? ''),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                          AppImages.avtar,
                                        )),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        image: const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              AppImages.avtar,
                                            )),
                                      ),
                                    ),
                                  ),
                                )),
                            Positioned(
                                right: 2.0,
                                child: GestureDetector(
                                  onTap: changeProfileImage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                    ),
                                    height: 28,
                                    width: 28,
                                    child: const Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.size8),
                            child: Column(
                              children: [
                                Text(
                                  name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontSize: AppSizes.size14,
                                          color: Colors.white),
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
                                          color: Colors.white),
                                ),
                                const SizedBox(
                                  height: AppSizes.size8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRoute.accountInfo);
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          4.4,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white, // Border color
                                            width: 2, // Border width
                                          ),
                                          color:
                                              AppColors.transparentBackground,
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  20.0))), // height: 25, // width: 25,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSizes.size6,
                                          horizontal: AppSizes.size6,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${_localizations?.translate(AppStringConstant.editInfo)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontSize: AppSizes.size16,
                                                    color: Colors.white),
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 10.0,
                    child: GestureDetector(
                      onTap: changeBannerImage,
                      child: Container(
                        height: 28.0,
                        width: 28.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Visibility(
            visible: isLoading,
            child: const Center(child: CircularProgressIndicator()))
      ],
    );
  }

  void _showChoiceBottomSheet(BuildContext context, bool uploadProfile) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).cardColor,
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 17, 0, 10),
                  child: Text(
                    _localizations?.translate(AppStringConstant.chooseOption) ??
                        "",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(
                      _localizations?.translate(AppStringConstant.gallery) ??
                          "",
                      style: Theme.of(context).textTheme.bodyLarge),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openGallery(context, uploadProfile);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera,
                  ),
                  title: Text(
                    _localizations?.translate(AppStringConstant.camera) ?? "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openCamera(context, uploadProfile);
                  },
                )
              ],
            ),
          );
        }); //Navigator.pop(context);
  }

  void _openCamera(BuildContext context, bool uploadProfile) async {
    Navigator.of(context).pop;
    final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: uploadProfile ? 500 : 900,
        maxHeight: uploadProfile ? 500 : 600,
        imageQuality: 60,
        requestFullMetadata: true);
    if (image != null) {
      // Rotate the image to fix the wrong rotation coming from ImagePicker File
      // FlutterExifRotation is not supported on web — skip rotation on web
      String rotatedPath = image.path;
      if (!kIsWeb) {
        // Only import and use on non-web platforms
        final rotated = await rotateImageIfNeeded(image.path);
        rotatedPath = rotated;
      }
      setState(() {
        if (uploadProfile) {
          pickedProfileImage = File(rotatedPath);
          /*final bytes = pickedProfileImage?.readAsBytesSync();
          String img64 = base64Encode(bytes!);*/ profileScreenBloc
              ?.add(ProfileScreenImageUploadEvent(
                  pickedProfileImage?.path.toString(), "profile"));
        } else {
          pickedBannerImage = File(rotatedPath);
          /*final bytes = pickedBannerImage?.readAsBytesSync();
          String img64 = base64Encode(bytes!);*/ profileScreenBloc
              ?.add(ProfileScreenImageUploadEvent(
                  pickedBannerImage?.path.toString(), "banner"));
        }
      });
    }
  }

  void _openGallery(BuildContext context, bool uploadProfile) async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: uploadProfile ? 500 : 900,
        maxHeight: uploadProfile ? 500 : 600,
        imageQuality: 60);
    setState(() {
      if (uploadProfile) {
        pickedProfileImage = File(image?.path ?? "");
        /*final bytes = pickedProfileImage?.readAsBytesSync();
        String img64 = base64Encode(bytes!);*/ profileScreenBloc
            ?.add(ProfileScreenImageUploadEvent(
                pickedProfileImage?.path.toString(), "profile"));
      } else {
        pickedBannerImage = File(image?.path ?? "");
        /*final bytes = pickedBannerImage?.readAsBytesSync();
        String img64 = base64Encode(bytes!);*/ profileScreenBloc
            ?.add(ProfileScreenImageUploadEvent(
                pickedBannerImage?.path.toString(), "banner"));
      } // Navigator.of(context).pop();
    });
  }

  Widget optionTile(String title, VoidCallback? addAction) {
    return GestureDetector(
      onTap: addAction,
      child: SizedBox(
          height: AppSizes.itemHeight,
          width: AppSizes.deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Divider()
            ],
          )),
    );
  }
}
