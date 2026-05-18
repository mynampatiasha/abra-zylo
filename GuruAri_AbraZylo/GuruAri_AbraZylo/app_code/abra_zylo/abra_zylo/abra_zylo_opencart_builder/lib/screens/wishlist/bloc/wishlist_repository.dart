import 'dart:convert';

import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/wishlist/get_wish_list.dart';
import 'package:oc_demo/network_manager/api_client.dart';

import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';

abstract class WishlistRepository {
  Future<GetWishlist> getWishlistItems(String etag);

  Future<BaseModel?> moveToCart(
      String productId, String quantity, String productOption);

  Future<BaseModel> removeFromWishlist(String productId);

  Future<BaseModel> shareWishlist(String email);

  Future<GetWishlist?> getWishListFromDb();
}

class WishlistImpRepository implements WishlistRepository {
  @override
  Future<GetWishlist?> getWishListFromDb() async {
    GetWishlist? getWishlist;

    await HiveService.getHive()
        .isExists(boxName: HiveConstant.wishListModel)
        .then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(HiveConstant.wishListModel)
            .then((value) {
          if (value is GetWishlist) {
            getWishlist = value as GetWishlist;
            print("pankaj getWishListFromDb()-- " + "${value}");
          }
        });
      }
    });

    return getWishlist;
  }

  @override
  Future<GetWishlist> getWishlistItems(String etag) async {
    GetWishlist? model;
    model = await ApiClient().getWishlist(AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken(), etag);
    await HiveService.getHive().addBoxes(model, HiveConstant.wishListModel);
    return model;
  }

  @override
  Future<BaseModel?> moveToCart(
      String productId, String quantity, String productOption) async {
    BaseModel model = await ApiClient().addToCart(
        productId,
        quantity,
        productOption,
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken());
    return model;
  }

  @override
  Future<BaseModel> removeFromWishlist(String productId) async {
    BaseModel? model;
    model = await ApiClient()
        .removeFromWishlist(productId, await AppSharedPref.getWkToken());
    return model;
  }

  @override
  Future<BaseModel> shareWishlist(String email) async {
    BaseModel? model;
    model = await ApiClient()
        .sendWishlistCollection(email, await AppSharedPref.getWkToken());
    return model;
  }
}
