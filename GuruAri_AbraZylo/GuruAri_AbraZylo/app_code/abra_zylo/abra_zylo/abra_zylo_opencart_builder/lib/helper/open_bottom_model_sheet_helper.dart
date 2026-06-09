import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:oc_demo/common_widgets/bottom_sheet.dart';
import 'package:oc_demo/models/cart/cart_shipping_model.dart';
import 'package:oc_demo/models/cart/country_data_model.dart';
import 'package:oc_demo/screens/addReview/add_review_screen.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_bloc.dart';
import 'package:oc_demo/screens/cart/widgets/cart_shipping_method_widget.dart';
import 'package:oc_demo/screens/cart/widgets/estimate_shipping_taxes_widget.dart';
import 'package:oc_demo/screens/location/bloc/location_bloc.dart';
import 'package:oc_demo/screens/location/bloc/location_repository.dart';
import 'package:oc_demo/screens/location/views/place_search.dart';
import 'package:oc_demo/screens/notifications/bloc/notification_screen_repository.dart';
import 'package:oc_demo/screens/notifications/bloc/splash_screen_bloc.dart';
import 'package:oc_demo/screens/notifications/notification_screen.dart';
import '../screens/addReview/bloc/add_review_screen_bloc.dart';
import '../screens/addReview/bloc/add_review_screen_repository.dart';
import '../screens/login_signup/bloc/signin_signup_screen_bloc.dart';
import '../screens/login_signup/bloc/signin_signup_screen_repository.dart';
import '../screens/login_signup/view/create_account_screen.dart';
import '../screens/login_signup/view/signin_screen.dart';

/*
* TO open Bottom sheet for login or signup options
*
* */
void signInSignUpBottomModalSheet(
    BuildContext context, bool isSignUp, bool? isComingFromCart) {
  showMyModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => BlocProvider(
        create: (context) => SigninSignupScreenBloc(
            repository: SigninSignupScreenRepositoryImp()),
        child: (isSignUp)
            ? CreateAnAccount(isComingFromCart ?? false)
            : SignInScreen(isComingFromCart ?? false)),
  );
}
/*
* Open bottom sheet for product review
*
* */

void reviewBottomModalSheet(BuildContext context, String productName,
    String thumbNail, String productId) {
  showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => BlocProvider(
            create: (context) =>
                AddReviewScreenBloc(repository: AddReviewRepositoryImp()),
            child: AddReviewScreen(productName, thumbNail, productId),
          ));
}

/*
* To open bottom sheet for estimate shipping and tax on cart page.
* */
void openEstimateBottomSheet(BuildContext context,
    CountryDataModel countryDataModel, CartScreenBloc bloc) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          EstimateShippingAndTaxesWidget(countryDataModel, bloc));
}

/*
* To open bottom sheet for shipping method selection on cart page for estimate shipping and tax feature
* */
void openCartShippingMethodBottomSheet(BuildContext context,
    List<ShippingMethod>? shippingMethodList, CartScreenBloc bloc) {
  showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CartShippingMethodWidget(shippingMethodList, bloc));
}

void notificationBottomModelSheet(BuildContext context) {
  showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => BlocProvider(
            create: (context) => NotificationScreenBloc(
                repository: NotificationScreenRepositoryImp()),
            child: const NotificationScreen(),
          ));
}

/*void CheckoutShippingAddressModelBottomSheet(
    BuildContext context, Function(int) onTap, AddressListModel? addresses) {
  showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
            height: AppSizes.height - WidgetsBinding.instance!.window.padding.top,
            child:ShowAddressList(onTap, addresses),
          ));
}*/

/*void showSettingBottomSheet(BuildContext context) {
  showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => const SettingsBottomSheet());
}*/

void placeSearchBottomModelSheet(
    BuildContext context, Function(LatLng) callback) {
  showMyModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    context: context,
    builder: (context) => BlocProvider(
      create: (context) => LocationScreenBloc(
        repository: LocationRepositoryImp(),
      ),
      child: const PlaceSearch(),
    ),
  ).then((value) {
    if (value is LatLng) {
      callback(value);
    }
  });
}
