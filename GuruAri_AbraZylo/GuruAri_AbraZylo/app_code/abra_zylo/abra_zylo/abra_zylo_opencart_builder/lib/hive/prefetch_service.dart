import 'dart:async';

import '../constants/app_constants.dart';
import '../helper/app_shared_pref.dart';
import '../models/catalog/brand/manufacture_model.dart';
import '../models/catalog/catalog_model.dart';
import '../models/productDetail/product_detail_screen_model.dart';
import '../models/sub_category/sub_category_model.dart';
import '../network_manager/api_client.dart';
import 'hive_constant.dart';
import 'hive_service.dart';

class PrefetchService {
  static bool preFetchEnable = false;
/*  Future<void> preFetchProductDetailsBackground(String? value) {
    return compute(preFetchProductDetails, value);
  }

  Future<void> preFetchCategoryDataBackground(String? value) {
    return compute(preFetchCategoryData, value);
  }

  Future<void>preFetchCategoryProductBackground(String? value) {
    return compute(preFetchCategoryProduct, value);
  }

  Future<void>preFetchManuffactureBackground(String? value) {
    return compute(preFetchManuffacture, value);
  }*/

  static Future<void> preFetchProductDetails(String? productId) async {
    if (preFetchEnable == true) {
      ProductDetailScreenModel? cacheModel;
      String etag = "";
      await HiveService.getHive()
          .isExists(boxName: HiveConstant.productPageBox + productId.toString())
          .then((value) async {
        if (value) {
          await HiveService.getHive()
              .getBoxes(HiveConstant.productPageBox + productId.toString())
              .then((value) {
            if (value is ProductDetailScreenModel) {
              cacheModel = value;
            }
          });
        }
      });

      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? "";
      }

      ProductDetailScreenModel productDetailScreenModel =
          await ApiClient(showError: false).getProductDetail(
              AppSizes.deviceWidth.toString(),
              productId.toString(),
              "",
              await AppSharedPref.getWkToken(),
              etag);
      await HiveService.getHive().addBoxes(productDetailScreenModel,
          HiveConstant.productPageBox + productId.toString());
    }
  }

  static Future<void> preFetchCategoryData(String? categoryId) async {
    if (preFetchEnable == true) {
      String etag = "";
      SubCategoryModel? cacheModel;

      await HiveService.getHive()
          .isExists(boxName: HiveConstant.categoryBox + categoryId!)
          .then((value) async {
        if (value) {
          await HiveService.getHive()
              .getBoxes(HiveConstant.categoryBox + categoryId)
              .then((value) {
            if (value is SubCategoryModel) {
              cacheModel = value;
            }
          });
        }
      });
      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? "";
      }

      SubCategoryModel subCategoryModel = await ApiClient(showError: false)
          .getSubCategoryData(AppSizes.deviceWidth.toString(),
              await AppSharedPref.getWkToken(), categoryId ?? "", etag);
      // if(subCategoryModel.error!=1){
      await HiveService.getHive()
          .addBoxes(subCategoryModel, HiveConstant.categoryBox + categoryId);

      PrefetchService.preFetchCategoryProduct(categoryId);
    }
  }

  static Future<void> preFetchCategoryProduct(String? path) async {
    if (preFetchEnable == true) {
      String etag = "";

      CatalogModel? cacheModel;
      String boxname =
          HiveConstant.catalogBox + "1" + (path ?? '') + "" + "" + "";

      await HiveService.getHive()
          .isExists(boxName: boxname)
          .then((value) async {
        if (value) {
          await HiveService.getHive()
              .getBoxes(boxname
                  /*HiveConstant.catalogBox + request.page! + request.path! +
              request.sort! + request.filter! + request.order!*/
                  )
              .then((value) {
            if (value is CatalogModel) {
              cacheModel = value;
            }
          });
        }
      });

      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? "";
      }

      CatalogModel? catalogModel = await ApiClient(showError: false)
          .getCatalogProducts("1", "10", AppSizes.deviceWidth.toString(), path!,
              "", "", "", AppSharedPref.wkToken, etag);
      if (catalogModel.error != 1) {
        await HiveService.getHive().addBoxes(catalogModel, boxname);
      }
    }
  }

  static Future<void> preFetchManuffacture(String? manufactureId) async {
    if (preFetchEnable == true) {
      String etag = "";

      ManufactureModel? cacheModel;
      String boxnames = HiveConstant.manufacturerInfo + (manufactureId ?? '');

      await HiveService.getHive()
          .isExists(boxName: HiveConstant.manufacturerInfo)
          .then((value) async {
        if (value) {
          await HiveService.getHive().getBoxes(boxnames).then((value) {
            if (value is ManufactureModel) {
              cacheModel = value as ManufactureModel;
            }
          });
        }
      });

      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? "";
      }

      ManufactureModel model = await ApiClient(showError: false)
          .manufactureInfo("1", "10", AppSizes.deviceWidth.toString(),
              manufactureId!, "", "", AppSharedPref.wkToken, etag);

      await HiveService.getHive().addBoxes(model, boxnames);
    }
  }

  static Future<void> preFetchBestProductsFromDb() async {
    if (preFetchEnable == true) {
      CatalogModel? cacheModel;
      String etag = "";
      String boxname = HiveConstant.bestProduct + "1" + "" + "" + "" + "";

      await HiveService.getHive()
          .isExists(boxName: boxname)
          .then((value) async {
        if (value) {
          await HiveService.getHive().getBoxes(boxname).then((value) {
            if (value is CatalogModel) {
              cacheModel = value as CatalogModel;
            }
          });
        }
      });

      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? '';
      }
      CatalogModel? catalogModel = await ApiClient()
          .bestProducts("1", "", "", "", "", "", "", "", etag ?? '');
      if (catalogModel.error != 1) {
        await HiveService.getHive().addBoxes(catalogModel, boxname);
      }
    }
  }

  static Future<void> preFetchPopularProductsFromDb() async {
    if (preFetchEnable == true) {
      CatalogModel? cacheModel;
      String etag = "";
      String boxname = HiveConstant.popularProduct + "1" + "" + "" + "" + "";

      await HiveService.getHive()
          .isExists(boxName: boxname)
          .then((value) async {
        if (value) {
          await HiveService.getHive().getBoxes(boxname).then((value) {
            if (value is CatalogModel) {
              cacheModel = value as CatalogModel;
            }
          });
        }
      });

      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? '';
      }
      CatalogModel? catalogModel = await ApiClient()
          .popularProducts("1", "", "", "", "", "", "", "", etag ?? '');
      if (catalogModel.error != 1) {
        await HiveService.getHive().addBoxes(catalogModel, boxname);
      }
    }
  }

  static Future<void> preFetchFeatureProductsFromDb() async {
    if (preFetchEnable == true) {
      CatalogModel? cacheModel;
      String etag = "";
      String boxname = HiveConstant.featureProduct + "1" + "" + "" + "" + "";

      await HiveService.getHive()
          .isExists(boxName: boxname)
          .then((value) async {
        if (value) {
          await HiveService.getHive().getBoxes(boxname).then((value) {
            if (value is CatalogModel) {
              cacheModel = value as CatalogModel;
            }
          });
        }
      });

      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? '';
      }
      CatalogModel? catalogModel = await ApiClient()
          .featured("1", "10", "", "", '', '', '', '', etag ?? '');

      if (catalogModel.error != 1) {
        await HiveService.getHive().addBoxes(catalogModel, boxname);
      }
    }
  }

  static Future<void> preFetchLatestProductsFromDb() async {
    if (preFetchEnable == true) {
      CatalogModel? cacheModel;
      String etag = "";
      String boxname = HiveConstant.latestProduct + "1" + "" + "" + "" + "";

      await HiveService.getHive()
          .isExists(boxName: boxname)
          .then((value) async {
        if (value) {
          await HiveService.getHive().getBoxes(boxname).then((value) {
            if (value is CatalogModel) {
              cacheModel = value as CatalogModel;
            }
          });
        }
      });

      if (cacheModel != null) {
        etag = cacheModel?.eTag ?? '';
      }

      CatalogModel? catalogModel = await ApiClient()
          .latestProduct("1", "10", "", "", '', '', '', '', etag ?? '');
      if (catalogModel.error != 1) {
        await HiveService.getHive().addBoxes(catalogModel, boxname);
      }
    }
  }
}
