import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_bloc.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_event.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_state.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/rating_bar.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageProductCard extends StatefulWidget {
  double? imageSize;
  final Product? data;
  AppLocalizations? _localizations;
  Function(String)? wishlistCallBack;

  HomePageProductCard(
      {Key? key, this.data, this.imageSize, this.wishlistCallBack})
      : super(key: key);

  @override
  State<HomePageProductCard> createState() => _HomePageProductCardState();
}

class _HomePageProductCardState extends State<HomePageProductCard> {
  bool isWishlist = false;
  bool isLoading = true; // Var
  ItemCardBloc? itemCardBloc;

  @override
  Widget build(BuildContext ctx, {Function(String)? callback}) {
    itemCardBloc = ctx.read<ItemCardBloc>();
    widget.imageSize ??= (AppSizes.deviceWidth / 2.8) - AppSizes.size4;
    return BlocBuilder<ItemCardBloc, ItemCardState>(
      builder: (context, currentState) {
        if (currentState is ItemCardInitial) {
          isLoading = true;
        } else if (currentState is ItemCardErrorState) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        } else if (currentState is AddProductToWishlistStateSuccess) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
            itemCardBloc?.emit(WishlistIdleState());
          });
          if (widget.data?.productId == currentState.productId) {
            widget.data?.wishlistStatus =
                currentState.wishListModel.wishliststatus;
          }
        }
        return buildUi(ctx);
      },
    );
  }

  Widget buildUi(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoute.productPage,
            arguments: getProductDataAttributeMap(
                widget.data?.name ?? '', widget.data?.productId ?? ''));
      },
      child: Card(
          color: Theme.of(context).cardColor,
          child: Container(
            // color: Colors.red,
            width: AppSizes.deviceWidth / 2.1,
            // decoration: BoxDecoration(
            //     border: Border.all(
            //   color: AppColors.background,
            // )),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(alignment: Alignment.topLeft, children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: AppSizes.size8),
                    child: Center(
                      child: ImageView(
                        url: widget.data?.thumb.toString() ?? '',
                        width: widget.imageSize!,
                        height: widget.imageSize!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      right: AppSizes.size6,
                      top: AppSizes.size8,
                      child: InkWell(
                        onTap: () async {
                          if (await AppSharedPref.isLogin()) {
                            itemCardBloc?.add(
                                AddToWishlistEvent(widget.data?.productId));
                          } else {
                            DialogHelper.wishlistConfirmationDialog(
                                "${AppLocalizations.of(context)?.translate(AppStringConstant.wishlistDesc)}",
                                "${AppLocalizations.of(context)?.translate(AppStringConstant.loginRequired)}",
                                context,
                                AppLocalizations.of(context),
                                onConfirm: () async {
                              Navigator.of(context).pushNamed(
                                AppRoute.login,
                                arguments:
                                    getSignInSignUpPageArgument(false, false),
                              );
                            });
                            /* Navigator.of(context).pushNamed(
                                AppRoute.login,
                                arguments:
                                    getSignInSignUpPageArgument(false, false),
                              );*/
                          }
                          // data?.wishlistStatus=isWishList ;
                          // if (wishlistCallBack != null) {
                          //   wishlistCallBack!(data?.productId ?? "");
                          // }

                          //
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.size8),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppSizes.size16)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.background,
                                blurRadius: AppSizes.size4,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Icon(
                            //  data!.wishlistStatus==isWishlist
                            widget.data!.wishlistStatus ?? false
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: widget.data?.wishlistStatus ?? false
                                ? AppColors.red
                                : AppColors.black,
                            size: AppSizes.size16,
                          ),
                        ),
                      )),
                  if (widget.data?.special != 0)
                    const Padding(
                      padding: EdgeInsets.only(
                        left: AppSizes.size4,
                        top: AppSizes.size4,
                      ),
                      child: Card(
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.size4),
                          child: Text(
                            AppStringConstant.sale,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ]),
                Visibility(
                  visible: ((widget.data?.rating ?? 0) > 0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            5,
                            (index) => _buildStar(
                                context, index, (widget.data?.rating ?? 0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppSizes.size4, top: AppSizes.size8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // if ((widget.data?.formattedSpecial ?? "") != "" &&
                          //     (widget.data?.formattedSpecial ?? "") !=
                          //         "0") ...[
                          //   // Text(
                          //   //   widget.data?.price.toString() ?? '',
                          //   //   style: TextStyle(
                          //   //     fontSize: AppSizes.size12,
                          //   //     color: Theme.of(context).textTheme.headlineMedium!.color,
                          //   //     decoration: TextDecoration.lineThrough,
                          //   //   ),
                          //   // ),
                          //   const SizedBox(
                          //     width: AppSizes.size8,
                          //   ),
                          //
                          //   Text(
                          //     widget.data?.formattedSpecial.toString() ?? '',
                          //     style: Theme.of(context).textTheme.headlineSmall,
                          //   ),
                          // ] else ...[
                          //   const SizedBox(
                          //     width: AppSizes.size8,
                          //   ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(left: AppSizes.size8),
                          //   child: Text(
                          //     widget.data?.price ?? '',
                          //     style: Theme.of(context).textTheme.titleLarge,
                          //   ),
                          // ),
                          if ((widget.data?.formattedSpecial ?? "") != "" &&
                              (widget.data?.formattedSpecial ?? "") != "0") ...[
                            const SizedBox(
                              width: AppSizes.size8,
                            ),
                            Text(
                              widget.data?.formattedSpecial.toString() ?? '',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              width: AppSizes.size8,
                            ),
                            Text(
                              widget.data?.price.toString() ?? '',
                              style: TextStyle(
                                fontSize: AppSizes.size12,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .color,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else ...[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: AppSizes.size8),
                              child: Text(
                                widget.data?.price ?? '',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(
                              width: AppSizes.size8,
                            ),
                          ]
                        ],
                      ),
                      widgetSpace(0, 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            width: AppSizes.size8,
                          ),
                          Expanded(
                              child: Text(widget.data?.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: AppSizes.size14)

                                  // TextStyle(fontSize: AppSizes.size14, /*fontWeight: FontWeight.bold*/),
                                  // textAlign: TextAlign.center,
                                  // style: Theme.of(context).textTheme.bodyMedium),
                                  )),
                        ],
                      ),

                      //widgetSpace(),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildStar(BuildContext context, int index, int rating) {
    Icon icon;
    icon = const Icon(
      Icons.star,
      color: AppColors.yellow,
      size: 16.0,
    );
    if (rating <= index) {
      icon = const Icon(
        Icons.star_border,
        color: AppColors.yellow,
        size: 16.0,
      );
    }
    return icon;
  }
}
