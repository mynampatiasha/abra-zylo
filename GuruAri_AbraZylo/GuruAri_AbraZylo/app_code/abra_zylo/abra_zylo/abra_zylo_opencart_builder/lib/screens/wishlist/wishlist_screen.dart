import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/badge_icon.dart';
import 'package:oc_demo/common_widgets/dialog_helper.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/lottie_animation.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/wishlist/get_wish_list.dart';
import 'package:oc_demo/models/wishlist/wishlist_datum.dart';
import 'package:oc_demo/screens/checkout/order_review/bloc/order_review_screen_state.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_bloc.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_event.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_state.dart';

import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../helper/app_shared_pref.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  AppLocalizations? _localizations;
  GetWishlist? wishlistModel;
  bool isLoading = true;
  bool isAction = false;
  WishlistScreenBloc? wishlistScreenBloc;
  int? cartCount = 0;

  @override
  void initState() {
    AppSharedPref.getCartCount().then((value) {
      cartCount = int.parse(value);
      TabbarController.countController.sink.add(cartCount ?? 0);
      setState(() {});
    });
    wishlistScreenBloc = context.read<WishlistScreenBloc>();
    wishlistScreenBloc?.add(WishlistDataFetchEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(
            _localizations?.translate(AppStringConstant.wishList) ?? "",
            context,
            actions: [
              IconButton(
                  onPressed: () {
                    DialogHelper.shareWishlistDialog(context, _localizations,
                        onConfirm: (value) async {
                      wishlistScreenBloc
                          ?.add(ShareWishlistCollectionEvent(value));
                    });
                  },
                  icon: const Icon(Icons.share, color: MobikulTheme.iconColor)),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.cart);
                  },
                  icon: BadgeIcon(
                    icon: const Icon(Icons.shopping_cart,
                        color: MobikulTheme.iconColor),
                    badgeCount: cartCount ?? 0,
                  )),
            ]),
        body: BlocBuilder<WishlistScreenBloc, WishlistState>(
            builder: (context, currentState) {
          if (currentState is WishlistInitialState) {
            isLoading = true;
          } else if (currentState is WishlistScreenSuccess) {
            isLoading = false;
            isAction = false;
            wishlistModel = currentState.wishlistModel;
          } else if (currentState is WishlistActionState) {
            isAction = true;
          } else if (currentState is MoveToCartSuccess) {
            isLoading = false;
            cartCount = int.parse(currentState.baseModel?.cartTotal ?? "0");
            AppSharedPref.setCartCount(
                currentState.baseModel?.cartTotal ?? "0");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
              AlertMessage.showSuccess(
                  currentState.baseModel?.message ?? '', context);
            });
            wishlistScreenBloc?.add(WishlistDataFetchEvent());
            wishlistScreenBloc?.emit(emptyState());
          } else if (currentState is RemoveItemSuccess) {
            isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showSuccess(
                  currentState.baseModel?.message ?? '', context);
            });
            wishlistScreenBloc?.add(WishlistDataFetchEvent());
            wishlistScreenBloc?.emit(emptyState());
          } else if (currentState is WishlistShareCollectionSuccess) {
            isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showSuccess(
                  currentState.baseModel?.message ?? '', context);
            });
          } else if (currentState is WishlistScreenError) {
            isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(currentState.message ?? '', context);
            });
          }
          return SafeArea(child: buildUI(wishlistModel?.wishlistData, context));
        }));
  }

  Widget buildUI(List<WishlistDatum>? items, BuildContext context) {
    return isLoading
        ? Loader()
        : Visibility(
            visible: wishlistModel != null,
            child: (wishlistModel?.wishlistData ?? []).isEmpty ||
                    wishlistModel?.wishlistData?.length == 0
                ? LottieAnimation(
                    lottiePath: AppImages.emptyWishlistLottie,
                    title: _localizations
                            ?.translate(AppStringConstant.noProductAvailable) ??
                        "",
                    subtitle: _localizations
                            ?.translate(AppStringConstant.noProductAvailable) ??
                        "",
                    buttonTitle: _localizations
                            ?.translate(AppStringConstant.continueShopping) ??
                        "",
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoute.bottomTabBAr, (route) => false);
                    })
                : Padding(
                    padding: const EdgeInsets.all(AppSizes.size8),
                    child: buildWishlistView(items, context)));
  }

  Widget buildWishlistView(List<WishlistDatum>? items, BuildContext context) {
    return Stack(children: [
      GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.size8,
              crossAxisSpacing: AppSizes.size8,
              childAspectRatio: 0.60),
          itemCount: items?.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Theme.of(context).cardColor,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoute.productPage,
                      arguments: getProductDataAttributeMap(
                          items?[index].name ?? '',
                          items?[index].productId ?? ''));
                },
                child: Stack(children: [
                  Container(
                    //  color: AppColors.white,
                    // decoration: BoxDecoration(
                    //     color:AppColors.white,
                    //     border: Border.all(color: Theme.of(context).dividerColor)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImageView(
                                  url: items?[index].thumb.toString(),
                                  height: AppSizes.deviceWidth / 2.3,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.size10,
                                    vertical: AppSizes.linePadding),
                                child: Text(
                                  items?[index].price ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.size10,
                                      vertical: AppSizes.linePadding),
                                  child: Text(
                                    items?[index].name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: AppSizes.size12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSizes.linePadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: AppSizes.deviceWidth,
                                    height: AppSizes.size40,
                                    child: TextButton(
                                        onPressed: () {
                                          if (items?[index].hasOption ==
                                              false) {
                                            wishlistScreenBloc
                                                ?.emit(WishlistActionState());
                                            wishlistScreenBloc?.add(
                                                MoveToCartEvent(
                                                    items?[index].productId ??
                                                        "",
                                                    "1",
                                                    "[]"));
                                          } else {
                                            Navigator.of(context).pushNamed(
                                                AppRoute.productPage,
                                                arguments:
                                                    getProductDataAttributeMap(
                                                        items?[index].name ??
                                                            '',
                                                        items?[index]
                                                                .productId ??
                                                            ''));
                                          }
                                        },
                                        child: Text(
                                          _localizations?.translate(
                                                  AppStringConstant
                                                      .addToCart) ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: AppSizes.size10,
                      right: AppSizes.size10,
                      child: GestureDetector(
                        onTap: () {
                          DialogHelper.confirmationDialog(
                              AppStringConstant.removeItemFromWishlist,
                              context,
                              _localizations, onConfirm: () {
                            wishlistScreenBloc?.emit(WishlistActionState());
                            wishlistScreenBloc?.add(RemoveItemEvent(
                                items?[index].productId ?? "0"));
                          });
                        },
                        child: Card(
                          color: Theme.of(context).cardColor,
                          borderOnForeground: true,
                          elevation: 2,
                          shadowColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            side: BorderSide(
                              color: AppColors.dividerColor,
                              width: 1.0,
                            ),
                          ),
                          /*height: AppSizes.size22,
                          width: AppSizes.size22,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.size20),
                              border: Border.all(
                                color:AppColors.white*/ /* Theme.of(context).colorScheme.onPrimary*/ /*,
                              )),*/
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.close,
                              size: AppSizes.size18,
                            ),
                          ),
                        ),
                      ))
                ]),
              ),
            );
          }),
      Center(
          child: Visibility(
        visible: isAction,
        child: Loader(),
      )),
    ]);
  }
}
