import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/screens/home/widgets/view_more_widget.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/generic_methods.dart';
import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';
import 'item_card_bloc/item_card_bloc.dart';
import 'item_card_bloc/item_card_event.dart';
import 'item_card_bloc/item_card_state.dart';

Widget homePageProductViewTypeFive(
    BuildContext? context,
    List<Product>? products,
    String catalogId,
    String title,
    String productCategoryType) {
  return Padding(
    padding: const EdgeInsets.only(
        left: AppSizes.size12, right: AppSizes.size12, bottom: AppSizes.size16),
    child: ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: (products?.length ?? 0).isEven
          ? products?.length
          : ((products?.length ?? 0) + 1),
      itemBuilder: (BuildContext context, int index) {
        if (index == products?.length) {
          return
              // viewMore(context,categoryId /*data[index - 1].productId ?? ""*/,
              //     products?[index - 1].name ?? "",title,productCategoryType);

              horizontalViewAll(context, catalogId, title, productCategoryType);
        } else {
          PrefetchService.preFetchProductDetails(products?[index].productId);
          return ListTypeProduct(products?[index]);
        }
      },
    ),
  );
}

class ListTypeProduct extends StatefulWidget {
  const ListTypeProduct(this.data, {Key? key}) : super(key: key);

  final Product? data;

  @override
  State<ListTypeProduct> createState() => _ListTypeProductState();
}

class _ListTypeProductState extends State<ListTypeProduct> {
  bool isWishlist = false;
  bool isLoading = true; // Var
  ItemCardBloc? itemCardBloc;

  @override
  void initState() {
    itemCardBloc = context.read<ItemCardBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCardBloc, ItemCardState>(
      builder: (context, currentState) {
        if (currentState is ItemCardInitial) {
          isLoading = true;
        } else if (currentState is ItemCardErrorState) {
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        } else if (currentState is AddProductToWishlistStateSuccess) {
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
          });
          itemCardBloc?.emit(WishlistIdleState());
          if (widget.data?.productId == currentState.productId) {
            widget.data?.wishlistStatus =
                currentState.wishListModel.wishliststatus;
          }
        }
        return buildUI();
      },
    );
  }

  Widget buildUI() {
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

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoute.productPage,
            arguments: getProductDataAttributeMap(
                widget.data?.name ?? '', widget.data?.productId ?? ''));
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        color: Theme.of(context).cardColor,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: ImageView(
                      url: widget.data?.thumb,
                      width: (AppSizes.deviceWidth / 3.5) - AppSizes.size4,
                      height: (AppSizes.deviceWidth / 3) - AppSizes.size4,
                    ),
                  ),
                  widgetSpace(1),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                widget.data?.price ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: AppSizes.size16,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    if (await AppSharedPref.isLogin()) {
                                      itemCardBloc?.add(AddToWishlistEvent(
                                          widget.data?.productId));
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
                                              getSignInSignUpPageArgument(
                                                  false, false),
                                        );
                                      });
                                      /*  Navigator.of(context).pushNamed(
                                AppRoute.login,
                                arguments:
                                    getSignInSignUpPageArgument(false, false),
                              );*/
                                    }
                                  },
                                  icon: Icon(
                                    widget.data?.wishlistStatus ?? false
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: widget.data?.wishlistStatus ?? false
                                        ? AppColors.red
                                        : AppColors.lightGray,
                                    size: widget.data?.wishlistStatus ?? false
                                        ? AppSizes.size27
                                        : AppSizes.size27,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   widget.data?.price ?? "",
                        //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        //     fontSize:18,
                        //     fontWeight: FontWeight.bold
                        //   ),
                        // ),
                        // widgetSpace(),
                        Text(widget.data?.name ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: AppSizes.size14)),
                        widgetSpace(),
                        Visibility(
                          visible: ((widget.data?.rating ?? 0) > 0),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                    5,
                                    (index) => _buildStar(context, index,
                                        (widget.data?.rating ?? 0)))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // widgetSpace(),
          ],
        ),
      ),
    );
  }
}

Widget horizontalViewAll(BuildContext context, String catalogId, String title,
    String productCategoryType) {
  return Container(
      //height: 30,
      //color: Colors.amber,
      //  height: (AppSizes.deviceWidth / 2.5),
      //   child: GestureDetector(
      //     onTap: () {
      //       Navigator.of(context).pushNamed(
      //         AppRoute.catalog,
      //         arguments: categoryMap(
      //           catalogId,
      //           title ?? "",
      //           productCategoryType ?? "",
      //           false,
      //         ),
      //       );
      //     },
      //
      //     // child: Card(
      //     //     color: Theme.of(context).cardColor,
      //     //     child: Center(
      //     //       child: Column(
      //     //         crossAxisAlignment: CrossAxisAlignment.center,
      //     //         mainAxisAlignment: MainAxisAlignment.center,
      //     //         children: [
      //     //           const Icon(
      //     //             Icons.arrow_right,
      //     //             size: 30,
      //     //           ),
      //     //           const SizedBox(
      //     //             height: AppSizes.size8,
      //     //           ),
      //     //           Text(
      //     //             GenericMethods.getStringValue(
      //     //                 context, AppStringConstant.viewAll),
      //     //             style: Theme.of(context).textTheme.titleLarge,
      //     //           )
      //     //         ],
      //     //       ),
      //     //     )),
      //   )
      );
}
