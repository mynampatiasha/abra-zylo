import 'dart:convert';

import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../network_manager/api_client.dart';

abstract class SubCategoryRepository {
  Future<SubCategoryModel?> getSubCategoryData(String categoryId, String etag);

  Future<CatalogModel?> getCategoryProducts(
      CatalogProductRequest request, String etag);
  Future<SubCategoryModel?> getCategoriesDataFromDb(String categoryId);

  Future<CatalogModel?> getCatalogProductsFromDb(CatalogProductRequest request);
  Future<AddProductToWishListModel?> addToWishList(String productId);
}

class SubCategoryRepositoryImp implements SubCategoryRepository {
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
            print(" getCategoriesDataFromDb()-------- " + "${value}");
            subCategoryModel = value as SubCategoryModel;
          }
        });
      }
    });

    return subCategoryModel;
  }

  @override
  Future<SubCategoryModel?> getSubCategoryData(
      String categoryId, String etag) async {
    SubCategoryModel subCategoryModel = await ApiClient().getSubCategoryData(
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken(),
        categoryId,
        etag);

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
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(
                boxname /*HiveConstant.catalogBox + request.page! + request.path! +
            request.sort! + request.filter! + request.order!*/
                )
            .then((value) {
          if (value is CatalogModel) {
            print(" getCatalogProductsFromDb()-- " + "${json.encode(value)}");
            catalogModel = value as CatalogModel;
          }
        });
      }
    });

    return catalogModel;
  }

  @override
  Future<CatalogModel?> getCategoryProducts(
      CatalogProductRequest request, String etag) async {
    /*   return await ApiClient().getCatalogProducts(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.filter,
      request.token!,
        etag
    );*/
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
