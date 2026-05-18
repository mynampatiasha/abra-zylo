import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/Tabbar/bottom_tabbar.dart';
import 'package:oc_demo/common_widgets/custom_loader.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_state.dart';
import 'package:oc_demo/screens/productDetail/widget/load_product_options.dart';
import 'package:oc_demo/screens/productDetail/widget/product_basic_details_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_add_to_cart_button.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_description_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_discount_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_feature_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_image_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_quantity_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_details_related_products_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/badge_icon.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../hive/hive_constant.dart';
import '../../hive/hive_service.dart';
import '../../main.dart';
import '../../models/homPage/home_screen_model.dart';
import '../../utils/helper.dart';

class ProductDetailScreen extends StatefulWidget {
  Map<String, dynamic> arguments;

  ProductDetailScreen(this.arguments, {Key? key}) : super(key: key);
  // final ProductDetailScreenModel? product;
  // bool addedToWishlist = false;
  // ProductDetailBloc? productPageBloc;

  // ProductPageBasicDetailsWidget(this.addedToWishlist, this.productPageBloc,
  //     {Key? key, this.product})
  //     : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with RouteAware {
  ScrollController? _scrollController;
  ProductDetailBloc? productPageBloc; //Product page bloc
  ProductDetailScreenModel? productPageData; //Product detail model reference
  AppLocalizations? _localizations; //
  bool isLoading = false; // Use to show loader
  int? quantityCounter =
      1; // Counter use to increment and decrement product quantity
  int? minimumeCount =
      1; // Counter use to increment and decrement product quantity
  bool? addedToWishlist = false; // variable used to change wishlist icon.
  Map<String, dynamic>?
      selectedProductOptions; // used to store selected custom options data if product have custom options.
  int? cartCount = 0;
  bool isUserLogin = false;
  String? productID;
  bool isScrollingAddToCartButtonVisible = false;
  double visibilityOffset = 0;
  double bottomBarButtonVisibilityOffset = 0;
  String? productId1;
  int? index1;

