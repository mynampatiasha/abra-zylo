import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/helper/generic_methods.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/image_view.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../models/base_model.dart';
import '../../models/compare_products/compare_product_model.dart';
import '../../models/productDetail/add_product_wishlist_model.dart';
import '../productDetail/widget/review/rating_container.dart';
import 'bloc/compare_product_bloc.dart';
import 'bloc/compare_product_events.dart';
import 'bloc/compare_product_state.dart';

class CompareProducts extends StatefulWidget {
  @override
  _CompareProductsState createState() => _CompareProductsState();
}

class _CompareProductsState extends State<CompareProducts> {
  CompareProduct? compareProductModel;
  BaseModel? baseModel;
  AddProductToWishListModel? wishlistModel;
  CompareProductBloc? _compareProductBloc;
  AppLocalizations? _localizations;
  bool isLoading = false;
  bool? addedToWishlist;
  int? cartCount = 0;
  @override
  void initState() {
    _compareProductBloc = context.read<CompareProductBloc>();
    _compareProductBloc?.emit(CompareProductInitial());
    _compareProductBloc?.add(const CompareProductDataFetchEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(
            "${_localizations?.translate(AppStringConstant.compare_product.localized() ?? '')}",
            context),
        body: BlocBuilder<CompareProductBloc, CompareProductState>(
            builder: (context, currentState) {
          if (currentState is CompareProductInitial) {
            isLoading = true;
          } else if (currentState is CompareProductSuccess) {
            isLoading = false;
            compareProductModel = currentState.model;
          } else if (currentState is CompareProductError) {
            isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(currentState.message ?? '', context);
            });
          } else if (currentState is AddToWishlistStates) {
            isLoading = false;
            wishlistModel = currentState.baseModel;
            addedToWishlist = currentState.baseModel?.wishliststatus;
            if ((compareProductModel
                    ?.compareProductList?[currentState.position ?? 0]
                    .wishlist_status) ==
                true) {
              compareProductModel
                  ?.compareProductList?[currentState.position ?? 0]
                  .wishlist_status = false;
            } else {
              compareProductModel
                  ?.compareProductList?[currentState.position ?? 0]
                  .wishlist_status = true;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showSuccess(
                  currentState.baseModel?.message ?? '', context);
            });
          } else if (currentState is RemoveFromCompareStateSuccess) {
            isLoading = false;
            _compareProductBloc?.add(const CompareProductDataFetchEvent());
          } else if (currentState is AddProductToCartSuccess) {
            isLoading = false;

            cartCount = int.parse(currentState.baseModel.cartTotal!);
            AppSharedPref.setCartCount(currentState.baseModel.cartTotal!);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showSuccess(
                  currentState.baseModel.message ?? '', context);
            });
          }
          return _buildUI();
        }));
  }

  Widget _buildUI() {
    return SafeArea(
      child: Stack(
        children: [
          Visibility(
            child: (compareProductModel?.compareProductList?.isNotEmpty == true)
                ? compareView(context)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          compareProductModel?.message ?? "",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoute.bottomTabBAr,
                              (route) => false,
                            );
                          },

                          child: Text(
                              AppStringConstant.continueShopping.localized()),
                          // style: ElevatedButton.styleFrom(
                          //     backgroundColor: Theme.of(context).textTheme.headlineMedium?.color,
                        )
                      ],
                    ),
                  ),
            visible: isLoading == false,
          ),
          Visibility(visible: isLoading, child: const Loader())
        ],
      ),
    );
  }

  Widget compareView(
    BuildContext context,
  ) {
    return SingleChildScrollView(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: (AppSizes.deviceWidth / 2.5) + 130,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          compareProductModel?.compareProductList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return productDetails(
                            context,
                            compareProductModel?.compareProductList?[index],
                            _compareProductBloc!,
                            index);
                      }),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: (compareProductModel?.compareProductList ?? [])
                      .map((e) => productAttributes(
                          context, e, compareProductModel?.compareProductList))
                      .toList(),
                )
              ],
            )));
  }
}

