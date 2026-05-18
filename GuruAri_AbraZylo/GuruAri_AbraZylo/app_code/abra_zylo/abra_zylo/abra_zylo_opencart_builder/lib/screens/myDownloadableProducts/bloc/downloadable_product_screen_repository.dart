import 'dart:convert';

import 'package:oc_demo/helper/app_shared_pref.dart';

import '../../../models/base_model.dart';
import '../../../models/downloadProductModel/download_product_model.dart';
import '../../../network_manager/api_client.dart';

abstract class DownloadableProductScreenRepository {
  Future<DownloadProductModel> getDownloadableProducts(String page);
}

class DownloadableProductScreenRepositoryImp
    implements DownloadableProductScreenRepository {
  @override
  Future<DownloadProductModel> getDownloadableProducts(String page) async {
    return await ApiClient()
        .getDownloadableProducts(await AppSharedPref.getWkToken(), "20", page);
  }
}