  @override
  void initState() {
    AppSharedPref.getCartCount().then((value) {
      cartCount = int.parse(value);
      TabbarController.countController.sink.add(cartCount ?? 0);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    AppSharedPref.isLogin().then((value) {
      if (value) {
        setState(() {
          isUserLogin = true;
        });
      }
    });
    productID = widget.arguments[productIdKey];
    productPageBloc = context.read<ProductDetailBloc>();
    //call product detail api
    productPageBloc?.add(GetProductDetailEvent(widget.arguments[productIdKey]));
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    productPageBloc?.add(GetProductDetailEvent(widget.arguments[productIdKey]));
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  void _scrollListener() {
    if (_scrollController?.position.userScrollDirection ==
        ScrollDirection.reverse) {
      print("reveres  ${visibilityOffset}");
      if (visibilityOffset > 0.0) {
        setState(() {
          isScrollingAddToCartButtonVisible = true;
        });
      }
    }
    if (_scrollController?.position.userScrollDirection ==
        ScrollDirection.forward) {
      print("forward  $visibilityOffset");
      if (visibilityOffset < 1.0) {
        setState(() {
          isScrollingAddToCartButtonVisible = false;
        });
      } /*else if(){

      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductDetailBloc, ProductDetailScreenState>(
          builder: (context, currentState) {
        if (currentState is ProductDetailStateInitial) {
          // Initial state to show loader
          isLoading = true;
        } else if (currentState is ProductDetailStateSuccess) {
          /*
            * Success state call when successfully get product detail from server.
            * */
          productPageData = currentState.productDetailScreenModel;
          AppSharedPref.setProductId(productPageData?.productId ?? 0);
          AppSharedPref.setProductHasOption(
              (productPageData?.options?.length ?? 0) > 0);
          addedToWishlist = productPageData?.wishlistStatus;
          if (productPageData?.minimum?.toString().isNotEmpty ?? false) {
            minimumeCount =
                int.tryParse(productPageData?.minimum.toString() ?? "0") ?? 0;
          }
          addProductToRecentView(productPageData!);
          /* AppSharedPref.getCartCount().then((value){
              cartCount=int.parse(value);
              TabbarController.countController.sink.add(cartCount??0);
            });*/
          isLoading = false;
        } else if (currentState is AddProductToWishlistStateSuccess) {
          /*
            * Success state call after adding product to wishlist
            * */
          isLoading = false;
          addedToWishlist = currentState.wishListModel.wishliststatus;
          productPageData?.wishlistStatus =
              currentState.wishListModel.wishliststatus;

          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
          });
          productPageBloc?.emit(CompleteState());
        } else if (currentState is AddProductCompareSuccessState) {
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(currentState.model.message ?? '', context);
          });
          productPageBloc?.emit(CompleteState());
        } else if (currentState is AddProductToCartStateSuccess) {
          /*
            * Success state call when add product to cart.
            * */
          //  selectedProductOptions?.clear();
          clearDefaultSelectedValue();
          isLoading = false;
          cartCount = int.parse(currentState.baseModel.cartTotal!);
          /*
            * ToDo: currently used this to resolve below issue need to change once get appropriate solution
            *  https://git.webkul.com/pankajtyagi.mobikul528/mobikul_opencart_flutter_demo/-/issues/65
            * */
          productPageBloc?.add(GetProductDetailEvent(
            widget.arguments[productIdKey], /*productPageData?.reserveTag??*/
          ));
          AppSharedPref.setCartCount(currentState.baseModel.cartTotal!);
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.baseModel.message ?? '', context);
          });
          //selectedProductOptions?.clear();
        } else if (currentState is BuyProductStateSuccess) {
          /*
            * Success state call when when buy product
            * */
          // selectedProductOptions?.clear();
          clearDefaultSelectedValue();
          isLoading = false;
          cartCount = int.parse(currentState.baseModel.cartTotal ?? '0');
          AppSharedPref.setCartCount(currentState.baseModel.cartTotal ?? '0');
          /*
            * ToDo: currently used this to resolve below issue need to change once get appropriate solution
            *  https://git.webkul.com/pankajtyagi.mobikul528/mobikul_opencart_flutter_demo/-/issues/65
            * */
          productPageBloc?.add(GetProductDetailEvent(
            widget.arguments[productIdKey], /*productPageData?.reserveTag??*/
          ));
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.baseModel.message ?? '', context);
            Navigator.pushNamed(context, AppRoute.cart).then((value) {
              AppSharedPref.getCartCount().then((value) {
                cartCount = int.parse(value);
                TabbarController.countController.sink.add(cartCount ?? 0);
              });
              setState(() {});
            });
            ;
          });
          //selectedProductOptions?.clear();
        } else if (currentState is AddListProductToWishlistStateSuccess) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            setState(() {
              if (productId1 != "-1" && index1 != -1) {
                productPageData?.relatedProducts?[index1!].wishlistStatus =
                    currentState.wishListModel.wishliststatus;
                productId1 = "0";
                index1 = 0;
              }
            });
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
          });
          productPageBloc?.emit(CompleteState());
        } else if (currentState is AddProductReviewStateSuccess) {
          /*
            * Success state call after adding review for the product on server
            * */
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.baseModel.message ?? '', context);
          });
          Navigator.pop(context);
        } else if (currentState is ProductDetailStateError) {
          /*
            * Error state if there is error in api.
            * */
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        } else if (currentState is CompleteState) {}
        return buildProductDetailUI();
      }),
      bottomNavigationBar: /*Visibility(
        visible:isScrollingAddToCartButtonVisible==false ,
        child:ProductDetailAddToCartButtonWidget(
          productPageBloc,
          productID ?? "0",
          quantityCounter ?? 0,
          selectedProductOptions,
          productPageData?.options,
        ),
      )*/
          SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          height: isScrollingAddToCartButtonVisible
              ? 0
              : AppSizes.deviceHeight / 11,
          child: ProductDetailAddToCartButtonWidget(
            productPageBloc,
            productID ?? "0",
            quantityCounter ?? 0,
            selectedProductOptions,
            productPageData?.options,
          ),
        ),
      ),
    );
  }

