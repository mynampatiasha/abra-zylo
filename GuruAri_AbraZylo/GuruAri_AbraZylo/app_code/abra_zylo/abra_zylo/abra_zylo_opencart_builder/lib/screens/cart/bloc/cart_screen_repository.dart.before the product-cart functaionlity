import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/cart/cart_shipping_model.dart';
import 'package:oc_demo/models/cart/country_data_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/cart/cart_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../network_manager/api_client.dart';

abstract class CartScreenRepository {
  Future<CartModel?> getCartData();

  Future<BaseModel?> removeItemFromCart(String key);

  Future<BaseModel?> updateCartData(String quantityJsonData);

  Future<BaseModel?> applyVoucher(String voucher);

  Future<BaseModel?> applyCoupon(String coupon);

  Future<BaseModel?> applyRewards(String rewards);

  Future<BaseModel?> emptyCart();
  Future<CountryDataModel?> getCountryData();
  Future<BaseModel?> applyShipping(String shippingMethod);
  Future<CartShippingModel?> getShipping(
      String countryId, String zoneId, String postCode);
  Future<AddProductToWishListModel?> addProductToWishList(String productId);
}

class CartScreenRepositoryImp implements CartScreenRepository {
  @override
  Future<CartModel?> getCartData() async {
    CartModel? model = await ApiClient().viewCart(
      AppSizes.deviceWidth.toString(),
      await AppSharedPref.getWkToken(),
    );
    return model;
  }

/*
*Api calling function to remove any item from cart
* */
  Future<BaseModel?> removeItemFromCart(String key) async {
    BaseModel? model =
        await ApiClient().removeFromCart(key, await AppSharedPref.getWkToken());
    return model;
  }

  /*
*Api calling function to update cart
* */
  @override
  Future<BaseModel?> updateCartData(String quantityJsonData) async {
    BaseModel? model = await ApiClient()
        .updateCart(quantityJsonData, await AppSharedPref.getWkToken());
    return model;
  }

  /*
*Api calling function to apply coupon on cart page
* */
  @override
  Future<BaseModel?> applyCoupon(String coupon) async {
    BaseModel? model =
        await ApiClient().applyCoupon(coupon, await AppSharedPref.getWkToken());
    return model;
  }

  /*
*Api calling function to apply voucher on cart page
* */
  @override
  Future<BaseModel?> applyVoucher(String voucher) async {
    BaseModel? model = await ApiClient()
        .applayVoucher(voucher, await AppSharedPref.getWkToken());
    return model;
  }

  /*
*Api calling function to apply rewards on cart page
* */
  @override
  Future<BaseModel?> applyRewards(String rewards) async {
    BaseModel? model = await ApiClient()
        .applyRewards(rewards, await AppSharedPref.getWkToken());
    return model;
  }

  /*
*Api calling function to empty cart/ remove all product from cart
* */
  @override
  Future<BaseModel?> emptyCart() async {
    BaseModel? model =
        await ApiClient().emptyCart(await AppSharedPref.getWkToken());
    return model;
  }

  /*-----------------------------Estimate shipping and taxes feature api methods-------------------------------------------*/
  /*
  *
  * Get Country Data
  * */
  @override
  Future<CountryDataModel?> getCountryData() async {
    print(AppSharedPref.wkToken);
    CountryDataModel? model =
        await ApiClient().getCountryData(await AppSharedPref.getWkToken());
    return model;
  }

  /*
  *
  * Get shipping  Data
  * */
  @override
  Future<CartShippingModel?> getShipping(
      String countryId, String zoneId, String postCode) async {
    CartShippingModel? model = await ApiClient().getShipping(
        await AppSharedPref.getWkToken(), zoneId, countryId, postCode);
    return model;
  }

  /*
  * Apply shipping on cart page
  *
  * */

  @override
  Future<BaseModel?> applyShipping(String shippingMethod) async {
    BaseModel? model = await ApiClient()
        .applyShipping(await AppSharedPref.getWkToken(), shippingMethod);
    return model;
  }

  /*
  *
  * Method to call api for adding/remove product to wishlist
  * */
  @override
  Future<AddProductToWishListModel?> addProductToWishList(
      String productId) async {
    AddProductToWishListModel model = await ApiClient()
        .addProductToWishlist(productId, await AppSharedPref.getWkToken());
    return model;
  }
}
