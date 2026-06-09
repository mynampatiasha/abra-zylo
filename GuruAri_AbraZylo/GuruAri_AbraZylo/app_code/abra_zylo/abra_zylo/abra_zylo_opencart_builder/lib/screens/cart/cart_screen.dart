import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/open_bottom_model_sheet_helper.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import 'package:oc_demo/screens/cart/widgets/cart_main_view.dart';
import 'package:oc_demo/screens/cart/widgets/guest_bottom_sheet.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/common_order_button.dart';
import '../../common_widgets/dialog_helper.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/lottie_animation.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/global_data.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../models/base_model.dart';
import 'bloc/cart_screen_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  AppLocalizations? _localizations;
  bool isLoading = false;
  CartModel? cartModel;
  CartScreenBloc? cartScreenBloc;
  BaseModel? baseModel;

  @override
  void initState() {
    cartScreenBloc = context.read<CartScreenBloc>();
    cartScreenBloc?.add(const CartScreenDataFetchEvent());
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
          _localizations?.translate(AppStringConstant.cart) ?? "", context,
          actions: [
            IconButton(
                onPressed: () async {
                  //Navigator.of(context).pushNamed(AppRoute.wishlist);
                  /*
                    * WishList labelLarge functionality
                    *
                    * */

                  if (await AppSharedPref.isLogin() == true) {
                    Navigator.of(context).pushNamed(AppRoute.wishlist);
                  } else {
                    DialogHelper.confirmationDialog(
                        "${_localizations?.translate(AppStringConstant.signInToContinue)}",
                        context,
                        _localizations, onConfirm: () async {
                      Navigator.of(context).pushNamed(
                        AppRoute.login,
                        arguments: getSignInSignUpPageArgument(false, false),
                      );
                    });
                  }
                },
                icon: const Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                ))
          ]),
      body: SafeArea(
        child: BlocBuilder<CartScreenBloc, CartScreenState>(
          builder: (context, currentState) {
            if (currentState is CartScreenStateInitial) {
              isLoading = true;
            } else if (currentState is CartScreenSuccess) {
              isLoading = false;
              cartModel = currentState.data;
              /* var model = AppSharedPref().getUserData();
              model?.cartCount = cartModel?.cartCount;
              AppSharedPref().setUserData(model);*/

              // Update Cart Count
              TabbarController.countController.sink
                  .add(cartModel?.cart?.totalProducts ?? 0);
              AppSharedPref.setCartCount(
                  cartModel?.cart?.totalProducts?.toString() ?? "0");
            } else if (currentState is RemoveCartItemSuccess) {
              baseModel = currentState.data;
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is EmptyCartSuccess) {
              isLoading = false;
              baseModel = currentState.data;
              //   AppSharedPref.setCartCount(currentState.data.cartTotal??'0');
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is UpdateCartSuccess) {
              baseModel = currentState.data;
              // AppSharedPref.setCartCount(currentState.data.cartTotal??'0');
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
              isLoading = false;
            } else if (currentState is ApplyVoucherSuccess) {
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is ApplyCouponSuccess) {
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is GetCountryDataStateSuccess) {
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                openEstimateBottomSheet(
                    context, currentState.data, cartScreenBloc!);
              });
            } else if (currentState is GetShippingMethodStateSuccess) {
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.pop(context);
                openCartShippingMethodBottomSheet(
                    context, currentState.data.shippingMethod, cartScreenBloc!);
              });
            } else if (currentState is ApplyShippingStateSuccess) {
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                (currentState?.data?.message?.isEmpty == true)
                    ? ""
                    : AlertMessage.showSuccess(
                        currentState?.data?.message ?? "", context);
                Navigator.pop(context);
                cartScreenBloc?.add(const CartScreenDataFetchEvent());
                cartScreenBloc?.emit(CartScreenStateInitial());
              });
            } else if (currentState is AddProductToWishlistStateSuccess) {
              /*
          * Success state call after adding product to wishlist
          * */
              //isLoading = false;
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.wishListModel.message ?? '', context);
              });
            } else if (currentState is CartScreenError) {
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showError(currentState.message ?? '', context);
              });
            }
            return buildCartUI();
          },
        ),
      ),
    );
  }

  Widget buildCartUI() {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: (cartModel != null),
          child: cartModel?.cart == 0 ||
                  (cartModel?.cart?.products ?? []).isEmpty
              ? LottieAnimation(
                  title: AppStringConstant.emptyCart.localized(),
                  buttonTitle: AppStringConstant.continueShopping.localized(),
                  lottiePath: AppImages.emptyCartLottie,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.bottomTabBAr,
                      (route) => false,
                    );
                  },
                  subtitle: AppStringConstant.noItemsInCart.localized(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          //color: Colors.red,
                          child: CartMainView(
                              cartModel, _localizations, cartScreenBloc),
                        ),
                      ),
                    ),
                    commonOrderButton(context, _localizations, getTotalAmount(),
                        () async {
                      GlobalData.cartTotal = getTotalAmount();
                      if (cartModel?.cart?.errorWarning?.isNotEmpty == true &&
                          (cartModel?.cart?.checkoutEligible ?? 0) == 0) {
                        AlertMessage.showWarning(
                            cartModel?.cart?.errorWarning ?? "", context);
                        return;
                      }
                      bool isOutOfStock = false;
                      cartModel?.cart?.products?.forEach((product) {
                        if (product.stock == false) {
                          isOutOfStock = true;
                        }
                      });
                      
                      if (isOutOfStock) {
                        AlertMessage.showWarning(
                            AppStringConstant.outOfStock.localized(), context);
                        return;
                      }

                      if (!(await AppSharedPref.isLogin())) {
                        showModalBottomSheet(
                          backgroundColor: Theme.of(context).cardColor,
                          context: context,
                          builder: (context) => GuestBottomSheet(
                              AppStringConstant.checkoutAs, cartModel?.cart),
                        );
                        return;
                      }

                      Navigator.of(context).pushNamed(AppRoute.shipping,
                          arguments: getShippingPageArgument(
                              AddAddressRequest(), "", false));
                    })
                  ],
                ),
        ),
        Visibility(
          visible: isLoading,
          child: Loader(),
        ),
      ],
    );
  }

  /*
  *
  * return total amount
  * */
  getTotalAmount() {
    String? total = "0";
    cartModel?.cart?.totals?.forEach((element) {
      if (element.title == "total" ||
          element.title == "Total" ||
          element.title == "الاجمالي النهائي") {
        total = element.text;
      }
    });
    return total;
  }
}