/*
* Method will validate the product page data and render the view accordingly
*
*
* */
  Widget buildProductDetailUI() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: commonAppBar(
          toTitleCase(
              productPageData?.name ?? widget.arguments[productNameKey] ?? " "),
          //  productPageData?.name ?? widget.arguments[productNameKey].split(' ').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' '),
          //  productPageData?.name ?? widget.arguments[productNameKey] ?? "",
          context,
          actions: [
            //Toolbar wishlist icon
            if (isUserLogin)
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoute.wishlist);
                  },
                  icon: Icon(
                    Icons.favorite_outline,
                    color: Theme.of(context).cardColor,
                  )),
            //Toolbar cart  icon
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.cart).then((value) {
                    AppSharedPref.getCartCount().then((value) {
                      cartCount = int.parse(value);
                      TabbarController.countController.sink.add(cartCount ?? 0);
                    });
                    setState(() {});
                  });
                },
                icon: BadgeIcon(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).cardColor,
                  ),
                  badgeCount: cartCount ?? 0,
                )),
          ]),
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
                //visible: (!isLoading),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.red,
                      // color: Colors.red,
                      // color: Theme.of(context).colorScheme.background,
                      child: Column(
                        children: [
                          /*
                          * Product Image Container/ view
                          * */
                          Container(
                              // color:Colors.red,
                              // color: Theme.of(context).cardColor,
                              child: Column(
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(AppSizes.size0),
                                    child: ProductDetailsImageWidget(
                                        productPageData?.images ?? []),
                                  ),
                                  if (getArStatus())
                                    InkWell(
                                      child: const Icon(
                                          Icons.border_clear_rounded),
                                      onTap: () => startArActivity(),
                                    )
                                ],
                              ),
                              /*ProductDetailsImageWidget(
                                      productPageData?.images ?? []),*/
                              ProductPageBasicDetailsWidget(
                                addedToWishlist ?? false,
                                productPageBloc,
                                product: productPageData,
                              ),
                            ],
                          )),

                          /*
                          * Show discount widget if there is discount data for product
                          *
                          * */
                          // const Divider(),
                          if ((productPageData?.discounts?.length ?? 0) > 0)
                            ProductDiscountWidget(productPageData?.discounts),
                          widgetSpace(0, AppSizes.size8),
                          /*
                          * Show product custom option widget if there is custom option present for product.
                          * */
                          if ((productPageData?.options?.length ?? 0) > 0)
                            LoadProductCustomOptions(
                                options: productPageData?.options,
                                productOptionsSelectedByUser:
                                    (Map<String, dynamic> map) {
                                  setState(() {
                                    selectedProductOptions = map;
                                  });
                                }),
                          widgetSpace(0, AppSizes.size8),
                          /*
                          * Show quantity widget
                          * */
                          ProductDetailQuantityWidget(
                            counterChangedValue: (value) {
                              //used to return changed product quantity
                              setState(() {
                                quantityCounter = value;
                              });
                            },
                            counter: quantityCounter,
                            minimum: minimumeCount,
                          ),
                          widgetSpace(0, AppSizes.size8),
                          /*
                          * show add to cart or buy now labelLarge
                          * */
                          /*AnimatedContainer(
                          duration: Duration(milliseconds: 800),
    height: isScrollingAddToCartButtonVisible ?  AppSizes.deviceHeight /11: 0,
                        child: */
                          VisibilityDetector(
                              key: const Key("unique key"),
                              onVisibilityChanged: (VisibilityInfo info) {
                                debugPrint(
                                    "${info.visibleFraction} of my widget is visible");
                                visibilityOffset = info.visibleFraction;
                                /* if (visibilityOffset ==0.0 && _scrollController?.position.userScrollDirection ==
                                    ScrollDirection.reverse) {
                                  setState(() {
                                    isScrollingAddToCartButtonVisible = false;
                                  });}*/

                                /* setState(() {

                                });*/
                                /* if (info.visibleFraction < 1 && info.matchesVisibility(info)) {
                                setState(() {
                                  isScrollingAddToCartButtonVisible=true;
                                });
                                print("----->Visible${info.visibleBounds.bottom}");
                              } else if(info.visibleFraction < 1 && info.visibleBounds.bottom > 0){
                                setState(() {
                                  isScrollingAddToCartButtonVisible=false;
                                });
                              }else {
                                setState(() {
                                  isScrollingAddToCartButtonVisible=false;
                                });
                                print(
                                    "----->InVisible${info.visibleBounds.bottomCenter}");
                              }*/

                                if (info.visibleFraction > 0.0) {
                                  setState(() {
                                    isScrollingAddToCartButtonVisible = true;
                                  });
                                } else {
                                  setState(() {
                                    isScrollingAddToCartButtonVisible = false;
                                  });
                                }
                              },
                              child: ProductDetailAddToCartButtonWidget(
                                productPageBloc,
                                (productPageData?.productId ?? 0).toString(),
                                quantityCounter!,
                                selectedProductOptions,
                                productPageData?.options,
                              )),
                          //  ),

                          widgetSpace(0, AppSizes.size8),
                          /*
                          * show product Description
                          * */
                          ProductDetailsDescriptionWidget(
                              productPageData?.description),
                          /*
                          * Show feature widget if attribute is present for the product
                          * */

                          if ((productPageData?.attributeGroups?.length ?? 0) >
                              0)
                            ProductDetailsFeatureWidget(
                                productPageData?.attributeGroups ?? []),
                          widgetSpace(0, AppSizes.size8),

                          /*
                          * If product have review then review tile will show.
                          * */
                          if ((productPageData?.reviewData?.reviews?.length ??
                                  0) >
                              0)
                            reviewTile(),

                          /*
                          * If product have related product list size greater then 0 then show related products
                          * */
                          if ((productPageData?.relatedProducts?.length ?? 0) >
                              0)
                            ProductDetailRelatedProductsWidget(
                                productPageData?.relatedProducts,
                                (productId, index) {
                              productId1 = productId;
                              index1 = index;
                              // Your wishlist logic here
                              print(
                                  "Add to wishlist tapped: productId=$productId, index=$index");
                              productPageBloc?.add(
                                  AddListProductToWishListEvent(productId));
                            }, productPageBloc),
                          /*
                          * Bottom space
                          *
                          * */
                          const SizedBox(
                            height: AppSizes.size8,
                          ),
                        ],
                      ),
                    ))),
            Visibility(visible: isLoading, child: LoaderUtil.showCoverLoader())
          ],
        ),
      ),
    );
  }

