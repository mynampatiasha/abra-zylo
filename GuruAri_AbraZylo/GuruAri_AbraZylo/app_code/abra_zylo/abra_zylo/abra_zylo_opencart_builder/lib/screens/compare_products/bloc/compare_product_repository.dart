import 'package:oc_demo/constants/arguments_map.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/base_model.dart';
import '../../../models/compare_products/compare_product_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../network_manager/api_client.dart';

abstract class CompareProductRepository {
  Future<CompareProduct?> getCompareProductDetails();

  Future<BaseModel?> removeFromCompare(String productId);

  Future<BaseModel?> addProductToCart(
      String productId, String quantity, String productOption);

  Future<AddProductToWishListModel> addRemoveWishlistProduct(
      String productId, String productAttributeId);
}

class CompareProductRepositoryImp extends CompareProductRepository {
  @override
  Future<CompareProduct?> getCompareProductDetails() async {
    CompareProduct? model =
        await ApiClient().getCompareProducts(await AppSharedPref.getWkToken());
    return model;
  }

  ///****AddToWishList**//
  @override
  Future<AddProductToWishListModel> addRemoveWishlistProduct(
      String productId, String productAttributeId) async {
    AddProductToWishListModel? model = await ApiClient()
        .addProductToWishlist(productId, await AppSharedPref.getWkToken());
    return model;
  }

  /// ****RemoveFromCompare*/*
  @override
  Future<BaseModel?> removeFromCompare(String productId) async {
    var responseData = await ApiClient()
        .removeCompareProduct(productId, await AppSharedPref.getWkToken());
    return responseData;
  }

  /// ****Add to Cart*/*
  @override
  Future<BaseModel?> addProductToCart(
      String productId, String quantity, String productOption) async {
    BaseModel model = await ApiClient().addToCart(
        productId,
        quantity,
        optionValues.toString(),
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken());
    return model;
  }
}
