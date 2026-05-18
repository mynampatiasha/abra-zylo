import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/productDetail/add_product_wishlist_model.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';
import '../../../network_manager/api_client.dart';

abstract class ProductDetailRepository {
  Future<ProductDetailScreenModel?> getProductDetail(
      String productId, String profile_page, String etag);
  Future<ProductDetailScreenModel?> getProductDetailFromDb(
      String productId, String profile_page);
  Future<BaseModel?> addProductReview(
      String name, String productId, String reviewComment, String Rating);
  Future<ReviewData?> getProductReview(String productId, String page);
  Future<BaseModel?> addProductToCart(String productId, String quantity,
      String /*Map<String, String>?*/ productOption);
  Future<AddProductToWishListModel?> addProductToWishList(String productId);

  Future<BaseModel?> addCompareProduct(String productId);
}

class ProductDetailRepositoryImp implements ProductDetailRepository {
  @override
  Future<ProductDetailScreenModel?> getProductDetailFromDb(
      String productId, String profile_page) async {
    ProductDetailScreenModel? productDetailScreenModel;

    await HiveService.getHive()
        .isExists(boxName: HiveConstant.productPageBox + productId)
        .then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(HiveConstant.productPageBox + productId)
            .then((value) {
          if (value is ProductDetailScreenModel) {
            print("pankaj getHomeDataFromDb()-- " + "${value}");
            productDetailScreenModel = value as ProductDetailScreenModel;
          }
        });
      }
    });

    return productDetailScreenModel;
  }

/*
* Method to call get product detail api
*
* */
  @override
  Future<ProductDetailScreenModel?> getProductDetail(
      String productId, String profilePage, String etag) async {
    final box = await Hive.openBox('productBox');

    // Use productId as unique key
    final cachedJson = box.get('product_$productId');
    ProductDetailScreenModel? cachedModel;

    if (cachedJson != null) {
      try {
        cachedModel = ProductDetailScreenModel.fromJson(jsonDecode(cachedJson));
      } catch (e) {
        print("Error decoding product cache: $e");
      }
    }

    try {
      ProductDetailScreenModel? model = await ApiClient().getProductDetail(
        AppSizes.deviceWidth.toString(),
        productId,
        profilePage,
        await AppSharedPref.getWkToken(),
        etag,
      );

      if (model != null) {
        final rawJson = jsonEncode(model.toJson());
        print("Raw product Data:- ${rawJson}");
        await box.put('product_$productId', rawJson);
        return model;
      }

      return cachedModel;
    } catch (e) {
      print("API call failed, using cached data if available: $e");
      return cachedModel;
    }
  }

  /*
  *
  * Method to call api to add review for any products
  * */
  @override
  Future<BaseModel?> addProductReview(String name, String productId,
      String reviewComment, String Rating) async {
    BaseModel model = await ApiClient().writeReview(name, reviewComment, Rating,
        productId, await AppSharedPref.getWkToken());
    return model;
  }

  /*
  *
  * Method to get list of reviews for any product
  * */
  @override
  Future<ReviewData?> getProductReview(String productId, String page) async {
    ReviewData model = await ApiClient().getProductReviewList(
        await AppSharedPref.getWkToken(),
        productId,
        page,
        AppConstant.productReviewLimit);
    return model;
  }

  /*
  *
  * Method to add Product to cart
  *
  * */
  @override
  Future<BaseModel?> addProductToCart(
      String productId, String quantity, String productOption) async {
    BaseModel model = await ApiClient().addToCart(
        productId,
        quantity,
        productOption,
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken());
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

  @override
  Future<BaseModel?> addCompareProduct(String productId) async {
    BaseModel model = await ApiClient()
        .addCompareProduct(productId, await AppSharedPref.getWkToken());
    return model;
  }
}
