import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/returnOrderListModel/return_order_list_model.dart';

import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';
import '../../../network_manager/api_client.dart';

abstract class ReturnOrderScreenRepository {
  Future<ReturnOrderListModel> getReturnOrders(String page, String etag);
  Future<ReturnOrderListModel?> getReturnFromDb(String page);
}

class ReturnOrderScreenRepositoryImp implements ReturnOrderScreenRepository {
  Future<ReturnOrderListModel?> getReturnFromDb(String page) async {
    ReturnOrderListModel? returnOrderListModel;
    String boxname = HiveConstant.returnOrder + page;
    print("pankaj ---->>>>>>>>" + boxname);
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxname).then((value) {
          if (value is ReturnOrderListModel) {
            print("pankaj getReturnFromDb()-- " + "${value}");
            returnOrderListModel = value as ReturnOrderListModel;
          }
        });
      }
    });

    return returnOrderListModel;
  }

  @override
  Future<ReturnOrderListModel> getReturnOrders(String page, String etag) async {
    ReturnOrderListModel? returnOrderListModel = await ApiClient()
        .getReturnOrderList(await AppSharedPref.getWkToken(), etag);
    await HiveService.getHive().addBoxes(returnOrderListModel,
        HiveConstant.returnOrder + page); //save return list data in hive db
    return returnOrderListModel;
  }
}
