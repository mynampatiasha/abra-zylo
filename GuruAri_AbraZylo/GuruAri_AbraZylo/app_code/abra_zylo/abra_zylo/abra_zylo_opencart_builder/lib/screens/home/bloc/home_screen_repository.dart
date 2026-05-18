import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:oc_demo/hive/hive_constant.dart';
import 'package:oc_demo/models/productDetail/add_product_wishlist_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../hive/hive_service.dart';
import '../../../models/homPage/home_screen_model.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import '../../../network_manager/api_client.dart';

abstract class HomeScreenRepository {
  Future<HomePageData?> getHomeData(String etag);

  Future<HomePageData?> getHomeDataFromDb();

  Future<AddProductToWishListModel?> addToWishList(String productId);
  //Future<List<Product>?> getRecentProduct();
}

class HomeScreenRepositoryImp implements HomeScreenRepository {
  @override
  Future<HomePageData?> getHomeDataFromDb() async {
    HomePageData? model;
    await HiveService.getHive()
        .isExists(boxName: HiveConstant.homeBOX)
        .then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(HiveConstant.homeBOX)
            .then((value) {
          if (value is HomePageData) {
            model = value as HomePageData;
          }
        });
      }
    });

    return model;
  }

  // @override
  // Future<HomePageData?> getHomeData(String etag) async {
  // /*  var map= Map<String, String>();
  //   map[""]*/
  //   HomePageData? model = await ApiClient().getHomePage("1", AppConstant.homePageProductCount, AppSizes.deviceWidth.toInt(), await AppSharedPref.getWkToken(),etag);
  //
  //
  //   print("ABra Response ${model.toJson()}");
  //
  //
  //   // Convert to raw JSON string
  //   String rawJson = jsonEncode(model?.toJson());
  //
  //   print("ABra Raw JSON: $rawJson");
  //   final box = await Hive.openBox('homeBox');
  //   await box.put('homeData',rawJson);
  //
  //   await HiveService.getHive().isExists(boxName: "homeBox").then((value) async {
  //
  //     print("dgsggdgdfgdfgf${value}");
  //     if (value) {
  //       final box = await Hive.openBox('homeBox');
  //       String? jsonString = box.get('homeData');
  //
  //       if (jsonString != null) {
  //         HomePageData model = HomePageData.fromJson(jsonDecode(jsonString));
  //         print("Restored HomePageData: ${model.toJson()}");
  //       } else {
  //         print("No data found in Hive for 'homeData'");
  //       }
  //     }
  //   });
  //   print("ABra Response ${model.toJson()}");
  //   return model;
  // }

  Future<HomePageData?> getHomeData(String etag) async {
    final box = await Hive.openBox('homeBox');
    final cachedJson = box.get('homeData');

    HomePageData? cachedModel;
    if (cachedJson != null) {
      cachedModel = HomePageData.fromJson(jsonDecode(cachedJson));
    }

    // Fetch fresh data — let errors propagate so bloc can handle them
    HomePageData? model = await ApiClient().getHomePage(
      "1",
      AppConstant.homePageProductCount,
      AppSizes.deviceWidth.toInt(),
      await AppSharedPref.getWkToken(),
      etag,
    );

    if (model != null) {
      String rawJson = jsonEncode(model.toJson());
      await box.put('homeData', rawJson);
    }

    return model ?? cachedModel;
  }

  @override
  Future<AddProductToWishListModel?> addToWishList(String productId) async {
    AddProductToWishListModel model = await ApiClient()
        .addProductToWishlist(productId, await AppSharedPref.getWkToken());
    return model;
  }
  //
  // @override
  // Future<List<Product>?> getRecentProduct() async {
  //   List<Product>? recentProductList=[];
  //   await HiveService.getHive()
  //       .isExists(boxName: HiveConstant.recentProduct)
  //       .then((value) async {
  //     if (value) {
  //       await HiveService.getHive()
  //           .getBoxes(HiveConstant.recentProduct)
  //           .then((value) {
  //         (value as List).forEach((element) {
  //           recentProductList.add(element as Product);
  //         });
  //         //recentProductList = value as  List<Product>;
  //        // recentProductList.add(productPageData);
  //       /*  HiveService.getHive().addBoxes(
  //             recentProductList, HiveConstant.recentProduct);*/
  //         //print("pankaj save recent view product()-- " + "${value}");
  //         //  subCategoryModel = value as SubCategoryModel;
  //       });
  //     }
  //   });
  //   return recentProductList;
  // }
}