/*
* Review tile will show if product have review more than 0
*
* */
  Widget reviewTile() {
    return GestureDetector(
      onTap: () {
        //To show all reviews on next screen
        Navigator.of(context).pushNamed(AppRoute.reviewDetails,
            arguments:
                reviewAttributeDataMap(productPageData!, productPageBloc!));
      },
      child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.size16, horizontal: AppSizes.size14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_localizations?.translate(AppStringConstant.reviews)}",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.darkGray),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.darkGray,
                size: AppSizes.size18,
              )
            ],
          )),
    );
  }

  /*
  * For Ar Products
  * */

  var methodChannel = const MethodChannel(AppConstant.channelName);

  Future startArActivity() async {
    if (!kIsWeb && Platform.isIOS) {
      Helper().downloadArData(context, productPageData?.ios_ar ?? "");

      //  Helper().downloadPersonalData(context, productPageData?.arUrl ?? "");
    } else {
      var isGranted = await Permission.storage.isGranted;
      if (isGranted) {
        try {
          var data = await methodChannel.invokeMethod("showAr", {
            "name": productPageData?.name,
            "url": productPageData?.android_ar
          });
          return data;
        } on PlatformException catch (e) {
          return "Failed to Invoke: '${e.message}'.";
        }
      } else {
        Permission.storage.request();
      }
    }

    //print("${productPageData?.isAr}");
  }

  bool getArStatus() {
    if (!kIsWeb && Platform.isAndroid &&
        (productPageData?.isAr == true) &&
        (productPageData?.android_ar ?? "").isNotEmpty) {
      return true;
    } else if (!kIsWeb && Platform.isIOS &&
        (productPageData?.isAr == true) &&
        (productPageData?.ios_ar ?? "").isNotEmpty) {
      return true;
    }
    return false;
  }

  clearDefaultSelectedValue() {
    if ((productPageData?.options?.length ?? 0) > 0) {
      if (selectedProductOptions != null &&
          (selectedProductOptions?.length ?? 0) > 0) {
        productPageData?.options?.forEach((element) {
          if ((element.value?.isEmpty ?? "" == true) &&
              (selectedProductOptions?.keys
                      .contains(element.productOptionId)) ==
                  true) {
            selectedProductOptions
                ?.remove(element.productOptionId); //clear unselected value
          }
        });
      }
    }
  }

  Future<void> addProductToRecentView(
      ProductDetailScreenModel productPageData) async {
    List<Product>? recentProductList = [];
    Product product = Product(
        productId: productPageData.productId.toString(),
        thumb: productPageData.thumb,
        dominantColor: productPageData.dominantColor,
        name: productPageData.name,
        price: productPageData.price,
        quantity: productPageData.quantity.toString(),
        special: productPageData.special,
        formattedSpecial: productPageData.formattedSpecial,
        tax: productPageData.tax,
        //rating:productPageData.rating,
        //reviews:pr,
        //hasOption:productPageData.h,
        wishlistStatus: productPageData.wishlistStatus);
    recentProductList.add(product);
    await HiveService.getHive()
        .isExists(boxName: HiveConstant.recentProduct)
        .then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(HiveConstant.recentProduct)
            .then((value) {
          //  var  recentProductList = value ;/*as List<Product>;*/

          (value as List).forEach((element) {
            if ((element as Product).productId !=
                productPageData.productId.toString())
              recentProductList.add(element as Product);
          });
          HiveService.getHive()
              .addBoxes(recentProductList, HiveConstant.recentProduct);
          //print("pankaj save recent view product()-- " + "${value}");
          //  subCategoryModel = value as SubCategoryModel;
        });
      } else {
        // recentProductList.add(product);
        await HiveService.getHive()
            .addBoxes(recentProductList, HiveConstant.recentProduct);
      }
    });
  }
}

String toTitleCase(String text) {
  if (text == null || text.isEmpty) return '';
  return text
      .split(' ')
      .map((word) => word.isEmpty
          ? ''
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
