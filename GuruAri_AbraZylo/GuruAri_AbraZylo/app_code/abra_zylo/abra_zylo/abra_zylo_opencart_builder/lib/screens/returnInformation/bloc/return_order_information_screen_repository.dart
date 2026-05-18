import 'dart:convert';

import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/returnOrderDetailModel/return_order_detail_model.dart';
import '../../../network_manager/api_client.dart';

abstract class ReturnOrderInformationScreenRepository {
  Future<ReturnOrderDetailModel> getReturnOrderDetail(String id);
}

class ReturnOrderInformationScreenRepositoryImp
    implements ReturnOrderInformationScreenRepository {
  @override
  Future<ReturnOrderDetailModel> getReturnOrderDetail(String id) async {
    return await ApiClient()
        .getReturnDetails(await AppSharedPref.getWkToken(), id);
  }
}
