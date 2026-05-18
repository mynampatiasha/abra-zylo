import 'dart:convert';

import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';

import '../../../constants/app_constants.dart';
import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../network_manager/api_client.dart';

abstract class CategoriesScreenRepository {
  Future<SubCategoryModel> getCategoriesData(String categoryId, String etag);

  Future<CatalogModel> getCatalogProducts(
      CatalogProductRequest request, String etag);

  Future<SubCategoryModel?> getCategoriesDataFromDb(String categoryId);

  Future<CatalogModel?> getCatalogProductsFromDb(CatalogProductRequest request);
  Future<AddProductToWishListModel?> addToWishList(String productId);
}

class CategoriesScreenRepositoryImp implements CategoriesScreenRepository {
  @override
  Future<SubCategoryModel?> getCategoriesDataFromDb(String categoryId) async {
    SubCategoryModel? subCategoryModel;

    await HiveService.getHive()
        .isExists(boxName: HiveConstant.categoryBox + categoryId)
        .then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(HiveConstant.categoryBox + categoryId)
            .then((value) {
          if (value is SubCategoryModel) {
            print("pankaj getCategoriesDataFromDb() " + "${value}");
            subCategoryModel = value as SubCategoryModel;
          }
        });
      }
    });

    return subCategoryModel;
  }

  @override
  Future<SubCategoryModel> getCategoriesData(
      String categoryId, String etag) async {
    SubCategoryModel subCategoryModel = await ApiClient().getSubCategoryData(
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken(),
        categoryId,
        etag);

    //if (subCategoryModel.error != 1)
    await HiveService.getHive()
        .addBoxes(subCategoryModel, HiveConstant.categoryBox + categoryId);
    /*return await ApiClient().getSubCategoryData(
      AppSizes.deviceWidth.toString(),
      await AppSharedPref.getWkToken(),
      categoryId,
    );*/
    return subCategoryModel;
  }

  @override
  Future<CatalogModel?> getCatalogProductsFromDb(
      CatalogProductRequest request) async {
    CatalogModel? catalogModel;
    String boxname = HiveConstant.catalogBox +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    print("pankaj ---->>>>>>>>" + boxname);
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(boxname
                /*HiveConstant.catalogBox + request.page! + request.path! +
            request.sort! + request.filter! + request.order!*/
                )
            .then((value) {
          if (value is CatalogModel) {
            print("pankaj getCatalogProductsFromDb()-- " +
                "${json.encode(value)}");
            catalogModel = value;
          }
        });
      }
    });

    return catalogModel;
  }

  @override
  Future<CatalogModel> getCatalogProducts(
      CatalogProductRequest request, String etag) async {
    CatalogModel? catalogModel = await ApiClient().getCatalogProducts(
        request.page!,
        request.limit!,
        request.width!,
        request.path!,
        request.sort,
        request.order,
        request.filter,
        request.token!,
        etag);
    String boxname = HiveConstant.catalogBox +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    print("pankaj ---->>>>>>>>add- " + boxname);
    await HiveService.getHive().addBoxes(catalogModel, boxname);
    return catalogModel;
  }

  @override
  Future<AddProductToWishListModel?> addToWishList(String productId) async {
    AddProductToWishListModel model = await ApiClient()
        .addProductToWishlist(productId, await AppSharedPref.getWkToken());
    return model;
  }
}