productDetails(BuildContext context, CompareProductData? productData,
    CompareProductBloc compareProductBloc, int index,
    {Function? removeCallBack, Function? detailsCallBack}) {
  double imageSize = (AppSizes.deviceWidth / 2.5) - AppSizes.linePadding;

  return SizedBox(
    width: imageSize + 20,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context).dividerColor,
              )),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => BlocProvider(
                  //       create: (context) => ProductScreenBloc(
                  //         repository: ProductScreenRepositoryImp(),
                  //       ),
                  //       child: ProductScreen(
                  //           productData?.productId, productData?.name),
                  //     ),
                  //   ),
                  // );
                },
                child: Stack(children: <Widget>[
                  Center(
                    child: ImageView(
                      fit: BoxFit.contain,
                      url: productData?.popup,
                      width: imageSize!,
                      height: imageSize!,
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                            (productData?.price ?? '').isNotEmpty
                                ? productData?.price ?? ''
                                : '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 14)),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                            visible:
                                (productData?.oldPrice?.isNotEmpty ?? false),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: AppSizes.linePadding,
                                ),
                                Text(productData?.oldPrice ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.lineThrough)),
                              ],
                            )),
                        const Spacer(),
                        // if (productData?.displayAddtocart == null) ...[
                        InkWell(
                            onTap: () {
                              // if (productData?.displayAddtocart == "1") {
                              compareProductBloc.add(AddProductToCartEvent(
                                  productData?.productId.toString() ?? "",
                                  "1",
                                  ""));
                              // }
                            },
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 18,
                            )),
                        // ]
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.size4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(productData?.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 14)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.size4,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 35,
                            child: RatingContainer(double.parse(
                                productData?.rating.toString()! == ""
                                    ? "0.0"
                                    : productData?.rating.toString() ??
                                        "" ??
                                        "0.0"))),
                        const SizedBox(width: 8), // Small gap
                        Expanded(
                          child: Text(
                            AppStringConstant.reviews.localized(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis, // Prevent overflow
                            maxLines: 1, // Keep it in a single line
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: IconButton(
            icon: const Icon(Icons.cancel),
            color: Colors.grey[400],
            onPressed: () {
              compareProductBloc.add(RemoveFromCompareEvent(
                  productData?.productId.toString(), index, "delete"));
            },
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: Icon(
              (productData?.wishlist_status == true)
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: (productData?.wishlist_status == true)
                  ? AppColors.red
                  : AppColors.lightGray,
              size: 22,
            ),
            color: Colors.grey[400],
            onPressed: () async {
              if (await AppSharedPref.isLogin()) {
                compareProductBloc.emit(CompareProductInitial());
                compareProductBloc.add(AddToWishlistEvent(
                    productData?.productId.toString() ?? '', index));
              } else {
                AlertMessage.showWarning(
                  "You have to login to perform this action",
                  context,
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}

/******* Product description ***/
Widget productAttributes(
  BuildContext context,
  CompareProductData? productAttribute,
  List<CompareProductData>? compareProduct,
) {
  double imageSize = (AppSizes.deviceWidth / 2.5) - AppSizes.linePadding;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
          width: imageSize + 20,
          padding: const EdgeInsets.all(AppSizes.size8),
          child: Text(
              GenericMethods.getStringValue(
                      context, AppStringConstant.product_information) ??
                  '',
              style: Theme.of(context).textTheme.titleLarge)),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    // height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    width: imageSize + 20,
                    padding: const EdgeInsets.all(AppSizes.size8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: AppSizes.size4,
                        ),
                        if (productAttribute?.manufacturer?.isNotEmpty ?? false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppStringConstant.manufacturer.localized()} : ",
                                style: TextStyle(
                                    color: AppColors.gray,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                              ),
                              Text(
                                "${productAttribute?.manufacturer ?? ''}",
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                              )
                            ],
                          ),
                        const SizedBox(
                          height: AppSizes.size4,
                        ),
                        //Model Text
                        if (productAttribute?.model?.isNotEmpty ?? false)
                          Row(
                            children: [
                              Text("${AppStringConstant.model.localized()} : ",
                                  style: TextStyle(
                                      color: AppColors.gray,
                                      fontWeight: FontWeight.w400)),
                              Expanded(
                                child: Text("${productAttribute?.model ?? ''}",
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              )
                            ],
                          ),
                        const SizedBox(
                          height: AppSizes.size4,
                        ),
                        //Model Text
                        if (productAttribute?.tax?.isNotEmpty ?? false)
                          Row(
                            children: [
                              Text("${AppStringConstant.tax.localized()} : ",
                                  style: TextStyle(
                                      color: AppColors.gray,
                                      fontWeight: FontWeight.w400)),
                              Text("${productAttribute?.tax ?? ''}",
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                      ],
                    )

                    // Html(
                    //   data: productAttribute?.descriptionShort ?? '',
                    //   style: {
                    //     "*": Style(
                    //       fontSize: FontSize(14.0),
                    //       color: Theme.of(context).textTheme.bodyLarge?.color,
                    //       // fontWeight: FontWeight.bold,
                    //     ),
                    //   },
                    // )
                    )
              ],
            ),
          ],
        ),
      ),
      Container(
          width: imageSize + 20,
          padding: const EdgeInsets.all(AppSizes.size8),
          child: Text(
            AppStringConstant.description.localized() ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          )),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                width: imageSize + 20,
                padding: const EdgeInsets.all(AppSizes.size8),
                child: SingleChildScrollView(
                  child: Html(
                    data: productAttribute?.description ?? '',
                    style: {
                      "*": Style(
                        fontSize: FontSize(14.0),
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        // fontWeight: FontWeight.bold,
                      ),
                    },
                  ),
                ))
          ],
        ),
      ),
    ],
  );
}

Widget emptyList(BuildContext context) {
  return const Center(
      /*   child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.compare_arrows_outlined,
          size: 160,
        ),
        // Text(Utils.getStringValue(context, Utils.getStringValue(context, AppStringConstant.emptyCompareTitle)), style:  Theme.of(context).textTheme.headlineMedium,),
      ],
    ),*/
      );
}
